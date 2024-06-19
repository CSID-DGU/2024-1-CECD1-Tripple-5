from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Dict
import json
from utils import init_llm, create_retriever
from langchain.schema.runnable import RunnableLambda, RunnablePassthrough
from prompts import prompt_keyword, prompt_place

app = FastAPI()

# Initialize LangChain LLM
llm = init_llm(chat_callback=False)

# Pre-embed files and create retrievers
retriever_map = {
    "keyword": create_retriever("./.cache/files/keyword.txt"),
    "관광명소": create_retriever("./.cache/files/관광명소.txt"),
    "식당": create_retriever("./.cache/files/식당.txt"),
    "숙소": create_retriever("./.cache/files/숙소.txt")
}

class ChatMessage(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    messages: List[ChatMessage]

chat_history = []

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
    content = chain.invoke({"context": "", "question": message})
    try:
        response_json = json.loads(content.content)
        return response_json
    except json.JSONDecodeError:
        raise HTTPException(status_code=500, detail="Invalid JSON response from the model")

@app.post("/chat", response_model=ChatResponse)
async def chat(chat_request: ChatRequest):
    message = chat_request.message
    chat_history.append(ChatMessage(role="human", content=message))
    
    # Generate response for the keyword extraction
    keyword_chain = generate_chain(retriever_map["keyword"], prompt_keyword)
    
    # 디버깅을 위한 로그 추가
    print("Keyword chain input:", {"context": "", "question": message})
    
    try:
        keyword_response = keyword_chain.invoke({"context": "", "question": message})
        # 디버깅을 위한 로그 추가
        print("Keyword chain response:", keyword_response)
        keyword_response_content = keyword_response.content.strip()
        # 디버깅을 위한 로그 추가
        print("Processed keyword response:", keyword_response_content)
    except Exception as e:
        print("Error during keyword chain invoke:", e)
        raise HTTPException(status_code=500, detail="Error during keyword chain invoke")
    
    if keyword_response_content in retriever_map:
        try:
            ai_response = handle_message(message, keyword_response_content)
            # 디버깅을 위한 로그 추가
            print("AI response:", ai_response)
            chat_history.append(ChatMessage(role="ai", content=json.dumps(ai_response)))
        except Exception as e:
            print("Error during handle message:", e)
            raise HTTPException(status_code=500, detail="Error during handle message")
    else:
        ai_response = {"category": "TRIPTOK"}
        # 디버깅을 위한 로그 추가
        print("AI fallback response:", ai_response)
        chat_history.append(ChatMessage(role="ai", content=json.dumps(ai_response)))
    
    return ChatResponse(messages=chat_history)
