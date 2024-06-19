import streamlit as st
from utils import init_llm, embed_file, create_retriever, save_message, send_message, paint_history
from langchain.schema.runnable import RunnableLambda, RunnablePassthrough
from prompts import prompt_keyword, prompt_place
import json

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

# Initialize session state
if "messages" not in st.session_state:
    st.session_state["messages"] = []

# Pre-embed files and create retrievers
retriever_map = {
    "keyword": create_retriever("./.cache/files/keyword.txt"),
    "관광명소": create_retriever("./.cache/files/관광명소.txt"),
    "식당": create_retriever("./.cache/files/식당.txt"),
    "숙소": create_retriever("./.cache/files/숙소.txt")
}

def generate_chain(retriever, prompt):
    return (
        {
            "context": retriever
            | RunnableLambda(
                lambda docs: "\n\n".join(doc.page_content for doc in docs)
            ),
            "question": RunnablePassthrough(),
        }
        | prompt
        | llm
    )

def handle_message(message, content_type):
    retriever = retriever_map.get(content_type)
    chain = generate_chain(retriever, prompt_place)
    content = chain.invoke(message).content
    try:
        response_json = json.loads(content)
        st.json(response_json)  # JSON 응답을 출력
    except json.JSONDecodeError:
        send_message("잘못된 JSON 응답입니다.", "ai")

send_message("키워드를 학습했습니다. 어떤 장소를 추천해드릴까요?", "ai", save=False)
paint_history()
message = st.chat_input("Ask anything about your file...")
if message:
    send_message(message, "human")
    chain = generate_chain(retriever_map["keyword"], prompt_keyword)
    content = chain.invoke(message).content
    if "대분류 : " in content:
        content = content.replace("대분류 : ", "").strip()
    
    if content in retriever_map:
        handle_message(message, content)
    else:
        send_message("잘못된 입력입니다. 다시 시도해주세요.", "ai")
