from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base


class ChatRecord(Base):
    __tablename__ = 'chat_record'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    chat_room_id = Column(BigInteger, ForeignKey('chat_room.id'))  # user_id 제거
    message = Column(Text)  # String -> Text로 변경
    is_chatbot = Column(Boolean)
    place_ids_str = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)  # timestamp -> created_at으로 변경

    chat_room = relationship("ChatRoom", back_populates="chat_records")
