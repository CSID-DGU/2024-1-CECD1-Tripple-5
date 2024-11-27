from fastapi import HTTPException
from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import travel_schedule_dto
from ..entity.model import travel_schedule_model, place_to_visit_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

from ..dto import place_dto
from ..dto import place_to_visit_dto

# from ..dto.travel_schedule_dto import TravelScheduleDetailResponse, PlaceToVisitDetail, Place

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
    result = await db.execute(
        select(travel_schedule_model.TravelSchedule)
        .options(
            selectinload(travel_schedule_model.TravelSchedule.places_to_visit)
            .selectinload(place_to_visit_model.PlaceToVisit.place)
        )
        .filter(travel_schedule_model.TravelSchedule.id == schedule_id)
    )
    schedule = result.scalars().first()
    if schedule is None:
        raise HTTPException(status_code=404, detail="Travel schedule not found")
    
    # TravelScheduleDetail 반환
    return entity_to_dto(schedule)

# 특정 사용자의 모든 여행 일정 조회
async def get_travel_schedules(db: AsyncSession, user_id: int):
    result = await db.execute(
        select(travel_schedule_model.TravelSchedule)
        .options(
            selectinload(travel_schedule_model.TravelSchedule.places_to_visit)
            .selectinload(place_to_visit_model.PlaceToVisit.place)
        )
        .filter(travel_schedule_model.TravelSchedule.user_id == user_id)
    )
    schedules = result.scalars().all()
    schedules = [entity_to_dto(schedule) for schedule in schedules]

    return schedules  # 여행 일정 목록 반환

# 여행 일정 삭제
async def delete_travel_schedule(db: AsyncSession, schedule_id: int):
    result = await db.execute(
        select(travel_schedule_model.TravelSchedule)
        .options(
            selectinload(travel_schedule_model.TravelSchedule.places_to_visit)
            .selectinload(place_to_visit_model.PlaceToVisit.place)
        )
        .filter(travel_schedule_model.TravelSchedule.id == schedule_id)
    )
    schedule = result.scalars().first()
    db_travel_schedule = schedule
    if db_travel_schedule is None:
        return None  # 여행 일정 없을 시 None 반환
    await db.delete(db_travel_schedule)  # 여행 일정 삭제
    await db.commit()  # 변경 사항 커밋
    return db_travel_schedule  # 삭제된 여행 일정 반환

def entity_to_dto(entity: travel_schedule_model.TravelSchedule) -> travel_schedule_dto.TravelScheduleDetailResponse:
    return travel_schedule_dto.TravelScheduleDetailResponse(
        id=entity.id,
        user_id=entity.user_id,
        trip_name=entity.trip_name,
        start_date=entity.start_date,
        end_date=entity.end_date,
        created_at=entity.created_at,
        updated_at=entity.updated_at,
        places_to_visit=sorted(
            [
                place_to_visit_dto.PlaceToVisitDetailResponse(
                    id=place_to_visit.id,
                    travel_schedule_id=place_to_visit.travel_schedule_id,
                    place_id=place_to_visit.place_id,
                    user_memo=place_to_visit.user_memo,
                    order_index=place_to_visit.order_index,
                    created_at=place_to_visit.created_at,
                    place=place_dto.Place(
                        id=place_to_visit.place.id,
                        place_name=place_to_visit.place.place_name,
                        x=place_to_visit.place.x,
                        y=place_to_visit.place.y,
                        road_address_name=place_to_visit.place.road_address_name,
                        place_url=place_to_visit.place.place_url,
                        visitor_characteristics=place_to_visit.place.visitor_characteristics,
                        estimated_cost=place_to_visit.place.estimated_cost,
                        estimated_duration=place_to_visit.place.estimated_duration,
                        img_url=place_to_visit.place.img_url,
                        created_at=place_to_visit.place.created_at
                    ) if place_to_visit.place else None
                )
                for place_to_visit in entity.places_to_visit
            ],
            key=lambda dto: dto.order_index  # order_index 기준으로 정렬
        )
    )