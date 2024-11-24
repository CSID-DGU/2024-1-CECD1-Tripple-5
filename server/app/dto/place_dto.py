from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel
# from ..entity.model.place_to_visit_model import PlaceToVisit

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
    img_url: Optional[str]

# 장소 생성 시 사용하는 스키마
class PlaceCreate(PlaceBase):
    pass

# 장소 조회 및 반환 시 사용하는 스키마
class Place(PlaceBase):
    id: int  # 장소 ID
    created_at: datetime  # 장소 생성 시간

    class Config:
        orm_mode = True  # ORM 객체를 Pydantic 모델로 변환 가능
        arbitrary_types_allowed = True

class PlacesResponse(BaseModel):
    places: List[Place]

# 순환 참조 해결을 위한 update_forward_refs() 호출
Place.update_forward_refs()  # Place 모델의 참조 해결