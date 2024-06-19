from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import json

from utils2 import init_llm, embed_file, create_retriever, save_message, send_message, generate_chain, handle_message, retriever_map, llm
from prompts import prompt_keyword

from prompts import prompt_keyword, prompt_place

app = FastAPI()

# Initialize session state
session_state = {"messages": []}

class Message(BaseModel):
    message: str

@app.post("/chat")
def chat(message: Message):
    send_message(session_state, message.message, "human")
    chain = generate_chain(retriever_map["keyword"], prompt_keyword)
    content = chain.invoke(message.message).content
    if "대분류 : " in content:
        content = content.replace("대분류 : ", "").strip()
    
    if content in retriever_map:
        return handle_message(session_state, message.message, content)
    else:
        return JSONResponse(content={"error": "잘못된 입력입니다. 다시 시도해주세요."})

@app.post("/embed")
async def embed(file: UploadFile = File(...)):
    retriever = await embed_file(file)
    return JSONResponse(content={"success": True})

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)