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
@router.get("/users/{user_id}/travel_schedules/", response_model=List[schemas.TravelSchedule])
async def read_travel_schedules(user_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 사용자의 모든 여행 일정을 CRUD 함수로 조회
    schedules = await crud.get_travel_schedules(db=db, user_id=user_id)
    # 조회된 여행 일정 리스트 반환
    return [schedule.__dict__ for schedule in schedules]

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
@router.post("/places_to_visit/", response_model=schemas.PlaceToVisit)
async def create_place_to_visit(place_to_visit: schemas.PlaceToVisitCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 방문할 장소 생성
    response = await crud.create_place_to_visit(db=db, place_to_visit=place_to_visit)
    return response.__dict__

# 특정 여행 일정의 방문할 장소 조회 엔드포인트
@router.get("/travel_schedules/{travel_schedule_id}/places_to_visit/", response_model=List[schemas.PlaceToVisit])
async def read_places_to_visit(travel_schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정에 포함된 모든 방문할 장소를 CRUD 함수로 조회
    places = await crud.get_places_to_visit(db=db, travel_schedule_id=travel_schedule_id)
    # 조회된 방문할 장소 리스트 반환
    return [place.__dict__ for place in places]

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
@router.get("/places/", response_model=List[schemas.Place])
async def read_places(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 모든 장소 목록 조회
    places = await crud.get_places(db=db, skip=skip, limit=limit)
    # 조회된 장소 목록 반환
    return [_place.__dict__ for _place in places]

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