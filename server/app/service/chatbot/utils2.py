import os
import json
from langchain.document_loaders import UnstructuredFileLoader
from .prompts import prompt_keyword, prompt_place
from langchain.embeddings import CacheBackedEmbeddings, OpenAIEmbeddings
from langchain.storage import LocalFileStore
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores.faiss import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.callbacks.base import BaseCallbackHandler
from langchain.schema.runnable import RunnableLambda, RunnablePassthrough
from fastapi.responses import JSONResponse

class ChatCallbackHandler(BaseCallbackHandler):
    def __init__(self, session_state, *args, **kwargs):
        self.tokens = ""
        self.session_state = session_state

    def on_llm_start(self, *args, **kwargs):
        self.tokens = ""

    def on_llm_end(self, *args, **kwargs):
        save_message(self.session_state, role="ai", message=self.tokens)

    def on_llm_new_token(self, token, *args, **kwargs):
        self.tokens += token

def init_llm(chat_callback: bool, session_state=None):
    if chat_callback and session_state is not None:
        callbacks = [ChatCallbackHandler(session_state)]
    else:
        callbacks = []

    return ChatOpenAI(
        temperature=0.1,
        streaming=True,
        callbacks=callbacks,
    )

async def embed_file(file):
    file_content = await file.read()
    file_path = f"./.cache/files/{file.filename}"
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "wb") as f:
        f.write(file_content)
    cache_dir = LocalFileStore(f"./.cache/embeddings/{file.filename}")
    splitter = CharacterTextSplitter.from_tiktoken_encoder(
        separator="\n",
        chunk_size=600,
        chunk_overlap=100,
    )
    loader = UnstructuredFileLoader(file_path)
    docs = loader.load_and_split(text_splitter=splitter)
    embeddings = OpenAIEmbeddings()
    cached_embeddings = CacheBackedEmbeddings.from_bytes_store(
        embeddings, cache_dir)
    vector_store = FAISS.from_documents(docs, cached_embeddings)
    retriever = vector_store.as_retriever()
    return retriever

def create_retriever(file_path):
    cache_dir = LocalFileStore(f"./.cache/embeddings/{file_path}")
    print(file_path)
    print(cache_dir)
    splitter = CharacterTextSplitter.from_tiktoken_encoder(
        separator="\n",
        chunk_size=600,
        chunk_overlap=100,
    )
    loader = UnstructuredFileLoader(file_path)
    print(f"LOADER : f{loader}")
    docs = loader.load_and_split(text_splitter=splitter)
    embeddings = OpenAIEmbeddings()
    cached_embeddings = CacheBackedEmbeddings.from_bytes_store(
        embeddings, cache_dir)
    vector_store = FAISS.from_documents(docs, cached_embeddings)
    retriever = vector_store.as_retriever()
    return retriever

def save_message(session_state, message, role):
    session_state["messages"].append({"message": message, "role": role})

def send_message(session_state, message, role, save=True):
    if save:
        save_message(session_state, message, role)



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
        # print("-------------------------------------------------")
        # print(content)
        # print("-------------------------------------------------")
        response_json = json.loads(content)
        print(response_json)
        return content 
    except json.JSONDecodeError:
        return "잘못된 JSON 응답입니다."

# Pre-embed files and create retrievers
retriever_map = {
    "keyword": create_retriever("./.cache/files/keyword.txt"),
    "관광명소": create_retriever("./.cache/files/관광명소.txt"),
    "식당": create_retriever("./.cache/files/식당.txt"),
    "숙소": create_retriever("./.cache/files/숙소.txt")
}

llm = init_llm(chat_callback=True)
