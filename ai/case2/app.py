import streamlit as st
from retrieval_system import query_chain

st.title("Keyword Retrieval System")

question = st.text_input("Enter your query:")



if question:
    with st.spinner("Fetching answer..."):
        answer = query_chain(question)
    st.write("Answer:", answer)
