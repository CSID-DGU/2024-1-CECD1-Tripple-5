from fastapi import HTTPException
from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import recommendation_record_dto
from ..entity.model import recommendation_record_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload
from sqlalchemy.orm import joinedload
# CRUD 함수 정의


# RecommendationRecord CRUD
# 새로운 추천 기록 생성
async def create_recommendation_record(db: AsyncSession, recommendation_record: recommendation_record_dto.RecommendationRecordCreate, user_id: int):
    db_recommendation_record = recommendation_record_model.RecommendationRecord(**recommendation_record.dict(), user_id=user_id)
    db.add(db_recommendation_record)  # DB에 추천 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_recommendation_record)  # DB에서 새로 추가된 추천 기록 정보 갱신
    return db_recommendation_record  # 새로 생성된 추천 기록 반환

# 특정 추천 기록 조회
async def get_recommendation_record(db: AsyncSession, record_id: int):
    result = await db.execute(
        select(recommendation_record_model.RecommendationRecord)
        .options(selectinload(recommendation_record_model.RecommendationRecord.place))  # place 관계 로드
        .filter(recommendation_record_model.RecommendationRecord.id == record_id)
    )
    record = result.scalars().first()

    if record is None:
        raise HTTPException(status_code=404, detail="Recommendation record not found")

    # 엔티티를 DTO로 변환
    dto = entity_to_dto(record)
    return dto

# 특정 사용자의 모든 추천 기록 조회
async def get_recommendation_records(db: AsyncSession, user_id: int):
    result = await db.execute(
        select(recommendation_record_model.RecommendationRecord)
        .options(selectinload(recommendation_record_model.RecommendationRecord.place))  # place 관계 로드
        .filter(recommendation_record_model.RecommendationRecord.user_id == user_id)
    )
    records = result.scalars().all()


    dtos = [entity_to_dto(record) for record in records]
    return dtos

# 추천 기록 삭제
async def delete_recommendation_record(db: AsyncSession, record_id: int):
    db_record = await get_recommendation_record(db, record_id)
    if db_record is None:
        return None  # 추천 기록 없을 시 None 반환
    await db.delete(db_record)  # 추천 기록 삭제
    await db.commit()  # 변경 사항 커밋
    return db_record  # 삭제된 추천 기록 반환

def entity_to_dto(entity: recommendation_record_model.RecommendationRecord) -> recommendation_record_dto.RecommendationRecordDetailResponse:
    """
    SQLAlchemy 엔티티를 DTO로 변환하는 함수.
    :param entity: RecommendationRecord 엔티티
    :return: RecommendationRecordDetailResponse DTO
    """
    # DTO 변환
    return recommendation_record_dto.RecommendationRecordDetailResponse(
        id=entity.id,
        user_id=entity.user_id,
        place_id=entity.place_id,
        recommendation_name=entity.recommendation_name,
        created_at=entity.created_at,
        place=recommendation_record_dto.Place(
            id=entity.place.id,
            place_name=entity.place.place_name,
            x=entity.place.x,
            y=entity.place.y,
            road_address_name=entity.place.road_address_name,
            place_url=entity.place.place_url,
            place_description=entity.place.place_description,
            place_cost=entity.place.place_cost,
            img_url=entity.place.img_url,
            created_at=entity.place.created_at,
        ) if entity.place else None  # 관계가 없는 경우 None 처리
    )