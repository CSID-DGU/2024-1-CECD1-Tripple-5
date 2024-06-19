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
        self.tokens = ""

    def on_llm_end(self, *args, **kwargs):
        pass

    def on_llm_new_token(self, token, *args, **kwargs):
        self.tokens += token

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

def create_retriever(file_path):
    cache_dir = LocalFileStore(f"./.cache/embeddings/{file_path.split('/')[-1]}")
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
