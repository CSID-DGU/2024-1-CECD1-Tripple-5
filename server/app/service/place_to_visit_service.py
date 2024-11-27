from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import place_to_visit_dto
from ..entity.model import place_to_visit_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

from ..dto import place_dto

# CRUD 함수 정의

# PlaceToVisit CRUD
# 새로운 방문할 장소 생성
async def create_place_to_visit(db: AsyncSession, place_to_visit: place_to_visit_dto.PlaceToVisitCreate, travel_schedule_id: int):
    db_place_to_visit = place_to_visit_model.PlaceToVisit(**place_to_visit.dict(), travel_schedule_id=travel_schedule_id)
    db.add(db_place_to_visit)  # DB에 방문할 장소 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place_to_visit)  # DB에서 새로 추가된 방문할 장소 정보 갱신
    return db_place_to_visit  # 새로 생성된 방문할 장소 반환

# 특정 여행 일정의 모든 방문할 장소 조회
async def get_places_to_visit(db: AsyncSession, travel_schedule_id: int):
    result = await db.execute(
        select(place_to_visit_model.PlaceToVisit)
        .options(
            selectinload(place_to_visit_model.PlaceToVisit.place)
        )  # place 관계 로드
        .filter(place_to_visit_model.PlaceToVisit.travel_schedule_id == travel_schedule_id)
    )
    records = result.scalars().all()
    dtos = [entity_to_dto(record) for record in records]

    return dtos  # 방문할 장소 목록 반환

# 방문 장소 조회
async def get_place_to_visit(db: AsyncSession, place_to_visit_id: int):
    result = await db.execute(
        select(place_to_visit_model.PlaceToVisit)
        .options(
            selectinload(place_to_visit_model.PlaceToVisit.place)
        )  # place 관계 로드
        .filter(place_to_visit_model.PlaceToVisit.id == place_to_visit_id)
    )
    record = result.scalars().first()
    
    return entity_to_dto(record)  # 방문할 장소 목록 반환

async def update_place_to_visit(db: AsyncSession, place_to_visit_id: int, place_to_visit: place_to_visit_dto.PlaceToVisit):
    db_place_to_visit = await get_place_to_visit(db, place_to_visit_id)
    if db_place_to_visit is None:
        return None  # 없을 시 None 반환
    for key, value in place_to_visit.dict().items():
        setattr(db_place_to_visit, key, value)  # 방문 장소 정보 업데이트
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place_to_visit)  # DB에서 갱신된 방문 장소 정보 가져오기
    return db_place_to_visit  # 업데이트된 방문 장소 반환

# 방문할 장소 삭제
async def delete_place_to_visit(db: AsyncSession, place_to_visit_id: int):
    result = await db.execute(
        select(place_to_visit_model.PlaceToVisit)
        .options(
            selectinload(place_to_visit_model.PlaceToVisit.place)
        )  # place 관계 로드
        .filter(place_to_visit_model.PlaceToVisit.id == place_to_visit_id)
    )
    record = result.scalars().first()
    db_place_to_visit = record
    if db_place_to_visit is None:
        return None  # 방문할 장소 없을 시 None 반환
    await db.delete(db_place_to_visit)  # 방문할 장소 삭제
    await db.commit()  # 변경 사항 커밋
    return db_place_to_visit  # 삭제된 방문할 장소 반환

def entity_to_dto(entity: place_to_visit_model.PlaceToVisit) -> place_to_visit_dto.PlaceToVisitDetailResponse:
    return place_to_visit_dto.PlaceToVisitDetailResponse(
        id=entity.id,
        travel_schedule_id=entity.travel_schedule_id,
        place_id=entity.place_id,
        user_memo=entity.user_memo,
        created_at=entity.created_at,
        place=place_dto.Place(
            id=entity.place.id,
            place_name=entity.place.place_name,
            x=entity.place.x,
            y=entity.place.y,
            road_address_name=entity.place.road_address_name,
            place_url=entity.place.place_url,
            visitor_characteristics=entity.place.visitor_characteristics,
            estimated_cost=entity.place.estimated_cost,
            estimated_duration=entity.place.estimated_duration,
            img_url=entity.place.img_url,
            created_at=entity.place.created_at
        )
    )
