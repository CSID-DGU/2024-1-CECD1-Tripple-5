from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base

class Place(Base):
    __tablename__ = 'place'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    place_name = Column(String(255))  # varchar(255)
    x = Column(Float)  # double -> Float
    y = Column(Float)  # double -> Float
    road_address_name = Column(String(255))  # varchar(255)
    place_url = Column(String(255))  # boolean -> varchar(255)로 변경
    place_description = Column(Text)  # varchar -> Text로 변경
    place_cost = Column(DECIMAL(10, 2))  # decimal(10,2)
    created_at = Column(DateTime, default=datetime.utcnow)  # timestamp -> created_at으로 변경

    places_to_visit = relationship("PlaceToVisit", back_populates="place")