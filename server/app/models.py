from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
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


class RecommendationRecord(Base):
    __tablename__ = 'recommendation_record'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    user_id = Column(BigInteger, ForeignKey('user.id'))  # bigint로 변경
    place_id = Column(BigInteger, ForeignKey('place.id'))  # 외래키 place_id 추가
    recommendation_name = Column(String(255))  # recommendation_name 컬럼 추가
    created_at = Column(DateTime, default=datetime.utcnow)  # updated_at 제거

    user = relationship("User", back_populates="recommendation_records")
    place = relationship("Place")  # Place와의 관계 추가


class ChatRoom(Base):
    __tablename__ = 'chat_room'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    user_id = Column(BigInteger, ForeignKey('user.id'))  # bigint로 변경
    chat_room_name = Column(String(255))  # name -> chat_room_name으로 변경
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="chat_rooms")
    chat_records = relationship("ChatRecord", back_populates="chat_room")


class ChatRecord(Base):
    __tablename__ = 'chat_record'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    chat_room_id = Column(BigInteger, ForeignKey('chat_room.id'))  # user_id 제거
    message = Column(Text)  # String -> Text로 변경
    is_chatbot = Column(Boolean)
    created_at = Column(DateTime, default=datetime.utcnow)  # timestamp -> created_at으로 변경

    chat_room = relationship("ChatRoom", back_populates="chat_records")


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


class PlaceToVisit(Base):
    __tablename__ = 'place_to_visit'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    travel_schedule_id = Column(BigInteger, ForeignKey('travel_schedule.id'))  # bigint로 변경
    place_id = Column(BigInteger, ForeignKey('place.id'))  # bigint로 변경
    user_memo = Column(Text)  # String -> Text로 변경
    created_at = Column(DateTime, default=datetime.utcnow)  # timestamp -> created_at으로 변경

    travel_schedule = relationship("TravelSchedule", back_populates="places_to_visit")
    place = relationship("Place", back_populates="places_to_visit")


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