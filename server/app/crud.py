from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from . import models, schemas
from .service.chatbot.chat import get_response_from_chatgpt

async def get_chat_rooms(db: AsyncSession):
    result = await db.execute(select(models.ChatRoom))
    return [chatroom.__dict__ for chatroom in result.scalars().all()]

async def create_chat_room(db: AsyncSession, chat_room: schemas.ChatRoomCreate):
    db_chat_room = models.ChatRoom(name=chat_room.name)
    db.add(db_chat_room)
    await db.commit()
    await db.refresh(db_chat_room)
    return db_chat_room.__dict__

async def create_chat_record(db: AsyncSession, chat_record: schemas.ChatRecordCreate, chat_room_id: int):
    db_chat_record = models.ChatRecord(**chat_record.__dict__, chat_room_id=chat_room_id)
    db.add(db_chat_record)
    await db.commit()
    await db.refresh(db_chat_record)
    # chatgpt로부터 response 받기
    chatbot_response = await get_response_from_chatgpt(chat_record.message)
    db_chat_record_response = models.ChatRecord(
        message=chatbot_response,
        is_chatbot=True,
        chat_room_id=chat_room_id
    )
    db.add(db_chat_record_response)
    await db.commit()
    await db.refresh(db_chat_record_response)
    #
    return db_chat_record_response.__dict__

async def get_chat_records(db: AsyncSession, chat_room_id: int):
    result = await db.execute(
        select(models.ChatRecord)
        .filter(models.ChatRecord.chat_room_id == chat_room_id)
    )
    # return result.scalars().all().__dict__
    return [record.__dict__ for record in result.scalars().all()]
