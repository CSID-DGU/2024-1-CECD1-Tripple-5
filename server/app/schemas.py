from datetime import datetime
from pydantic import BaseModel

class ChatRecordBase(BaseModel):
    message: str
    is_chatbot: bool = False

class ChatRecordCreate(ChatRecordBase):
    pass

class ChatRecord(ChatRecordBase):
    id: int
    chat_room_id: int
    timestamp: datetime

    class Config:
        orm_mode: True

class ChatRoomBase(BaseModel):
    name: str

class ChatRoomCreate(ChatRoomBase):
    pass

class ChatRoom(ChatRoomBase):
    id: int
    created_at: datetime
    updated_at: datetime
    # chat_records: list[ChatRecord] = []

    class Config:
        orm_mode: True