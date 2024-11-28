from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import chat_record_dto
from ..entity.model import chat_record_model
# from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload


# ChatRecord CRUD
# 새로운 채팅 기록 생성
async def create_chat_record(db: AsyncSession, chat_record: chat_record_dto.ChatRecordCreate, chat_room_id: int):
    db_chat_record = chat_record_model.ChatRecord(**chat_record.dict(), chat_room_id=chat_room_id)
    db.add(db_chat_record)  # DB에 채팅 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_record)  # DB에서 새로 추가된 채팅 기록 정보 갱신
    # chatgpt로부터 response 받기
    # print("@@@@@@@@@@@@@@@@@@@@", db_chat_record)
    # print("@@@@@@@@@@@@@@@@@@@@", chat_record.message)
    # chatbot_response = await get_response_from_chatgpt(chat_record.message)
    # print("@@@@@@@@@@@@@@@@@@@@", chatbot_response)
    db_chat_record_response = chat_record_model.ChatRecord(
        **chat_record_dto.ChatRecordCreate(
            # message=chatbot_response,
            message="현재 챗봇이 잠자고 있습니다.",
            is_chatbot=True
        ).dict(),
        chat_room_id=chat_room_id
    )
    db.add(db_chat_record_response)
    await db.commit()
    await db.refresh(db_chat_record_response)
    # 대답 반환
    return db_chat_record_response


# 특정 채팅방의 모든 채팅 기록 조회
async def get_chat_records(db: AsyncSession, chat_room_id: int):
    result = await db.execute(
        select(chat_record_model.ChatRecord)
        .filter(chat_record_model.ChatRecord.chat_room_id == chat_room_id)
    )
    return result.scalars().all()  # 채팅 기록 목록 반환

async def get_chat_record(db: AsyncSession, chat_record_id: int):
    result = await db.execute(
        select(chat_record_model.ChatRecord)
        .filter(chat_record_model.ChatRecord.id == chat_record_id)
    )
    return result.scalars().first()  # 채팅 기록 반환


# 채팅 기록 삭제
async def delete_chat_record(db: AsyncSession, chat_record_id: int):
    db_chat_record = await get_chat_record(db, chat_record_id)
    if db_chat_record is None:
        return None  # 채팅 기록 없을 시 None 반환
    await db.delete(db_chat_record)  # 채팅 기록 삭제
    await db.commit()  # 변경 사항 커밋
    return db_chat_record  # 삭제된 채팅 기록 반환
