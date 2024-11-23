from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import place_dto
from ..entity.model import place_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

# CRUD 함수 정의

# Place CRUD
# 새로운 장소 생성
async def create_place(db: AsyncSession, place: place_dto.PlaceCreate):
    db_place = place.Place(**place.dict())
    db.add(db_place)  # DB에 장소 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place)  # DB에서 새로 추가된 장소 정보 갱신
    return db_place  # 새로 생성된 장소 반환

# 특정 장소 조회
async def get_place(db: AsyncSession, place_id: int):
    result = await db.execute(select(place_model.Place).filter(place_model.Place.id == place_id))
    return result.scalars().first()  # 첫 번째 장소 반환

# 모든 장소 조회
async def get_places(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(place_model.Place).offset(skip).limit(limit))
    return result.scalars().all()  # 장소 목록 반환

async def search_places(db: AsyncSession, unified_search_term: str="", place_name: str = "", road_address_name: str = "", place_description: str = ""):
    filters = []
    result = None
    query = None
    if unified_search_term: # 여러 필드에서 합집합으로 부분일치 검색
        unified_filters = or_(
            place_model.Place.place_name.ilike(f"%{unified_search_term}%"),
            place_model.Place.road_address_name.ilike(f"%{unified_search_term}%"),
            place_model.Place.place_description.ilike(f"%{unified_search_term}%")
        )
        filters.append(unified_filters)

    if place_name:
        filters.append(place_model.Place.place_name.ilike(f"%{place_name}%"))  # 부분 일치 검색 (대소문자 구분 없음)
    
    if road_address_name:
        filters.append(place_model.Place.road_address_name.ilike(f"%{road_address_name}%"))
    
    if place_description:
        filters.append(place_model.Place.place_description.ilike(f"%{place_description}%"))

    if filters:
        query = select(place_model.Place).where(and_(*filters))  # *filters는 리스트의 모든 항목을 조건으로 넣음
    else:
        query = select(place_model.Place)  # 검색어가 아무것도 없을 경우 전체 조회

    result = await db.execute(query)
    # 결과 반환
    return result.scalars().all()

# 장소 삭제
async def delete_place(db: AsyncSession, place_id: int):
    db_place = await get_place(db, place_id)
    if db_place is None:
        return None  # 장소 없을 시 None 반환
    await db.delete(db_place)  # 장소 삭제
    await db.commit()  # 변경 사항 커밋
    return db_place  # 삭제된 장소 반환

