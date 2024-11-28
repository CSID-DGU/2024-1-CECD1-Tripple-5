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

from sqlalchemy import select
from ..google_maps_platform_service import get_reverse_geocoding
from ...entity.model import place_model
from sqlalchemy.ext.asyncio import AsyncSession

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
            "x": float(row['x']),
            "y": float(row['y'])
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
사용자의 질문에 친절하게 답변하고, 주어진 정보를 바탕으로 추천 장소를 JSON 형식으로 순서대로 구조화하여 응답해주세요.
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
  - coordinates (위치 정보 x: float, y: float 필드 포함)
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
            embedding_function=embeddings,
            collection_name="seoul_places"
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

# 개별 문서를 처리하는 함수 추가
def process_retrieved_documents(retrieved_docs): 
    processed_docs = []  
    for doc in retrieved_docs: 
        original_content = doc.page_content  
        try: 
            doc_json = json.loads(original_content)  
            doc_json['additional_info'] = "This is processed data"  
            processed_docs.append(doc_json) 
        except json.JSONDecodeError:  
            processed_docs.append({"raw_content": original_content, "error": "Failed to parse JSON"})  
    return processed_docs 

# get_recommendation 함수를 비동기로 변환
async def get_recommendation_async(db: AsyncSession, qa_chain, query, location_str, user_characteristic):
    try:
        return_dict = {"content":None, "place_id_list": None}
        # ConversationalRetrievalChain의 __call__은 동기적으로 작동하므로, asyncio의 run_in_executor를 사용하여 비동기 호출
        question = f"여행자의 현재 위치: {location_str} \n\n여행자 현재 특성: {user_characteristic} \n\n사용자 질문: {query}"

        result = await asyncio.get_event_loop().run_in_executor(None, qa_chain, {"question": question})
        answer_text = result["answer"]

        source_documents = result.get("source_documents", [])  # [수정됨]
        processed_documents = process_retrieved_documents(source_documents)  # [수정됨]
        # print(processed_documents)

        place_ids = []
        for processed_document in processed_documents:
            place_url = processed_document.get('place_url')
            result_02 = await db.execute(
                select(place_model.Place)
                .where(place_model.Place.place_url==place_url)
            )
            place = result_02.scalar_one_or_none()
            if not place:
                raise HTTPException(status_code=404, detail=f"place with place_url {place_url} not found.")
            place_ids.append(place.id)
            
        place_ids_str = None
        if len(place_ids)==3:
            place_ids_str=f"{place_ids[0]},{place_ids[1]},{place_ids[2]}"
        else:
            raise HTTPException(status_code=404, detail=f"RAG place cnt not 3")

        return_dict['place_ids_str'] = place_ids_str
        print(f"@@@@@@@ {place_ids_str}")

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
            return_dict['content'] = {
                "status": "success",
                "message": answer_text[:json_start].strip() if json_start != -1 else "",
                "data": answer_json
            }
            return return_dict
        except json.JSONDecodeError:
            raise HTTPException(status_code=404, detail="JSON 파싱 실패")
    except Exception as e:
        raise HTTPException(status_code=404, detail=f"str({e})")
    
async def get_chatbot_response_about_user_input_async(db: AsyncSession,input_text: str, x: float, y: float, user_characteristic: str):
    location_str = await get_reverse_geocoding(x=x, y=y)

    result = await get_recommendation_async(db, qa_chain, input_text, location_str, user_characteristic)
    result_content = result['content']
    response = json.dumps(result_content, ensure_ascii=False, indent=2)
    result['content'] = response
    print(result)
    return result