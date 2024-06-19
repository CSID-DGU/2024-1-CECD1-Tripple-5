from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.callbacks import StreamingStdOutCallbackHandler

from .utils2 import init_llm, embed_file, create_retriever, save_message, send_message, generate_chain, handle_message, retriever_map, llm
from .prompts import prompt_keyword

from .prompts import prompt_keyword, prompt_place
from fastapi.responses import JSONResponse

chat = ChatOpenAI(
    temperature=0.1,
    streaming=True,
    # callbacks=[
    #     StreamingStdOutCallbackHandler(),
    # ],
)

chat_prompt = ChatPromptTemplate.from_messages(
    [
        ("system","",),
        ("human", "{question}"),
    ]
)

chat_chain = chat_prompt | chat

async def get_response_from_chatgpt(message):
    # message
    chain = generate_chain(retriever_map["keyword"], prompt_keyword)
    keyword = chain.invoke(message).content
    if "대분류 : " in keyword:
        keyword = keyword.replace("대분류 : ", "").strip()
    print("추출된 키워드 ------------------ : ", keyword)
    # keyword 추출하기 
    if keyword in retriever_map:
        return handle_message(message, keyword)
    else:
        return "잘못된 입력입니다. 다시 시도해주세요."

    # message
    # return chat_chain.invoke({"question": message}).content