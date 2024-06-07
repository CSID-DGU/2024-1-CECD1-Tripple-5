from langchain.document_loaders import UnstructuredFileLoader
from langchain.embeddings import CacheBackedEmbeddings, OpenAIEmbeddings
from langchain.schema.runnable import RunnableLambda, RunnablePassthrough
from langchain.storage import LocalFileStore
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores.faiss import FAISS
from langchain.chat_models import ChatOpenAI
from langchain.callbacks.base import BaseCallbackHandler
import streamlit as st
from langchain.memory import ConversationSummaryBufferMemory
from langchain.prompts import PromptTemplate, ChatPromptTemplate, MessagesPlaceholder

st.set_page_config(
    page_title="DocumentGPT",
    page_icon="📃",
)


@st.cache_resource
def init_llm(chat_callback: bool):
    if chat_callback == True:

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

        callbacks = [ChatCallbackHandler()]
    else:
        callbacks = []

    return ChatOpenAI(
        temperature=0.1,
        streaming=True,
        callbacks=callbacks,
    )


llm = init_llm(chat_callback=True)
llm_for_memory = init_llm(chat_callback=False)


@st.cache_resource
def init_memory(_llm):
    return ConversationSummaryBufferMemory(
        llm=_llm, max_token_limit=60, return_messages=True, memory_key="chat_history"
    )


memory = init_memory(llm_for_memory)


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


def save_message(message, role):
    st.session_state["messages"].append({"message": message, "role": role})


def send_message(message, role, save=True):
    with st.chat_message(role):
        st.markdown(message)
    if save:
        save_message(message, role)


def paint_history():
    for message in st.session_state["messages"]:
        send_message(
            message["message"],
            message["role"],
            save=False,
        )


def format_docs(docs):
    return "\n\n".join(document.page_content for document in docs)


def load_memory(_):
    return memory.load_memory_variables({})["chat_history"]


prompt = ChatPromptTemplate.from_messages(
    [
        (
            "system",
            "넌 사람을 돕는 AI야 물어보는거에 잘 대답하고 모르는건 말하지마 make it up:\n\n{context}",
        ),
        MessagesPlaceholder(variable_name="chat_history"),
        ("human", "{question}"),
    ]
)


st.title("DocumentGPT")

st.markdown(
    """
Welcome!
            
Use this chatbot to ask questions to an AI about your files!

Upload your files on the sidebar.
"""
)

with st.sidebar:
    file = st.file_uploader(
        "Upload a .txt .pdf or .docx file",
        type=["pdf", "txt", "docx"],
    )

if file:
    retriever = embed_file(file)
    send_message("I'm ready! Ask away!", "ai", save=False)
    paint_history()
    message = st.chat_input("Ask anything about your file...")
    if message:
        send_message(message, "human")
        chain = (
            {
                "context": retriever
                | RunnableLambda(
                    lambda docs: "\n\n".join(doc.page_content for doc in docs)
                ),
                "question": RunnablePassthrough(),
                "chat_history": load_memory,
            }
            | prompt
            | llm
        )
        with st.chat_message("ai"):
            content = chain.invoke(message).content
            memory.save_context({"input": message}, {"output": content})
            st.write(memory)


else:
    st.session_state["messages"] = []