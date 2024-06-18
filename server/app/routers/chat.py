from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import crud, models, schemas
from ..database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..database import get_db

router = APIRouter()

@router.post("/chat_rooms/", response_model=schemas.ChatRoom)
async def create_chat_room(chat_room: schemas.ChatRoomCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_chat_room(db=db, chat_room=chat_room)

@router.get("/chat_rooms/", response_model=list[schemas.ChatRoom])
async def read_chat_rooms(db: AsyncSession = Depends(get_db)):
    return await crud.get_chat_rooms(db=db)

@router.post("/chat_rooms/{chat_room_id}/records/", response_model=schemas.ChatRecord)
async def create_chat_record(chat_room_id: int, chat_record: schemas.ChatRecordCreate, db: AsyncSession = Depends(get_db)):
    return await crud.create_chat_record(db=db, chat_record=chat_record, chat_room_id=chat_room_id)

@router.get("/chat_rooms/{chat_room_id}/records/", response_model=list[schemas.ChatRecord])
async def read_chat_records(chat_room_id: int, db: AsyncSession = Depends(get_db)):
    return await crud.get_chat_records(db=db, chat_room_id=chat_room_id)  