from fastapi import HTTPException
import pandas as pd
from langchain.vectorstores import Chroma
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory
from langchain.embeddings import OpenAIEmbeddings
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv
import json
import os
import asyncio
from ..google_maps_platform_service import get_reverse_geocoding

# 환경 변수 로드 (OPENAI_API_KEY 등)
load_dotenv()

# OpenAI API 키 설정
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

# 데이터 로드
restaurants_df = pd.read_csv('data/restaurants.csv')
accommodations_df = pd.read_csv('data/accommodations.csv')
attractions_df = pd.read_csv('data/tourist_attractions.csv')

# 각 데이터프레임에 'type' 열 추가
restaurants_df['type'] = 'restaurant'
accommodations_df['type'] = 'accommodation'
attractions_df['type'] = 'attraction'

# 데이터프레임 결합
places_df = pd.concat([
    restaurants_df,
    accommodations_df,
    attractions_df
], ignore_index=True)

# 문서 생성 (JSON 형식으로)
documents = []

for _, row in places_df.iterrows():
    doc = json.dumps({
        "place_name": row['place_name'],
        "type": row['type'],
        "category_group_name": row['category_group_name'],
        "category_name": row['category_name'],
        "coordinates": {
            "x": row['x'],
            "y": row['y']
        },
        "road_address_name": row['road_address_name'],
        "place_url": row['place_url'],
        "estimated_cost": row['estimated_cost'],
        "estimated_duration": row['estimated_duration'],
        "visitor_characteristics": row['visitor_characteristics']
    }, ensure_ascii=False)
    documents.append(doc)

def create_qa_chain(documents):
    prompt_template = """당신은 서울의 장소를 추천해주는 여행 가이드입니다.
사용자의 질문에 친절하게 답변하고, 주어진 정보를 바탕으로 추천 장소를 JSON 형식으로 구조화하여 응답해주세요.
무조건 JSON 형식으로 응답해주세요. JSON은 ```json``` 코드 블록 안에 작성해주세요.

참고할 장소 정보:
{context}

{question}

이전 대화 내용:
{chat_history}

먼저 사용자에게 친절한 답변을 제공합니다. 그 후에, 다음 정보를 포함하여 추천 장소 목록을 JSON 형식으로 제공합니다:
- recommendations: 추천 장소 목록 (최대 3개만 제공해주세요. 그 이상을 제공하지 마세요.)
  - place_name (장소명)
  - type (장소 유형: restaurant/accommodation/attraction)
  - category_group_name (카테고리 그룹)
  - category_name (상세 카테고리)
  - coordinates (위치 정보: x, y)
  - road_address_name (도로명 주소)
  - place_url (장소 URL)
  - estimated_cost (예상 비용)
  - estimated_duration (예상 소요시간)
  - visitor_characteristics (방문자 특성)
  - recommendation_reason (추천 이유)
"""

    PROMPT = PromptTemplate(
        template=prompt_template,
        input_variables=["context", "chat_history", "question"]
    )

    # 임베딩 초기화
    embeddings = OpenAIEmbeddings()

    # 벡터스토어 저장 디렉토리 설정
    persist_directory = "final_embeddings2"

    # 'final_embeddings' 폴더가 존재하지 않으면 생성
    if not os.path.exists(persist_directory):
        os.makedirs(persist_directory)

    # 벡터스토어 로드 또는 생성
    if os.listdir(persist_directory):
        # 이미 저장된 임베딩이 있으면 로드
        vector_store = Chroma(
            persist_directory=persist_directory,
            embedding_function=embeddings
        )
    else:
        # 임베딩 생성 및 저장
        vector_store = Chroma.from_texts(
            texts=documents,
            embedding=embeddings,
            persist_directory=persist_directory,
            collection_name="seoul_places"
        )
        vector_store.persist()  # 임베딩 저장

    memory = ConversationBufferMemory(
        memory_key="chat_history",  # 메모리 키 설정
        return_messages=True,       # 이전 대화를 반환
        output_key="answer"         # 메모리에 저장할 키 지정
    )

    llm = ChatOpenAI(
        temperature=0.7,
        model_name="gpt-4o"  # 올바른 모델 이름으로 수정
    )

    qa_chain = ConversationalRetrievalChain.from_llm(
        llm=llm,
        retriever=vector_store.as_retriever(search_kwargs={"k": 3}),
        memory=memory,  # memory 객체 전달
        combine_docs_chain_kwargs={
            'prompt': PROMPT,
            'document_variable_name': 'context'
        },
        return_source_documents=True,
        verbose=False,
        output_key="answer"  # 메모리에 저장할 키 지정
    )

    return qa_chain


# QA 체인 초기화
qa_chain = create_qa_chain(documents)


# get_recommendation 함수를 비동기로 변환
async def get_recommendation_async(qa_chain, query, location_str, user_characteristic):
    try:
        # ConversationalRetrievalChain의 __call__은 동기적으로 작동하므로, asyncio의 run_in_executor를 사용하여 비동기 호출
        question = f"여행자의 현재 위치: {location_str} \n\n여행자 현재 특성: {user_characteristic} \n\n사용자 질문: {query}"
        # print(f"@@@@@@@@@@ {question}")

        result = await asyncio.get_event_loop().run_in_executor(None, qa_chain, {"question": question})
        answer_text = result["answer"]
        
        # 디버깅을 위해 모델의 응답 출력
        # print("Raw Answer Text:", answer_text)  # 디버깅용 출력

        # JSON 부분 찾기
        json_start = answer_text.find('```json')
        json_end = answer_text.rfind('```')
        
        if json_start != -1 and json_end != -1:
            # JSON 문자열 추출 및 파싱
            json_str = answer_text[json_start + 7:json_end].strip()
        else:
            # 코드 블록이 없을 경우 전체 텍스트를 JSON으로 시도
            json_str = answer_text.strip()
        
        try:
            answer_json = json.loads(json_str)
            return {
                "status": "success",
                "message": answer_text[:json_start].strip() if json_start != -1 else "",
                "data": answer_json
            }
        except json.JSONDecodeError:
            raise HTTPException(status_code=404, detail="JSON 파싱 실패")
            # return {
            #     "status": "error",
            #     "message": "JSON 파싱 실패",
            #     "raw_response": answer_text
            # }
    except Exception as e:
        raise HTTPException(status_code=404, detail=f"str({e})")
        # return {
        #     "status": "error",
        #     "message": str(e)
        # }
    
async def get_chatbot_response_about_user_input_async(input_text: str, x: float, y: float, user_characteristic: str):
    location_str = await get_reverse_geocoding(x=x, y=y)

    # 위치 정보 받아오기
    # print(f"(x, y) -> {location_str}")

    location_str

    # 추천 받기
    # print("get_recommendation_async 실행 전")

    result = await get_recommendation_async(qa_chain, input_text, location_str, user_characteristic)
    
    # print(f"get_recommendation_async 실행 후: {result}")

    response = json.dumps(result, ensure_ascii=False, indent=2)

    # JSON 출력
    # print(response)
    # print("json.dumps 실행 후: "+response)

    return response