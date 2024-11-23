from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import travel_schedule_dto
from ..entity.model import travel_schedule_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

# CRUD 함수 정의

# TravelSchedule CRUD
# 새로운 여행 일정 생성
async def create_travel_schedule(db: AsyncSession, travel_schedule: travel_schedule_dto.TravelScheduleCreate, user_id: int):
    db_travel_schedule = travel_schedule_model.TravelSchedule(**travel_schedule.dict(), user_id=user_id)
    db.add(db_travel_schedule)  # DB에 여행 일정 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_travel_schedule)  # DB에서 새로 추가된 여행 일정 정보 갱신
    return db_travel_schedule  # 새로 생성된 여행 일정 반환

# 특정 여행 일정 조회
async def get_travel_schedule(db: AsyncSession, schedule_id: int):
    result = await db.execute(select(travel_schedule_model.TravelSchedule).filter(travel_schedule_model.TravelSchedule.id == schedule_id))
    return result.scalars().first()  # 첫 번째 여행 일정 반환

# 특정 사용자의 모든 여행 일정 조회
async def get_travel_schedules(db: AsyncSession, user_id: int):
    result = await db.execute(select(travel_schedule_model.TravelSchedule).filter(travel_schedule_model.TravelSchedule.user_id == user_id))
    return result.scalars().all()  # 여행 일정 목록 반환

# 여행 일정 삭제
async def delete_travel_schedule(db: AsyncSession, schedule_id: int):
    db_travel_schedule = await get_travel_schedule(db, schedule_id)
    if db_travel_schedule is None:
        return None  # 여행 일정 없을 시 None 반환
    await db.delete(db_travel_schedule)  # 여행 일정 삭제
    await db.commit()  # 변경 사항 커밋
    return db_travel_schedule  # 삭제된 여행 일정 반환