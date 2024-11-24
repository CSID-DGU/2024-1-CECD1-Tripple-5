from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..dto import chat_record_dto
from ..service import chat_record_service
from ..config.database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..config.database import get_db
from typing import List


# 라우터 생성
router = APIRouter()

# ChatRecord 엔드포인트

# 채팅 기록 생성 엔드포인트
@router.post("/chat_rooms/{chat_room_id}/records/", response_model=chat_record_dto.ChatRecord)
async def create_chat_record(chat_room_id: int, chat_record: chat_record_dto.ChatRecordCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 채팅 기록 생성
    response =  await chat_record_service.create_chat_record(db=db, chat_record=chat_record, chat_room_id=chat_room_id)
    return response.__dict__

# 특정 채팅방의 모든 채팅 기록 조회 엔드포인트
@router.get("/chat_rooms/{chat_room_id}/records/", response_model=chat_record_dto.ChatRecordsResponse)
async def read_chat_records(chat_room_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅방의 모든 채팅 기록을 CRUD 함수로 조회
    records = await chat_record_service.get_chat_records(db=db, chat_room_id=chat_room_id)
    # 형태 변환
    records = [record.__dict__ for record in records]
    # 조회된 채팅 기록 리스트 반환
    return {"chat_records":records}

# 채팅 기록 삭제 엔드포인트
@router.delete("/chat_records/{chat_record_id}", response_model=chat_record_dto.ChatRecord)
async def delete_chat_record(chat_record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅 기록을 CRUD 함수로 삭제
    db_chat_record = await chat_record_service.delete_chat_record(db=db, chat_record_id=chat_record_id)
    # 채팅 기록이 없을 경우 404 에러 반환
    if db_chat_record is None:
        raise HTTPException(status_code=404, detail="Chat record not found")
    # 삭제된 채팅 기록 반환
    return db_chat_record.__dict__