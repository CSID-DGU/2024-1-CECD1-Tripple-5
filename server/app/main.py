from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.service import *
from app.config.database import engine, get_db
from app.entity import models
from app.routers import user_controller
from app.routers import chat_room_controller
from app.routers import travel_schedule_controller
from app.routers import place_controller
from app.routers import recommendation_record_controller
from app.routers import place_to_visit_controller
from app.routers import chat_record_controller

app = FastAPI()

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        # await conn.run_sync(models.Base.metadata.drop_all)  # 모든 테이블 드롭 <- 배포단계에서 지울 것
        await conn.run_sync(models.Base.metadata.create_all)  # 테이블 다시 생성

app.include_router(user_controller.router, prefix="/api/v1", tags=["user"])
app.include_router(chat_room_controller.router, prefix="/api/v1", tags=["chat_room"])
app.include_router(chat_record_controller.router, prefix="/api/v1", tags=["chat_record"])
app.include_router(travel_schedule_controller.router, prefix="/api/v1", tags=["travel_schedule"])
app.include_router(place_to_visit_controller.router, prefix="/api/v1", tags=["place_to_visit"])
app.include_router(place_controller.router, prefix="/api/v1", tags=["place"])
app.include_router(recommendation_record_controller.router, prefix="/api/v1", tags=["recommendation_record"])