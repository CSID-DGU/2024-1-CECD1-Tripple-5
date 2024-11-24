from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel
# from ..entity.model.place_to_visit_model import PlaceToVisit
# from .place_to_visit_dto import PlaceToVisit
from .place_to_visit_dto import PlaceToVisitDetailResponse

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

    class Config:
        orm_mode = True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class TravelSchedulesResponse(BaseModel):
    travel_schedules: List[TravelSchedule]

class TravelScheduleDetailResponse(TravelSchedule):
    places_to_visit: List[PlaceToVisitDetailResponse]  # PlaceToVisitDetail DTO 추가

class TravelSchedulesDetailResponse(BaseModel):
    travel_schedules: List[TravelScheduleDetailResponse]

# 순환 참조 해결을 위한 update_forward_refs() 호출
TravelSchedule.update_forward_refs()  # TravelSchedule 모델의 참조 해결