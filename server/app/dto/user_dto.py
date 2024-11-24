
from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel
# from ..entity.model.recommendation_record_model import RecommendationRecord
# from ..entity.model.chat_room_model import ChatRoom
# from ..entity.model.travel_schedule_model import TravelSchedule
from .recommendation_record_dto import RecommendationRecord
from .chat_room_dto import ChatRoom
from .travel_schedule_dto import TravelSchedule

# User 스키마 정의
# 기본 사용자 정보와 함께 필요한 필드를 정의
class UserBase(BaseModel):
    accommodation_budget: Decimal  # 숙박 예산
    food_budget: Decimal  # 음식 예산
    sightseeing_budget: Decimal  # 관광 예산
    travel_theme: str  # 여행 테마

# 사용자 생성 시 사용하는 스키마
class UserCreate(UserBase):
    pass


# 사용자 조회 및 반환 시 사용하는 스키마
class User(UserBase):
    id: int  # 사용자 ID
    created_at: datetime  # 사용자 생성 시간
    updated_at: datetime  # 사용자 정보 업데이트 시간
    recommendation_records: List['RecommendationRecord'] = []  # 추천 기록 리스트
    chat_rooms: List['ChatRoom'] = []  # 채팅방 리스트
    travel_schedules: List['TravelSchedule'] = []  # 여행 일정 리스트

    class Config:
        orm_mode = True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class UserBaseResponse(UserBase):
    pass

class UsersResponse(BaseModel):
    users: List[User]

# 순환 참조 해결을 위한 update_forward_refs() 호출
User.update_forward_refs()  # User 모델의 참조 해결