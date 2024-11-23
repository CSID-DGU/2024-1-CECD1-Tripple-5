from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import chat_room_dto
from ..entity.model import chat_room_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

# CRUD 함수 정의

# ChatRoom CRUD
# 새로운 채팅방 생성
async def create_chat_room(db: AsyncSession, chat_room: chat_room_dto.ChatRoomCreate, user_id: int):
    db_chat_room = chat_room.ChatRoom(**chat_room.dict(), user_id=user_id)
    db.add(db_chat_room)  # DB에 채팅방 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_room)  # DB에서 새로 추가된 채팅방 정보 갱신
    return db_chat_room  # 새로 생성된 채팅방 반환

# 특정 채팅방 조회
async def get_chat_room(db: AsyncSession, chat_room_id: int):
    result = await db.execute(select(chat_room_model.ChatRoom).filter(chat_room_model.ChatRoom.id == chat_room_id))
    return result.scalars().first()  # 첫 번째 채팅방 반환

# 특정 사용자의 모든 채팅방 조회
async def get_chat_rooms(db: AsyncSession, user_id: int):
    result = await db.execute(select(chat_room_model.ChatRoom).filter(chat_room_model.ChatRoom.user_id == user_id))
    return result.scalars().all()  # 채팅방 목록 반환

# 채팅방 삭제
async def delete_chat_room(db: AsyncSession, chat_room_id: int):
    db_chat_room = await get_chat_room(db, chat_room_id)
    if db_chat_room is None:
        return None  # 채팅방 없을 시 None 반환
    await db.delete(db_chat_room)  # 채팅방 삭제
    await db.commit()  # 변경 사항 커밋
    return db_chat_room  # 삭제된 채팅방 반환

