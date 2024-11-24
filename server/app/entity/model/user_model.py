from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base


class User(Base):
    __tablename__ = 'user'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    accommodation_budget = Column(DECIMAL(10, 2))  # decimal(10,2)로 변경
    food_budget = Column(DECIMAL(10, 2))  # decimal(10,2)로 변경
    sightseeing_budget = Column(DECIMAL(10, 2))  # decimal(10,2)로 변경
    travel_theme = Column(String(255))  # varchar(255)
    created_at = Column(DateTime, default=datetime.utcnow)  # created_at 추가
    updated_at = Column(DateTime, default=datetime.utcnow)

    recommendation_records = relationship("RecommendationRecord", back_populates="user")
    chat_rooms = relationship("ChatRoom", back_populates="user")
    travel_schedules = relationship("TravelSchedule", back_populates="user")

