from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base

class TravelSchedule(Base):
    __tablename__ = 'travel_schedule'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    user_id = Column(BigInteger, ForeignKey('user.id'))  # bigint로 변경
    trip_name = Column(String(255))  # varchar(255)
    start_date = Column(Date)  # date 타입으로 변경
    end_date = Column(Date)  # date 타입으로 변경
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="travel_schedules")
    places_to_visit = relationship("PlaceToVisit", back_populates="travel_schedule")

