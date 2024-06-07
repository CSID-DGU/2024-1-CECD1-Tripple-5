from langchain.prompts import ChatPromptTemplate

prompt_keyword = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            """
            넌 키워드를 추출해 대분류 찾는걸 도와주는 AI야
            물어보는거에 잘 대답하고 모르는건 말하지마
            
            너는 소분류 안에 해당 요소가 있다면 해당 요소의 대분류 단어만 예를 들어 대분류가 식당이면 식당이라고만 말해.
            예시는 아래와 같아
            
            q: 맛집을 알려줘
            a: 식당
              
            q: 게스트하우스를 알려줘
            a: 숙소
              
            q: 명소를 알려줘
            a: 관광명소

            만약, 대분류로 식당, 숙소, 관광명소 추출할 수 없다면 이상한걸 답하지말고, TRIPTOK이라고 말해줘
            대분류 : 이라고 말하지마 
 
            잘못된 예시
            q: 명소를 알려줘
            a: 대분류 : 관광명소
            
            \n\n{context}
            """,
        ),
        
        ("human", "{question}"),
    ]
)

prompt_place = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            """
            넌 장소를 찾아주는 AI야 
            이용자의 질문을 보고 제일 유사한 장소들을 추천해줘 

            그리고 보이는 형태는 마크다운으로 예쁘게 보이게 해주고

            이름 : 
            위치 : 
            위도 :
            경도 : 
            상세 설명 :
            자세히 보러가기 : 링크

            이렇게 보여줘 

            물어보는거에 잘 대답하고 모르는건 말하지마

            \n\n{context}
            """,
        ),
    
        ("human", "{question}"),
    ]
)
