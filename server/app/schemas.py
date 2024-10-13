from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel



# class ChatRecordBase(BaseModel):
#     message: str
#     is_chatbot: bool = False

# class ChatRecordCreate(ChatRecordBase):
#     pass

# class ChatRecord(ChatRecordBase):
#     id: int
#     chat_room_id: int
#     timestamp: datetime

#     class Config:
#         orm_mode: True

# class ChatRecordsResponse(BaseModel):
#     chat_records: List[ChatRecord]

# class ChatRoomBase(BaseModel):
#     name: str

# class ChatRoomCreate(ChatRoomBase):
#     pass

# class ChatRoom(ChatRoomBase):
#     id: int
#     created_at: datetime
#     updated_at: datetime
#     # chat_records: list[ChatRecord] = []

#     class Config:
#         orm_mode: True

# class ChatRoomsResponse(BaseModel):
#     chat_rooms: List[ChatRoom]


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
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class UserBaseResponse(UserBase):
    pass

class UsersResponse(BaseModel):
    users: List[User]

# RecommendationRecord 스키마 정의
# 추천 기록에 대한 기본 필드를 정의
class RecommendationRecordBase(BaseModel):
    recommendation_name: str  # 추천 이름

# 추천 기록 생성 시 사용하는 스키마
class RecommendationRecordCreate(RecommendationRecordBase):
    place_id: int  # 추천 장소 ID

# 추천 기록 조회 및 반환 시 사용하는 스키마
class RecommendationRecord(RecommendationRecordBase):
    id: int  # 추천 기록 ID
    user_id: int  # 추천 기록 사용자 ID
    place_id: int  # 추천된 장소 ID
    created_at: datetime  # 추천 기록 생성 시간

    class Config:
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class RecommendationRecordsResponse(BaseModel):
    recommendation_records: List[RecommendationRecord]

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
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class ChatRoomsResponse(BaseModel):
    chat_rooms: List[ChatRoom]

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

class ChatRecordsResponse(BaseModel):
    chat_records: List[ChatRecord]


# TravelSchedule 스키마 정의
# 여행 일정에 대한 기본 필드를 정의
class TravelScheduleBase(BaseModel):
    trip_name: str  # 여행 이름
    start_date: date  # 여행 시작일
    end_date: date  # 여행 종료일

# 여행 일정 생성 시 사용하는 스키마
class TravelScheduleCreate(TravelScheduleBase):
    pass

# 여행 일정 조회 및 반환 시 사용하는 스키마
class TravelSchedule(TravelScheduleBase):
    id: int  # 여행 일정 ID
    user_id: int  # 여행 일정 사용자 ID
    created_at: datetime  # 여행 일정 생성 시간
    updated_at: datetime  # 여행 일정 업데이트 시간
    places_to_visit: List['PlaceToVisit'] = []  # 방문할 장소 리스트

    class Config:
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class TravelSchedulesResponse(BaseModel):
    travel_schedules: List[TravelSchedule]

# PlaceToVisit 스키마 정의
# 방문할 장소에 대한 기본 필드를 정의
class PlaceToVisitBase(BaseModel):
    user_memo: Optional[str]  # 사용자가 작성한 메모 (선택 사항)

# 방문할 장소 생성 시 사용하는 스키마
class PlaceToVisitCreate(PlaceToVisitBase):
    place_id: int  # 장소 ID

# 방문할 장소 조회 및 반환 시 사용하는 스키마
class PlaceToVisit(PlaceToVisitBase):
    id: int  # 방문할 장소 ID
    travel_schedule_id: int  # 여행 일정 ID
    place_id: int  # 장소 ID
    created_at: datetime  # 방문할 장소 생성 시간

    class Config:
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class PlacesToVisitResponse(BaseModel):
    places_to_visit: List[PlaceToVisit]

# Place 스키마 정의
# 장소에 대한 기본 필드를 정의
class PlaceBase(BaseModel):
    place_name: str  # 장소 이름
    x: float  # 장소 X 좌표
    y: float  # 장소 Y 좌표
    road_address_name: str  # 도로명 주소
    place_url: Optional[str]  # 장소 URL (선택 사항)
    place_description: Optional[str]  # 장소 설명 (선택 사항)
    place_cost: Optional[Decimal]  # 장소 비용 (선택 사항)

# 장소 생성 시 사용하는 스키마
class PlaceCreate(PlaceBase):
    pass

# 장소 조회 및 반환 시 사용하는 스키마
class Place(PlaceBase):
    id: int  # 장소 ID
    created_at: datetime  # 장소 생성 시간
    places_to_visit: List[PlaceToVisit] = []  # 방문할 장소 리스트

    class Config:
        orm_mode: True  # ORM 객체를 Pydantic 모델로 변환 가능

class PlacesResponse(BaseModel):
    places: List[Place]

# 순환 참조 해결을 위한 update_forward_refs() 호출
User.update_forward_refs()  # User 모델의 참조 해결
RecommendationRecord.update_forward_refs()  # RecommendationRecord 모델의 참조 해결
ChatRoom.update_forward_refs()  # ChatRoom 모델의 참조 해결
ChatRecord.update_forward_refs()  # ChatRecord 모델의 참조 해결
TravelSchedule.update_forward_refs()  # TravelSchedule 모델의 참조 해결
PlaceToVisit.update_forward_refs()  # PlaceToVisit 모델의 참조 해결
Place.update_forward_refs()  # Place 모델의 참조 해결