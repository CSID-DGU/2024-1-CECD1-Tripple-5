from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel

# ChatRecord 스키마 정의
# 채팅 기록에 대한 기본 필드를 정의
class ChatRecordBase(BaseModel):
    message: str  # 채팅 메시지
    is_chatbot: bool  # 챗봇 여부

# 채팅 기록 생성 시 사용하는 스키마
class ChatRecordCreate(ChatRecordBase):
    pass

# 채팅 기록 조회 및 반환 시 사용하는 스키마
class ChatRecord(ChatRecordBase):
    id: int  # 채팅 기록 ID
    chat_room_id: int  # 채팅방 ID
    created_at: datetime  # 채팅 기록 생성 시간

    class Config:
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class ChatRecordsResponse(BaseModel):
    chat_records: List[ChatRecord]

# 순환 참조 해결을 위한 update_forward_refs() 호출
ChatRecord.update_forward_refs()  # ChatRecord 모델의 참조 해결