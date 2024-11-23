from datetime import date, datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel


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
        arbitrary_types_allowed = True

class RecommendationRecordsResponse(BaseModel):
    recommendation_records: List[RecommendationRecord]

# 순환 참조 해결을 위한 update_forward_refs() 호출
RecommendationRecord.update_forward_refs()  # RecommendationRecord 모델의 참조 해결