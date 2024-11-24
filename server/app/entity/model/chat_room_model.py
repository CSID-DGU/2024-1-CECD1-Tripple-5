from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base


class ChatRoom(Base):
    __tablename__ = 'chat_room'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    user_id = Column(BigInteger, ForeignKey('user.id'))  # bigint로 변경
    chat_room_name = Column(String(255))  # name -> chat_room_name으로 변경
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User", back_populates="chat_rooms")
    chat_records = relationship("ChatRecord", back_populates="chat_room")
