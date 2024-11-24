from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..dto import place_to_visit_dto
from ..service import place_to_visit_service
from ..config.database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..config.database import get_db
from typing import List

# 라우터 생성
router = APIRouter()

# PlaceToVisit 엔드포인트
# 방문할 장소 생성 엔드포인트
@router.post("/travel_schedules/{travel_schedule_id}/places_to_visit/", response_model=place_to_visit_dto.PlaceToVisit)
async def create_place_to_visit(travel_schedule_id: int, place_to_visit: place_to_visit_dto.PlaceToVisitCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 방문할 장소 생성
    response = await place_to_visit_service.create_place_to_visit(db=db, place_to_visit=place_to_visit, travel_schedule_id=travel_schedule_id)
    return response.__dict__

# 특정 여행 일정의 방문할 장소 조회 엔드포인트
@router.get("/travel_schedules/{travel_schedule_id}/places_to_visit/", response_model=place_to_visit_dto.PlacesToVisitDetailResponse)
async def read_places_to_visit(travel_schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정에 포함된 모든 방문할 장소를 CRUD 함수로 조회
    places_to_visit = await place_to_visit_service.get_places_to_visit(db=db, travel_schedule_id=travel_schedule_id)
    # 조회된 방문할 장소 리스트 반환
    # places_to_visit = [place.__dict__ for place in places_to_visit]
    return {"places_to_visit":places_to_visit}

# 방문할 장소 삭제 엔드포인트
@router.delete("/places_to_visit/{place_to_visit_id}", response_model=place_to_visit_dto.PlaceToVisit)
async def delete_place_to_visit(place_to_visit_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 방문할 장소를 CRUD 함수로 삭제
    db_place_to_visit = await place_to_visit_service.delete_place_to_visit(db=db, place_to_visit_id=place_to_visit_id)
    # 방문할 장소가 없을 경우 404 에러 반환
    if db_place_to_visit is None:
        raise HTTPException(status_code=404, detail="Place to visit not found")
    # 삭제된 방문할 장소 반환
    return db_place_to_visit.__dict__

@router.put("/places_to_visit/{place_to_visit_id}", response_model=place_to_visit_dto.PlaceToVisit)
async def put_place_to_visit(place_to_visit_id: int, place_to_visit: place_to_visit_dto.PlaceToVisitCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 사용자 정보를 업데이트
    db_place_to_visit = await place_to_visit_service.update_place_to_visit(db=db, place_to_visit_id=place_to_visit_id, place_to_visit=place_to_visit)
    # 사용자가 없을 경우 404 에러 반환
    if db_place_to_visit is None:
        raise HTTPException(status_code=404, detail="Place to visit not found")
    # 업데이트된 사용자 정보 반환
    return db_place_to_visit.__dict__
