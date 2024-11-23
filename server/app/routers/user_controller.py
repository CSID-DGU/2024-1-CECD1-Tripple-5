from fastapi import APIRouter, Depends, HTTPException
from rich import _console
from sqlalchemy.orm import Session

from ..dto import user_dto
from ..service import user_service
from ..config.database import SessionLocal, engine
from sqlalchemy.ext.asyncio import AsyncSession
from ..config.database import get_db
from typing import List


# 라우터 생성
router = APIRouter()

# User 엔드포인트

# 새로운 사용자 생성 엔드포인트
@router.post("/users/", response_model=user_dto.User)
async def create_user(user: user_dto.UserCreate, db: AsyncSession = Depends(get_db)):
    # 새로운 사용자를 생성하는 CRUD 함수 호출
    response = await user_service.create_user(db=db, user=user)

    return response.__dict__

# 특정 사용자 조회 엔드포인트
@router.get("/users/{user_id}", response_model=user_dto.User)
async def read_user(user_id: int, db: AsyncSession = Depends(get_db)):
    # 특정 사용자 정보를 CRUD 함수로 조회
    db_user = await user_service.get_user(db=db, user_id=user_id)
    # 사용자가 없을 경우 404 에러 반환
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    # 조회된 사용자 반환
    return db_user.__dict__

# 모든 사용자 조회 엔드포인트
@router.get("/users/", response_model=user_dto.UsersResponse)
async def read_users(skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)):
    # CRUD 함수를 통해 사용자 리스트를 조회
    users = await user_service.get_users(db=db, skip=skip, limit=limit)
    # 조회된 사용자 리스트 반환
    users = [user.__dict__ for user in users]
    return {"users":users}

# 사용자 정보 업데이트 엔드포인트
@router.put("/users/{user_id}", response_model=user_dto.User)
async def update_user(user_id: int, user: user_dto.UserCreate, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 사용자 정보를 업데이트
    db_user = await user_service.update_user(db=db, user_id=user_id, user=user)
    # 사용자가 없을 경우 404 에러 반환
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    # 업데이트된 사용자 정보 반환
    return db_user.__dict__

# 사용자 삭제 엔드포인트
@router.delete("/users/{user_id}", response_model=user_dto.User)
async def delete_user(user_id: int, db: AsyncSession = Depends(get_db)):
    # CRUD 함수로 사용자 삭제 수행
    db_user = await user_service.delete_user(db=db, user_id=user_id)
    # 사용자가 없을 경우 404 에러 반환
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    # 삭제된 사용자 정보 반환
    return db_user.__dict__