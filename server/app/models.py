from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from .database import Base

# class ChatRoom(Base):
#     __tablename__ = "chat_rooms"

#     id = Column(Integer, primary_key=True, index=True)
#     name = Column(String, index=True)
#     created_at = Column(DateTime, default=datetime.utcnow)
#     updated_at = Column(DateTime, default=datetime.utcnow)

#     chat_records = relationship("ChatRecord", back_populates="chat_room")

# class ChatRecord(Base):
#     __tablename__ = "chat_records"

#     id = Column(Integer, primary_key=True, index=True)
#     chat_room_id = Column(Integer, ForeignKey("chat_rooms.id"))
#     message = Column(Text)
#     timestamp = Column(DateTime, default=datetime.utcnow)
#     is_chatbot = Column(Boolean, default=False)

#     chat_room = relationship("ChatRoom", back_populates="chat_records")


class User(Base):
    __tablename__ = 'user'

    id = Column(Integer, primary_key=True, autoincrement=True)
    accommodation_budget = Column(Float)
    food_budget = Column(Float)
    sightseeing_budget = Column(Float)
    travel_theme = Column(String(255))
    updated_at = Column(DateTime, default=datetime.utcnow)

    recommendation_records = relationship("RecommendationRecord", back_populates="user")
    chat_rooms = relationship("ChatRoom", back_populates="user")
    travel_schedules = relationship("TravelSchedule", back_populates="user")

class RecommendationRecord(Base):
    __tablename__ = 'recommendation_record'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'))
    name = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="recommendation_records")

class ChatRoom(Base):
    __tablename__ = 'chat_room'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'))
    name = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="chat_rooms")
    chat_records = relationship("ChatRecord", back_populates="chat_room")

class ChatRecord(Base):
    __tablename__ = 'chat_record'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'))
    chat_room_id = Column(Integer, ForeignKey('chat_room.id'))
    message = Column(String)
    is_chatbot = Column(Boolean)
    timestamp = Column(DateTime, default=datetime.utcnow)

    chat_room = relationship("ChatRoom", back_populates="chat_records")

class TravelSchedule(Base):
    __tablename__ = 'travel_schedule'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('user.id'))
    trip_name = Column(String(255))
    start_date = Column(String(255))
    end_date = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="travel_schedules")
    places_to_visit = relationship("PlaceToVisit", back_populates="travel_schedule")

class PlaceToVisit(Base):
    __tablename__ = 'place_to_visit'

    id = Column(Integer, primary_key=True, autoincrement=True)
    travel_schedule_id = Column(Integer, ForeignKey('travel_schedule.id'))
    place_id = Column(Integer, ForeignKey('place.id'))
    user_memo = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)

    travel_schedule = relationship("TravelSchedule", back_populates="places_to_visit")
    place = relationship("Place", back_populates="places_to_visit")

class Place(Base):
    __tablename__ = 'place'

    id = Column(Integer, primary_key=True, autoincrement=True)
    place_name = Column(String(255))
    x = Column(Float)
    y = Column(Float)
    road_address_name = Column(String(255))
    place_url = Column(Boolean)
    place_description = Column(String(255))
    place_cost = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)

    places_to_visit = relationship("PlaceToVisit", back_populates="place")
