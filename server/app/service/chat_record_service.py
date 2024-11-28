from fastapi import HTTPException
from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import chat_record_dto
from ..entity.model import chat_record_model
from .chatbot.chat import get_chatbot_response_about_user_input_async
from sqlalchemy.orm import selectinload
from ..entity.model import chat_room_model
from ..entity.model import user_model

# ChatRecord CRUD
# 새로운 채팅 기록 생성
async def create_chat_record(db: AsyncSession, chat_record: chat_record_dto.ChatRecordCreate, chat_room_id: int, x: float, y: float):
    db_chat_record = chat_record_model.ChatRecord(**chat_record.dict(), chat_room_id=chat_room_id, place_ids_str="")
    db.add(db_chat_record)  # DB에 채팅 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_record)  # DB에서 새로 추가된 채팅 기록 정보 갱신

    user_characteristic = await get_user_characteristic_by_chat_room_id(db=db, chat_room_id=chat_room_id)

    result = await get_chatbot_response_about_user_input_async(db=db, input_text=db_chat_record.message, x=x, y=y, user_characteristic=user_characteristic)
    chatbot_response = result['content']
    place_ids_str = result['place_ids_str']

    db_chat_record_response = chat_record_model.ChatRecord(
        **chat_record_dto.ChatRecordCreate(
            message=chatbot_response,
            # message="현재 챗봇이 잠자고 있습니다.",
            is_chatbot=True
        ).dict(),
        chat_room_id=chat_room_id,
        place_ids_str=place_ids_str
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

    
async def get_user_characteristic_by_chat_room_id(db: AsyncSession, chat_room_id: int):
    # Step 1: chat_room_id를 통해 ChatRoom 검색
    chat_room_result = await db.execute(select(chat_room_model.ChatRoom).where(chat_room_model.ChatRoom.id == chat_room_id))
    chat_room = chat_room_result.scalar_one_or_none()  # 결과를 하나 가져오거나 None 반환
    if not chat_room:
        raise HTTPException(status_code=404, detail=f"ChatRoom with id {chat_room_id} not found.")
    
    # Step 2: user_id를 통해 User 검색
    user_result = await db.execute(select(user_model.User).where(user_model.User.id == chat_room.user_id))
    user = user_result.scalar_one_or_none()  # 결과를 하나 가져오거나 None 반환
    if not user:
        raise HTTPException(status_code=404, detail=f"User with id {chat_room.user_id} not found.")
    
    # Step 3: User의 특성 데이터 반환
    user_characteristic = f"(숙소 최대 예산: {user.accommodation_budget}, 식비 최대 예산: {user.food_budget}, 문화관광비 최대 예산: {user.sightseeing_budget}, 사용자 선호 여행 테마: {user.travel_theme})"

    return user_characteristic