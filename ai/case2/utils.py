import streamlit as st
from langchain.document_loaders import UnstructuredFileLoader
from langchain.embeddings import CacheBackedEmbeddings, OpenAIEmbeddings
from langchain.storage import LocalFileStore
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores.faiss import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.callbacks.base import BaseCallbackHandler

class ChatCallbackHandler(BaseCallbackHandler):
    def __init__(self, *args, **kwargs):
        self.tokens = ""

    def on_llm_start(self, *args, **kwargs):
        self.messagebox = st.empty()
        self.tokens = ""

    def on_llm_end(self, *args, **kwargs):
        save_message(role="ai", message=self.tokens)

    def on_llm_new_token(self, token, *args, **kwargs):
        self.tokens += token
        with self.messagebox:
            st.write(self.tokens)

@st.cache_resource
def init_llm(chat_callback: bool):
    if chat_callback:
        callbacks = [ChatCallbackHandler()]
    else:
        callbacks = []

    return ChatOpenAI(
        temperature=0.1,
        streaming=True,
        callbacks=callbacks,
    )

@st.cache_data(show_spinner="Embedding file...")
def embed_file(file):
    file_content = file.read()
    file_path = f"./.cache/files/{file.name}"
    with open(file_path, "wb") as f:
        f.write(file_content)
    cache_dir = LocalFileStore(f"./.cache/embeddings/{file.name}")
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

def save_message(message, role):
    st.session_state["messages"].append({"message": message, "role": role})

def send_message(message, role, save=True):
    if role == "ai":
        st.chat_message(role).markdown(message)
    else:
        st.chat_message(role).markdown(message)
    if save:
        save_message(message, role)

def paint_history():
    for message in st.session_state["messages"]:
        if message["role"] == "ai":
            st.chat_message("ai").markdown(message["message"])
        else:
            st.chat_message("human").markdown(message["message"])
