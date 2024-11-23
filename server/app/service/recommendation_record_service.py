from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import recommendation_record_dto
from ..entity.model import recommendation_record_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

# CRUD 함수 정의


# RecommendationRecord CRUD
# 새로운 추천 기록 생성
async def create_recommendation_record(db: AsyncSession, recommendation_record: recommendation_record_dto.RecommendationRecordCreate, user_id: int):
    db_recommendation_record = recommendation_record.RecommendationRecord(**recommendation_record.dict(), user_id=user_id)
    db.add(db_recommendation_record)  # DB에 추천 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_recommendation_record)  # DB에서 새로 추가된 추천 기록 정보 갱신
    return db_recommendation_record  # 새로 생성된 추천 기록 반환

# 특정 추천 기록 조회
async def get_recommendation_record(db: AsyncSession, record_id: int):
    result = await db.execute(select(recommendation_record_model.RecommendationRecord).filter(recommendation_record_model.RecommendationRecord.id == record_id))
    return result.scalars().first()  # 첫 번째 추천 기록 반환

# 특정 사용자의 모든 추천 기록 조회
async def get_recommendation_records(db: AsyncSession, user_id: int):
    result = await db.execute(select(recommendation_record_model.RecommendationRecord).filter(recommendation_record_model.RecommendationRecord.user_id == user_id))
    return result.scalars().all()  # 추천 기록 목록 반환

# 추천 기록 삭제
async def delete_recommendation_record(db: AsyncSession, record_id: int):
    db_record = await get_recommendation_record(db, record_id)
    if db_record is None:
        return None  # 추천 기록 없을 시 None 반환
    await db.delete(db_record)  # 추천 기록 삭제
    await db.commit()  # 변경 사항 커밋
    return db_record  # 삭제된 추천 기록 반환