from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import crud, models, schemas
from ..database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..database import get_db
from typing import List

# router = APIRouter() 

# @router.post("/chat_rooms/", response_model=schemas.ChatRoom)
# async def create_chat_room(chat_room: schemas.ChatRoomCreate, db: AsyncSession = Depends(get_db)):
#     return await crud.create_chat_room(db=db, chat_room=chat_room)

# @router.get("/chat_rooms/", response_model=schemas.ChatRoomsResponse)
# async def read_chat_rooms(db: AsyncSession = Depends(get_db)):
#     return await crud.get_chat_rooms(db=db)

# @router.post("/chat_rooms/{chat_room_id}/records/", response_model=schemas.ChatRecord)
# async def create_chat_record(chat_room_id: int, chat_record: schemas.ChatRecordCreate, db: AsyncSession = Depends(get_db)):
#     return await crud.create_chat_record(db=db, chat_record=chat_record, chat_room_id=chat_room_id)

# @router.get("/chat_rooms/{chat_room_id}/records/", response_model=schemas.ChatRecordsResponse)
# async def read_chat_records(chat_room_id: int, db: AsyncSession = Depends(get_db)):
#     return await crud.get_chat_records(db=db, chat_room_id=chat_room_id)  




# 라우터 생성
router = APIRouter()


# ChatRoom 엔드포인트

# 채팅방 생성 엔드포인트
@router.post("/users/{user_id}/chat_rooms/", response_model=schemas.ChatRoom)
async def create_chat_room(user_id: int, chat_room: schemas.ChatRoomCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 채팅방 생성
    response = await crud.create_chat_room(db=db, chat_room=chat_room, user_id=user_id)
    return response.__dict__

# 특정 채팅방 조회 엔드포인트
@router.get("/chat_rooms/{chat_room_id}", response_model=schemas.ChatRoom)
async def read_chat_room(chat_room_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅방을 CRUD 함수로 조회
    db_chat_room = await crud.get_chat_room(db=db, chat_room_id=chat_room_id)
    # 채팅방이 없을 경우 404 에러 반환
    if db_chat_room is None:
        raise HTTPException(status_code=404, detail="Chat room not found")
    # 조회된 채팅방 정보 반환
    return db_chat_room.__dict__

# 특정 사용자의 모든 채팅방 조회 엔드포인트
@router.get("/users/{user_id}/chat_rooms/", response_model=schemas.ChatRoomsResponse)
async def read_chat_rooms(user_id: int, db: AsyncSession = Depends(get_db)):
    # 사용자의 모든 채팅방을 CRUD 함수로 조회
    chat_rooms = await crud.get_chat_rooms(db=db, user_id=user_id)
    # 조회된 채팅방 리스트 반환
    chat_rooms = [chat_room.__dict__ for chat_room in chat_rooms]
    return {"chat_rooms":chat_rooms}

# 채팅방 삭제 엔드포인트
@router.delete("/chat_rooms/{chat_room_id}", response_model=schemas.ChatRoom)
async def delete_chat_room(chat_room_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅방을 CRUD 함수로 삭제
    db_chat_room = await crud.delete_chat_room(db=db, chat_room_id=chat_room_id)
    # 채팅방이 없을 경우 404 에러 반환
    if db_chat_room is None:
        raise HTTPException(status_code=404, detail="Chat room not found")
    # 삭제된 채팅방 반환
    return db_chat_room.__dict__


# ChatRecord 엔드포인트

# 채팅 기록 생성 엔드포인트
@router.post("/chat_rooms/{chat_room_id}/records/", response_model=schemas.ChatRecord)
async def create_chat_record(chat_room_id: int, chat_record: schemas.ChatRecordCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 채팅 기록 생성
    response =  await crud.create_chat_record(db=db, chat_record=chat_record, chat_room_id=chat_room_id)
    return response.__dict__

# 특정 채팅방의 모든 채팅 기록 조회 엔드포인트
@router.get("/chat_rooms/{chat_room_id}/records/", response_model=schemas.ChatRecordsResponse)
async def read_chat_records(chat_room_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅방의 모든 채팅 기록을 CRUD 함수로 조회
    records = await crud.get_chat_records(db=db, chat_room_id=chat_room_id)
    # 형태 변환
    records = [record.__dict__ for record in records]
    # 조회된 채팅 기록 리스트 반환
    return {"chat_records":records}

# 채팅 기록 삭제 엔드포인트
@router.delete("/chat_records/{chat_record_id}", response_model=schemas.ChatRecord)
async def delete_chat_record(chat_record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 채팅 기록을 CRUD 함수로 삭제
    db_chat_record = await crud.delete_chat_record(db=db, chat_record_id=chat_record_id)
    # 채팅 기록이 없을 경우 404 에러 반환
    if db_chat_record is None:
        raise HTTPException(status_code=404, detail="Chat record not found")
    # 삭제된 채팅 기록 반환
    return db_chat_record.__dict__

