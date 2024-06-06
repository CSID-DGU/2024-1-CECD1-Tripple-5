from langchain.chat_models import ChatOpenAI 
from langchain.document_loaders import UnstructuredFileLoader 
from langchain.text_splitter import CharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings, CacheBackedEmbeddings
from langchain.vectorstores import FAISS
from langchain.storage import LocalFileStore
from langchain.prompts import ChatPromptTemplate
from langchain.schema.runnable import RunnablePassthrough

llm = ChatOpenAI(
    temperature=0.1,
)

cache_dir = LocalFileStore("./.cache/")

spliter = CharacterTextSplitter.from_tiktoken_encoder(
    separator="\n",
    chunk_size=600,
    chunk_overlap=100,
)

loader = UnstructuredFileLoader("./files/keyword.txt")

docs = loader.load_and_split(text_splitter=spliter)

embeddings = OpenAIEmbeddings()

cache_embeddings = CacheBackedEmbeddings.from_bytes_store(
    embeddings,
    cache_dir,
)

vectorstore = FAISS.from_documents(docs, cache_embeddings)

retriever = vectorstore.as_retriever()

prompt = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            """
            You are a helpful keyword extract assistant. Answer questions using only the following context. If you don't know the answer just say you don't know, don't make it up.
            소분류 안에 해당 요소가 있다면 해당 요소의 대분류 단어만 예를 들어 대분류가 식당이면 식당이라고만 말해.
            예시는 아래와 같아
            
            q: 맛집을 알려줘
            a: 식당
              
            q: 게스트하우스를 알려줘
            a: 숙소
              
            q: 명소를 알려줘
            a: 관광지
            
            만약, 대분류로 식당, 숙소,관광지 추출할 수 없다면 이상한걸 답하지말고, TRIPTOK이라고 말해줘\n\n{context}
            """,
        ),
        ("human", "{question}"),
    ]
)

chain = {"context": retriever, "question": RunnablePassthrough()} | prompt | llm 

def query_chain(question):
    return chain.invoke(question).content
