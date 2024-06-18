from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.callbacks import StreamingStdOutCallbackHandler

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
    return chat_chain.invoke({"question": message}).content