from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel
# from ..entity.model.chat_record_model import ChatRecord
from .chat_record_dto import ChatRecord

# ChatRoom 스키마 정의
# 채팅방에 대한 기본 필드를 정의
class ChatRoomBase(BaseModel):
    chat_room_name: str  # 채팅방 이름

# 채팅방 생성 시 사용하는 스키마
class ChatRoomCreate(ChatRoomBase):
    pass

# 채팅방 조회 및 반환 시 사용하는 스키마
class ChatRoom(ChatRoomBase):
    id: int  # 채팅방 ID
    user_id: int  # 채팅방 사용자 ID
    created_at: datetime  # 채팅방 생성 시간
    updated_at: datetime  # 채팅방 업데이트 시간
    chat_records: List['ChatRecord'] = []  # 채팅 기록 리스트

    class Config:
        orm_mode = True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class ChatRoomsResponse(BaseModel):
    chat_rooms: List[ChatRoom]

# 순환 참조 해결을 위한 update_forward_refs() 호출
ChatRoom.update_forward_refs()  # ChatRoom 모델의 참조 해결