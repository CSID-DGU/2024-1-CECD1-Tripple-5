from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from . import models, schemas

# async def get_chat_room(db: AsyncSession, chat_room_id: int):
#     result = await db.execute(
#         select(models.ChatRoom).filter(models.ChatRoom.id == chat_room_id)
#     )
#     # return result.scalars().first().__dict__
#     return [record.__dict__ for record in result.scalars().first()]

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
    return db_chat_record.__dict__

async def get_chat_records(db: AsyncSession, chat_room_id: int):
    result = await db.execute(
        select(models.ChatRecord)
        .filter(models.ChatRecord.chat_room_id == chat_room_id)
    )
    # return result.scalars().all().__dict__
    return [record.__dict__ for record in result.scalars().all()]