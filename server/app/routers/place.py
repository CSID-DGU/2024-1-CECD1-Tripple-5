from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import crud, models, schemas
from ..database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..database import get_db
from typing import List

# 라우터 생성
router = APIRouter()



# Place 엔드포인트

# 새로운 장소 생성 엔드포인트
@router.post("/places/", response_model=schemas.Place)
async def create_place(place: schemas.PlaceCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 새로운 장소 생성
    response = await crud.create_place(db=db, place=place)
    return response.__dict__

# 특정 장소 조회 엔드포인트
@router.get("/places/{place_id}", response_model=schemas.Place)
async def read_place(place_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 장소를 CRUD 함수로 조회
    db_place = await crud.get_place(db=db, place_id=place_id)
    # 장소가 없을 경우 404 에러 반환
    if db_place is None:
        raise HTTPException(status_code=404, detail="Place not found")
    # 조회된 장소 반환
    return db_place.__dict__

# 모든 장소 목록 조회 엔드포인트
@router.get("/places/", response_model=schemas.PlacesResponse)
async def read_places(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 모든 장소 목록 조회
    places = await crud.get_places(db=db, skip=skip, limit=limit)
    # 조회된 장소 목록 반환
    places = [_place.__dict__ for _place in places]
    return {"places":places}

# 장소 삭제 엔드포인트
@router.delete("/places/{place_id}", response_model=schemas.Place)
async def delete_place(place_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 장소를 CRUD 함수로 삭제
    db_place = await crud.delete_place(db=db, place_id=place_id)
    # 장소가 없을 경우 404 에러 반환
    if db_place is None:
        raise HTTPException(status_code=404, detail="Place not found")
    # 삭제된 장소 반환
    return db_place.__dict__