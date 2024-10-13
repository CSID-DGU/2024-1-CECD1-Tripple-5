from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import crud, models, schemas
from ..database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..database import get_db
from typing import List


# 라우터 생성
router = APIRouter()


# RecommendationRecord 엔드포인트

# 추천 기록 생성 엔드포인트
@router.post("/users/{user_id}/recommendation_records/", response_model=schemas.RecommendationRecord)
async def create_recommendation_record(user_id: int, recommendation_record: schemas.RecommendationRecordCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 추천 기록 생성
    response = await crud.create_recommendation_record(db=db, recommendation_record=recommendation_record, user_id=user_id)
    return response.__dict__

# 특정 추천 기록 조회 엔드포인트
@router.get("/recommendation_records/{record_id}", response_model=schemas.RecommendationRecord)
async def read_recommendation_record(record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 추천 기록을 CRUD 함수로 조회
    db_record = await crud.get_recommendation_record(db=db, record_id=record_id)
    # 추천 기록이 없을 경우 404 에러 반환
    if db_record is None:
        raise HTTPException(status_code=404, detail="Recommendation record not found")
    # 조회된 추천 기록 반환
    return db_record.__dict__

# 특정 사용자의 추천 기록 목록 조회 엔드포인트
@router.get("/users/{user_id}/recommendation_records/", response_model=List[schemas.RecommendationRecord])
async def read_recommendation_records(user_id: int, db: AsyncSession = Depends(get_db)):
    # 사용자의 추천 기록을 CRUD 함수로 조회
    records = await crud.get_recommendation_records(db=db, user_id=user_id)
    # 조회된 추천 기록 리스트 반환
    return [record.__dict__ for record in records]

# 추천 기록 삭제 엔드포인트
@router.delete("/recommendation_records/{record_id}", response_model=schemas.RecommendationRecord)
async def delete_recommendation_record(record_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 추천 기록을 CRUD 함수로 삭제
    db_record = await crud.delete_recommendation_record(db=db, record_id=record_id)
    # 추천 기록이 없을 경우 404 에러 반환
    if db_record is None:
        raise HTTPException(status_code=404, detail="Recommendation record not found")
    # 삭제된 추천 기록 반환
    return db_record.__dict__