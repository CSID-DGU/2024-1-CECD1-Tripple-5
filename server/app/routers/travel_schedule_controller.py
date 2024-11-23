from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..dto import travel_schedule_dto
from ..service import travel_schedule_service
from ..config.database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..config.database import get_db
from typing import List


# 라우터 생성
router = APIRouter()


# TravelSchedule 엔드포인트

# 여행 일정 생성 엔드포인트
@router.post("/users/{user_id}/travel_schedules/", response_model=travel_schedule_dto.TravelSchedule)
async def create_travel_schedule(user_id: int, travel_schedule: travel_schedule_dto.TravelScheduleCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 여행 일정 생성
    response =  await travel_schedule_service.create_travel_schedule(db=db, travel_schedule=travel_schedule, user_id=user_id)
    return response.__dict__

# 특정 여행 일정 조회 엔드포인트
@router.get("/travel_schedules/{schedule_id}", response_model=travel_schedule_dto.TravelSchedule)
async def read_travel_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정을 CRUD 함수로 조회
    db_schedule = await travel_schedule_service.get_travel_schedule(db=db, schedule_id=schedule_id)
    # 여행 일정이 없을 경우 404 에러 반환
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Travel schedule not found")
    # 조회된 여행 일정 반환
    return db_schedule.__dict__

# 특정 사용자의 모든 여행 일정 조회 엔드포인트
@router.get("/users/{user_id}/travel_schedules/", response_model=travel_schedule_dto.TravelSchedulesResponse)
async def read_travel_schedules(user_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 사용자의 모든 여행 일정을 CRUD 함수로 조회
    travel_schedules = await travel_schedule_service.get_travel_schedules(db=db, user_id=user_id)
    # 조회된 여행 일정 리스트 반환
    travel_schedules = [schedule.__dict__ for schedule in travel_schedules]
    return {"travel_schedules":travel_schedules}

# 여행 일정 삭제 엔드포인트
@router.delete("/travel_schedules/{schedule_id}", response_model=travel_schedule_dto.TravelSchedule)
async def delete_travel_schedule(schedule_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 여행 일정을 CRUD 함수로 삭제
    db_schedule = await travel_schedule_service.delete_travel_schedule(db=db, schedule_id=schedule_id)
    # 여행 일정이 없을 경우 404 에러 반환
    if db_schedule is None:
        raise HTTPException(status_code=404, detail="Travel schedule not found")
    # 삭제된 여행 일정 반환
    return db_schedule.__dict__


    