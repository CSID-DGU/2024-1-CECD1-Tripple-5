from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..dto import recommendation_record_dto
from ..service import recommendation_record_service
from ..config.database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..config.database import get_db
from typing import List


# 라우터 생성
router = APIRouter()


# RecommendationRecord 엔드포인트

# 추천 기록 생성 엔드포인트
@router.post("/users/{user_id}/recommendation_records/", response_model=recommendation_record_dto.RecommendationRecord)
async def create_recommendation_record(user_id: int, recommendation_record: recommendation_record_dto.RecommendationRecordCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 추천 기록 생성
    response = await recommendation_record_service.create_recommendation_record(db=db, recommendation_record=recommendation_record, user_id=user_id)
    return response.__dict__

# 특정 추천 기록 조회 엔드포인트
@router.get("/recommendation_records/{record_id}", response_model=recommendation_record_dto.RecommendationRecordDetailResponse)
async def read_recommendation_record(record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 추천 기록을 CRUD 함수로 조회
    db_record = await recommendation_record_service.get_recommendation_record(db=db, record_id=record_id)
    # 추천 기록이 없을 경우 404 에러 반환
    if db_record is None:
        raise HTTPException(status_code=404, detail="Recommendation record not found")
    # 조회된 추천 기록 반환
    return db_record.__dict__

# 특정 사용자의 추천 기록 목록 조회 엔드포인트
@router.get("/users/{user_id}/recommendation_records/", response_model=recommendation_record_dto.RecommendationRecordsDetailResponse)
async def read_recommendation_records(user_id: int, db: AsyncSession = Depends(get_db)):
    # 사용자의 추천 기록을 CRUD 함수로 조회
    recommendation_records = await recommendation_record_service.get_recommendation_records(db=db, user_id=user_id)
    # 조회된 추천 기록 리스트 반환
    # recommendation_records = [record.__dict__ for record in recommendation_records]
    return {"recommendation_records_detail":recommendation_records}

# 추천 기록 삭제 엔드포인트
@router.delete("/recommendation_records/{record_id}", response_model=recommendation_record_dto.RecommendationRecord)
async def delete_recommendation_record(record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 추천 기록을 CRUD 함수로 삭제
    db_record = await recommendation_record_service.delete_recommendation_record(db=db, record_id=record_id)
    # 추천 기록이 없을 경우 404 에러 반환
    if db_record is None:
        raise HTTPException(status_code=404, detail="Recommendation record not found")
    # 삭제된 추천 기록 반환
    return db_record.__dict__