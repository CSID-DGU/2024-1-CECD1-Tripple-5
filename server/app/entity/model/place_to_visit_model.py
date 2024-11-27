from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base

class PlaceToVisit(Base):
    __tablename__ = 'place_to_visit'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    travel_schedule_id = Column(BigInteger, ForeignKey('travel_schedule.id'))  # bigint로 변경
    place_id = Column(BigInteger, ForeignKey('place.id'))  # bigint로 변경
    user_memo = Column(Text)  # String -> Text로 변경

    order_index = Column(BigInteger)

    created_at = Column(DateTime, default=datetime.utcnow)  # timestamp -> created_at으로 변경

    travel_schedule = relationship("TravelSchedule", back_populates="places_to_visit")
    place = relationship("Place", back_populates="places_to_visit")
