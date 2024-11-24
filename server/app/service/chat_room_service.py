from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import chat_room_dto
from ..entity.model import chat_room_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

from ..dto import chat_record_dto

# CRUD 함수 정의

# ChatRoom CRUD
# 새로운 채팅방 생성
async def create_chat_room(db: AsyncSession, chat_room: chat_room_dto.ChatRoomCreate, user_id: int):
    db_chat_room = chat_room_model.ChatRoom(**chat_room.dict(), user_id=user_id)
    db.add(db_chat_room)  # DB에 채팅방 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_room)  # DB에서 새로 추가된 채팅방 정보 갱신
    return db_chat_room  # 새로 생성된 채팅방 반환

# 특정 채팅방 조회
async def get_chat_room(db: AsyncSession, chat_room_id: int):
    result = await db.execute(
        select(chat_room_model.ChatRoom)
        .options(
            selectinload(chat_room_model.ChatRoom.chat_records)
        )
        .filter(chat_room_model.ChatRoom.id == chat_room_id)
    )
    record = result.scalars().first()  # 첫 번째 채팅방 반환
    record = entity_to_dto(record)
    return record

# 특정 사용자의 모든 채팅방 조회
async def get_chat_rooms(db: AsyncSession, user_id: int):
    result = await db.execute(
        select(chat_room_model.ChatRoom)
        .options(
            selectinload(chat_room_model.ChatRoom.chat_records)
        )
        .filter(chat_room_model.ChatRoom.user_id == user_id)
    )
    records = result.scalars().all()  # 채팅방 목록 반환
    records = [entity_to_dto(record) for record in records]
    return records

# 채팅방 삭제
async def delete_chat_room(db: AsyncSession, chat_room_id: int):
    result = await db.execute(
        select(chat_room_model.ChatRoom)
        .options(
            selectinload(chat_room_model.ChatRoom.chat_records)
        )
        .filter(chat_room_model.ChatRoom.id == chat_room_id)
    )
    record = result.scalars().first()
    db_chat_room = record
    if db_chat_room is None:
        return None  # 채팅방 없을 시 None 반환
    await db.delete(db_chat_room)  # 채팅방 삭제
    await db.commit()  # 변경 사항 커밋
    return db_chat_room  # 삭제된 채팅방 반환




def entity_to_dto(entity: chat_room_model.ChatRoom) -> chat_room_dto.ChatRoomDetailResponse:
    # DTO 변환
    return chat_room_dto.ChatRoomDetailResponse(
        id=entity.id,
        user_id=entity.user_id,
        chat_room_name=entity.chat_room_name,
        updated_at=entity.updated_at,
        created_at=entity.created_at,
        chat_records=[
            chat_record_dto.ChatRecord(
                id=chat_record.id,
                message=chat_record.message,  # 채팅 메시지
                is_chatbot=chat_record.is_chatbot,  # 챗봇 여부
                chat_room_id=chat_record.chat_room_id,  # 채팅방 ID
                created_at=chat_record.created_at,  # 채팅 기록 생성 시간
            ) for chat_record in entity.chat_records  
        ]
    )