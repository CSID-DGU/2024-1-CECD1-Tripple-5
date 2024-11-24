from sqlalchemy import and_, or_
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from ..dto import user_dto
from ..entity.model import user_model
from .chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload

# User CRUD
# 새로운 사용자 생성
async def create_user(db: AsyncSession, user: user_dto.UserCreate):
    db_user = user_model.User(**user.dict())  # User 모델 인스턴스 생성
    db.add(db_user)  # DB에 사용자 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_user)  # DB에서 새로 추가된 사용자 정보 갱신

    return db_user  # 새로 생성된 사용자 반환

# 특정 사용자 조회
async def get_user(db: AsyncSession, user_id: int):
    result = await db.execute(select(user_model.User).filter(user_model.User.id == user_id))
    return result.scalars().first()  # 첫 번째 사용자 반환

# 모든 사용자 조회
async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(user_model.User).offset(skip).limit(limit))
    return result.scalars().all()  # 사용자 목록 반환

# 사용자 정보 업데이트
async def update_user(db: AsyncSession, user_id: int, user: user_dto.UserCreate):
    db_user = await get_user(db, user_id)
    if db_user is None:
        return None  # 사용자 없을 시 None 반환
    for key, value in user.dict().items():
        setattr(db_user, key, value)  # 사용자 정보 업데이트
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_user)  # DB에서 갱신된 사용자 정보 가져오기
    return db_user  # 업데이트된 사용자 반환

# 사용자 삭제
async def delete_user(db: AsyncSession, user_id: int):
    db_user = await get_user(db, user_id)
    if db_user is None:
        return None  # 사용자 없을 시 None 반환
    await db.delete(db_user)  # 사용자 삭제
    await db.commit()  # 변경 사항 커밋
    return db_user  # 삭제된 사용자 반환
