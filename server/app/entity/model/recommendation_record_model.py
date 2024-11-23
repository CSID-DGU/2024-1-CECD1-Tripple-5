from sqlalchemy import DECIMAL, Column, Date, ForeignKey, Integer, String, DateTime, Text, Boolean, Float, BigInteger
from sqlalchemy.orm import relationship
from datetime import datetime
from ...config.database import Base


class RecommendationRecord(Base):
    __tablename__ = 'recommendation_record'

    id = Column(BigInteger, primary_key=True, autoincrement=True)  # bigint로 변경
    user_id = Column(BigInteger, ForeignKey('user.id'))  # bigint로 변경
    place_id = Column(BigInteger, ForeignKey('place.id'))  # 외래키 place_id 추가
    recommendation_name = Column(String(255))  # recommendation_name 컬럼 추가
    created_at = Column(DateTime, default=datetime.utcnow)  # updated_at 제거

    user = relationship("User", back_populates="recommendation_records")
    place = relationship("Place")  # Place와의 관계 추가

