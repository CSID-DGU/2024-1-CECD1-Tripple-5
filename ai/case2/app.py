import streamlit as st
from utils import init_llm, embed_file, keyword_retriever, place_retriever, save_message, send_message, paint_history, hotel_retriever,retaurant_retriever
from langchain.schema.runnable import RunnableLambda, RunnablePassthrough
from prompts import prompt_keyword, prompt_place

st.set_page_config(
    page_title="TraveTalk",
    page_icon="🌍",
)

llm = init_llm(chat_callback=True)

st.title("🏝️TraveTalk")

st.markdown(
    """
반갑습니다!

TraveTalk은 키워드 기반 여행지 추천해주는 챗봇입니다.
"""
)

# keyword file upload
with st.sidebar:
    st.write("Keyword file을 업로드 해주세요.")
    file = st.file_uploader(
        "Upload a .txt .pdf or .docx file",
        type=["pdf", "txt", "docx"],
    )

if file:
    retriever = embed_file(file)
    keyword_retriever = keyword_retriever()
    place_retriever = place_retriever()
    retaurant_retriever = retaurant_retriever()
    hotel_retriever = hotel_retriever()
    send_message("키워드를 학습했습니다. 어떤 장소를 추천해드릴까요?", "ai", save=False)
    paint_history()
    message = st.chat_input("Ask anything about your file...")
    if message:
        send_message(message, "human")
        chain = (
            {
                "context": keyword_retriever
                | RunnableLambda(
                    lambda docs: "\n\n".join(doc.page_content for doc in docs)
                ),
                "question": RunnablePassthrough(),
            }
            | prompt_keyword
            | llm
        )
        with st.chat_message("ai"):
            content = chain.invoke(message).content
            # 생성된 content 토대로 추가 RAG 진행 
            if "대분류 : " in content:
                content = content.replace("대분류 : ", "")
        
        content = content.strip()
        if content == "관광명소":
            chain = (
                {
                    "context": place_retriever
                    | RunnableLambda(
                        lambda docs: "\n\n".join(doc.page_content for doc in docs)
                    ),
                    "question": RunnablePassthrough(),
                }
                | prompt_place
                | llm
            )
        elif content == "식당":
             chain = (
                {
                    "context": retaurant_retriever
                    | RunnableLambda(
                        lambda docs: "\n\n".join(doc.page_content for doc in docs)
                    ),
                    "question": RunnablePassthrough(),
                }
                | prompt_place
                | llm
            )
        elif content == "숙소":
            chain = (
                {
                    "context": hotel_retriever
                    | RunnableLambda(
                        lambda docs: "\n\n".join(doc.page_content for doc in docs)
                    ),
                    "question": RunnablePassthrough(),
                }
                | prompt_place
                | llm
            )
        with st.chat_message("ai"):
            content = chain.invoke(message).content
else:
    st.session_state["messages"] = []
