from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.service import crud
from app.config.database import engine, get_db
from app.dto import schemas
from app.entity import models
from .routers import chat
from .routers import recommendation
from .routers import travel
from .routers import user
from .routers import place

app = FastAPI()

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        # await conn.run_sync(models.Base.metadata.drop_all)  # 모든 테이블 드롭 <- 배포단계에서 지울 것
        await conn.run_sync(models.Base.metadata.create_all)  # 테이블 다시 생성

app.include_router(user.router, prefix="/api/v1", tags=["user"])
app.include_router(chat.router, prefix="/api/v1", tags=["chat"])
app.include_router(travel.router, prefix="/api/v1", tags=["travel"])
app.include_router(place.router, prefix="/api/v1", tags=["place"])
app.include_router(recommendation.router, prefix="/api/v1", tags=["recommendation"])
