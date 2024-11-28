from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel
from .place_dto import Place

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
    order_index: int # 여행스케쥴-PlaceToVisit리스트 내에서의 순서
    created_at: datetime  # 방문할 장소 생성 시간

    class Config:
        orm_mode = True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class PlacesToVisitResponse(BaseModel):
    places_to_visit: List[PlaceToVisit]


class PlaceToVisitDetailResponse(PlaceToVisit):
    place: Optional[Place]  # PlaceDetail DTO 추가

class PlacesToVisitDetailResponse(BaseModel):
    places_to_visit: List[PlaceToVisitDetailResponse]
    
class PlaceToVisitOrderIndexUpdate(BaseModel):
    place_to_visit_id: int
    order_index: int

class PlacesToVisitOrderIndexUpdate(BaseModel):
    places_to_visit: List[PlaceToVisitOrderIndexUpdate]


# 순환 참조 해결을 위한 update_forward_refs() 호출
PlaceToVisit.update_forward_refs()  # PlaceToVisit 모델의 참조 해결