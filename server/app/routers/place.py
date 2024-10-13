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

@router.get("/places/", response_model=schemas.PlacesResponse)
async def search_place(unified_search_term: str="", place_name_search_term: str="", road_address_name_search_term: str="", place_description_search_term: str="", db: AsyncSession = Depends(get_db)):
    # 장소 검색
    places = await crud.search_places(db=db, unified_search_term=unified_search_term, place_name=place_name_search_term, road_address_name=road_address_name_search_term, place_description=place_description_search_term)
    # 검색된 장소 목록 반환
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
