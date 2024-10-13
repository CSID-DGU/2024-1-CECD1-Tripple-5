from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from .. import crud, models, schemas
from ..database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..database import get_db
from typing import List


# 라우터 생성
router = APIRouter()


# TravelSchedule 엔드포인트

# 여행 일정 생성 엔드포인트
@router.post("/users/{user_id}/travel_schedules/", response_model=schemas.TravelSchedule)
async def create_travel_schedule(user_id: int, travel_schedule: schemas.TravelScheduleCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 여행 일정 생성
    response =  await crud.create_travel_schedule(db=db, travel_schedule=travel_schedule, user_id=user_id)
    return response.__dict__

# 특정 여행 일정 조회 엔드포인트
@router.get("/travel_schedules/{schedule_id}", response_model=schemas.TravelSchedule)
async def read_travel_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정을 CRUD 함수로 조회
    db_schedule = await crud.get_travel_schedule(db=db, schedule_id=schedule_id)
    # 여행 일정이 없을 경우 404 에러 반환
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Travel schedule not found")
    # 조회된 여행 일정 반환
    return db_schedule.__dict__

# 특정 사용자의 모든 여행 일정 조회 엔드포인트
@router.get("/users/{user_id}/travel_schedules/", response_model=schemas.TravelSchedulesResponse)
async def read_travel_schedules(user_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 사용자의 모든 여행 일정을 CRUD 함수로 조회
    travel_schedules = await crud.get_travel_schedules(db=db, user_id=user_id)
    # 조회된 여행 일정 리스트 반환
    travel_schedules = [schedule.__dict__ for schedule in travel_schedules]
    return {"travel_schedules":travel_schedules}

# 여행 일정 삭제 엔드포인트
@router.delete("/travel_schedules/{schedule_id}", response_model=schemas.TravelSchedule)
async def delete_travel_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정을 CRUD 함수로 삭제
    db_schedule = await crud.delete_travel_schedule(db=db, schedule_id=schedule_id)
    # 여행 일정이 없을 경우 404 에러 반환
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Travel schedule not found")
    # 삭제된 여행 일정 반환
    return db_schedule.__dict__


# PlaceToVisit 엔드포인트

# 방문할 장소 생성 엔드포인트
@router.post("/travel_schedules/{travel_schedule_id}/places_to_visit/", response_model=schemas.PlaceToVisit)
async def create_place_to_visit(travel_schedule_id: int, place_to_visit: schemas.PlaceToVisitCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 방문할 장소 생성
    response = await crud.create_place_to_visit(db=db, place_to_visit=place_to_visit, travel_schedule_id=travel_schedule_id)
    return response.__dict__

# 특정 여행 일정의 방문할 장소 조회 엔드포인트
@router.get("/travel_schedules/{travel_schedule_id}/places_to_visit/", response_model=schemas.PlacesToVisitResponse)
async def read_places_to_visit(travel_schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정에 포함된 모든 방문할 장소를 CRUD 함수로 조회
    places_to_visit = await crud.get_places_to_visit(db=db, travel_schedule_id=travel_schedule_id)
    # 조회된 방문할 장소 리스트 반환
    places_to_visit = [place.__dict__ for place in places_to_visit]
    return {"places_to_visit":places_to_visit}

# 방문할 장소 삭제 엔드포인트
@router.delete("/places_to_visit/{place_to_visit_id}", response_model=schemas.PlaceToVisit)
async def delete_place_to_visit(place_to_visit_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 방문할 장소를 CRUD 함수로 삭제
    db_place_to_visit = await crud.delete_place_to_visit(db=db, place_to_visit_id=place_to_visit_id)
    # 방문할 장소가 없을 경우 404 에러 반환
    if db_place_to_visit is None:
        raise HTTPException(status_code=404, detail="Place to visit not found")
    # 삭제된 방문할 장소 반환
    return db_place_to_visit.__dict__

@router.put("/places_to_visit/{place_to_visit_id}", response_model=schemas.PlaceToVisit)
async def put_place_to_visit(place_to_visit_id: int, place_to_visit: schemas.PlaceToVisitCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 사용자 정보를 업데이트
    db_place_to_visit = await crud.update_place_to_visit(db=db, place_to_visit_id=place_to_visit_id, place_to_visit=place_to_visit)
    # 사용자가 없을 경우 404 에러 반환
    if db_place_to_visit is None:
        raise HTTPException(status_code=404, detail="Place to visit not found")
    # 업데이트된 사용자 정보 반환
    return db_place_to_visit.__dict__

    