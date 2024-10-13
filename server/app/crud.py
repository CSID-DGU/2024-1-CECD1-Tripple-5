from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from . import models, schemas
from .service.chatbot.chat import get_response_from_chatgpt
from sqlalchemy.orm import selectinload


# async def get_chat_rooms(db: AsyncSession):
#     result = await db.execute(select(models.ChatRoom))
#     chatrooms = [chatroom.__dict__ for chatroom in result.scalars().all()]
#     return {"chat_rooms":chatrooms}

# async def create_chat_room(db: AsyncSession, chat_room: schemas.ChatRoomCreate):
#     db_chat_room = models.ChatRoom(name=chat_room.name)
#     db.add(db_chat_room)
#     await db.commit()
#     await db.refresh(db_chat_room)
#     return db_chat_room.__dict__

# async def create_chat_record(db: AsyncSession, chat_record: schemas.ChatRecordCreate, chat_room_id: int):
#     db_chat_record = models.ChatRecord(**chat_record.__dict__, chat_room_id=chat_room_id)
#     db.add(db_chat_record)
#     await db.commit()
#     await db.refresh(db_chat_record)
#     # chatgpt로부터 response 받기
#     chatbot_response = await get_response_from_chatgpt(chat_record.message)
#     db_chat_record_response = models.ChatRecord(
#         message=chatbot_response,
#         is_chatbot=True,
#         chat_room_id=chat_room_id
#     )
#     db.add(db_chat_record_response)
#     await db.commit()
#     await db.refresh(db_chat_record_response)
#     #
#     return db_chat_record_response.__dict__

# async def get_chat_records(db: AsyncSession, chat_room_id: int):
#     result = await db.execute(
#         select(models.ChatRecord)
#         .filter(models.ChatRecord.chat_room_id == chat_room_id)
#     )
#     # return result.scalars().all().__dict__
#     records = [record.__dict__ for record in result.scalars().all()]
#     return {"chat_records":records}


# CRUD 함수 정의
# User CRUD
# 새로운 사용자 생성
# async def create_user(db: AsyncSession, user: schemas.UserCreate):
#     db_user = models.User(**user.dict())  # User 모델 인스턴스 생성
#     db.add(db_user)  # DB에 사용자 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_user)  # DB에서 새로 추가된 사용자 정보 갱신
#     return db_user  # 새로 생성된 사용자 반환

import logging

# # 로깅 설정
logging.basicConfig(level=logging.INFO)

# async def create_user(db: AsyncSession, user: schemas.UserCreate):
#     # user 변수 출력
#     logging.info(f"user 데이터: {user}")

#     # user.dict() 출력
#     logging.info(f"user dict: {user.dict()}")

#     # User 모델 인스턴스 생성
#     db_user = models.User(**user.dict())  
#     logging.info(f"생성된 db_user: {db_user}")

#     # DB에 사용자 추가
#     db.add(db_user)

#     # 변경 사항 커밋
#     await db.commit()  
#     logging.info("DB 커밋 완료")

#     # DB에서 새로 추가된 사용자 정보 갱신
#     await db.refresh(db_user)
#     logging.info(f"갱신된 db_user: {db_user}")
#     logging.info(f"갱신된 db_user: {schemas.User.from_orm(db_user)}")
    
#     # 새로 생성된 사용자 반환
#     return db_user  

# # 특정 사용자 조회
# async def get_user(db: AsyncSession, user_id: int):
#     # result = await db.execute(select(models.User).filter(models.User.id == user_id).options(selectinload(models.User.recommendation_records)))
#     result = await db.execute(select(models.User).filter(models.User.id == user_id))
#     return result.scalars().first()  # 첫 번째 사용자 반환

# # 모든 사용자 조회
# async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
#     result = await db.execute(select(models.User).offset(skip).limit(limit))
#     return result.scalars().all()  # 사용자 목록 반환

# # 사용자 정보 업데이트
# async def update_user(db: AsyncSession, user_id: int, user: schemas.UserCreate):
#     db_user = await get_user(db, user_id)
#     if db_user is None:
#         return None  # 사용자 없을 시 None 반환
#     for key, value in user.dict().items():
#         setattr(db_user, key, value)  # 사용자 정보 업데이트
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_user)  # DB에서 갱신된 사용자 정보 가져오기
#     return db_user  # 업데이트된 사용자 반환

# # 사용자 삭제
# async def delete_user(db: AsyncSession, user_id: int):
#     db_user = await get_user(db, user_id)
#     if db_user is None:
#         return None  # 사용자 없을 시 None 반환
#     await db.delete(db_user)  # 사용자 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_user  # 삭제된 사용자 반환


# # RecommendationRecord CRUD
# # 새로운 추천 기록 생성
# async def create_recommendation_record(db: AsyncSession, recommendation_record: schemas.RecommendationRecordCreate, user_id: int):
#     db_recommendation_record = models.RecommendationRecord(**recommendation_record.dict(), user_id=user_id)
#     db.add(db_recommendation_record)  # DB에 추천 기록 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_recommendation_record)  # DB에서 새로 추가된 추천 기록 정보 갱신
#     return db_recommendation_record  # 새로 생성된 추천 기록 반환

# # 특정 추천 기록 조회
# async def get_recommendation_record(db: AsyncSession, record_id: int):
#     result = await db.execute(select(models.RecommendationRecord).filter(models.RecommendationRecord.id == record_id))
#     return result.scalars().first()  # 첫 번째 추천 기록 반환

# # 특정 사용자의 모든 추천 기록 조회
# async def get_recommendation_records(db: AsyncSession, user_id: int):
#     result = await db.execute(select(models.RecommendationRecord).filter(models.RecommendationRecord.user_id == user_id))
#     return result.scalars().all()  # 추천 기록 목록 반환

# # 추천 기록 삭제
# async def delete_recommendation_record(db: AsyncSession, record_id: int):
#     db_record = await get_recommendation_record(db, record_id)
#     if db_record is None:
#         return None  # 추천 기록 없을 시 None 반환
#     await db.delete(db_record)  # 추천 기록 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_record  # 삭제된 추천 기록 반환


# # ChatRoom CRUD
# # 새로운 채팅방 생성
# async def create_chat_room(db: AsyncSession, chat_room: schemas.ChatRoomCreate, user_id: int):
#     db_chat_room = models.ChatRoom(**chat_room.dict(), user_id=user_id)
#     db.add(db_chat_room)  # DB에 채팅방 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_chat_room)  # DB에서 새로 추가된 채팅방 정보 갱신
#     return db_chat_room  # 새로 생성된 채팅방 반환

# # 특정 채팅방 조회
# async def get_chat_room(db: AsyncSession, chat_room_id: int):
#     result = await db.execute(select(models.ChatRoom).filter(models.ChatRoom.id == chat_room_id))
#     return result.scalars().first()  # 첫 번째 채팅방 반환

# # 특정 사용자의 모든 채팅방 조회
# async def get_chat_rooms(db: AsyncSession, user_id: int):
#     result = await db.execute(select(models.ChatRoom).filter(models.ChatRoom.user_id == user_id))
#     return result.scalars().all()  # 채팅방 목록 반환

# # 채팅방 삭제
# async def delete_chat_room(db: AsyncSession, chat_room_id: int):
#     db_chat_room = await get_chat_room(db, chat_room_id)
#     if db_chat_room is None:
#         return None  # 채팅방 없을 시 None 반환
#     await db.delete(db_chat_room)  # 채팅방 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_chat_room  # 삭제된 채팅방 반환


# # ChatRecord CRUD
# # 새로운 채팅 기록 생성
# async def create_chat_record(db: AsyncSession, chat_record: schemas.ChatRecordCreate, chat_room_id: int):
#     db_chat_record = models.ChatRecord(**chat_record.dict(), chat_room_id=chat_room_id)
#     db.add(db_chat_record)  # DB에 채팅 기록 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_chat_record)  # DB에서 새로 추가된 채팅 기록 정보 갱신
#     # chatgpt로부터 response 받기
#     chatbot_response = await get_response_from_chatgpt(chat_record.message)
#     db_chat_record_response = models.ChatRecord(
#         message=chatbot_response,
#         is_chatbot=True,
#         chat_room_id=chat_room_id
#     )
#     db.add(db_chat_record_response)
#     await db.commit()
#     await db.refresh(db_chat_record_response)
#     # 대답 반환
#     return db_chat_record_response


# # 특정 채팅방의 모든 채팅 기록 조회
# async def get_chat_records(db: AsyncSession, chat_room_id: int):
#     result = await db.execute(select(models.ChatRecord).filter(models.ChatRecord.chat_room_id == chat_room_id))
#     return result.scalars().all()  # 채팅 기록 목록 반환

# # 채팅 기록 삭제
# async def delete_chat_record(db: AsyncSession, chat_record_id: int):
#     db_chat_record = await get_chat_records(db, chat_record_id)
#     if db_chat_record is None:
#         return None  # 채팅 기록 없을 시 None 반환
#     await db.delete(db_chat_record)  # 채팅 기록 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_chat_record  # 삭제된 채팅 기록 반환


# # TravelSchedule CRUD
# # 새로운 여행 일정 생성
# async def create_travel_schedule(db: AsyncSession, travel_schedule: schemas.TravelScheduleCreate, user_id: int):
#     db_travel_schedule = models.TravelSchedule(**travel_schedule.dict(), user_id=user_id)
#     db.add(db_travel_schedule)  # DB에 여행 일정 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_travel_schedule)  # DB에서 새로 추가된 여행 일정 정보 갱신
#     return db_travel_schedule  # 새로 생성된 여행 일정 반환

# # 특정 여행 일정 조회
# async def get_travel_schedule(db: AsyncSession, schedule_id: int):
#     result = await db.execute(select(models.TravelSchedule).filter(models.TravelSchedule.id == schedule_id))
#     return result.scalars().first()  # 첫 번째 여행 일정 반환

# # 특정 사용자의 모든 여행 일정 조회
# async def get_travel_schedules(db: AsyncSession, user_id: int):
#     result = await db.execute(select(models.TravelSchedule).filter(models.TravelSchedule.user_id == user_id))
#     return result.scalars().all()  # 여행 일정 목록 반환

# # 여행 일정 삭제
# async def delete_travel_schedule(db: AsyncSession, schedule_id: int):
#     db_travel_schedule = await get_travel_schedule(db, schedule_id)
#     if db_travel_schedule is None:
#         return None  # 여행 일정 없을 시 None 반환
#     await db.delete(db_travel_schedule)  # 여행 일정 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_travel_schedule  # 삭제된 여행 일정 반환


# # PlaceToVisit CRUD
# # 새로운 방문할 장소 생성
# async def create_place_to_visit(db: AsyncSession, place_to_visit: schemas.PlaceToVisitCreate):
#     db_place_to_visit = models.PlaceToVisit(**place_to_visit.dict())
#     db.add(db_place_to_visit)  # DB에 방문할 장소 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_place_to_visit)  # DB에서 새로 추가된 방문할 장소 정보 갱신
#     return db_place_to_visit  # 새로 생성된 방문할 장소 반환

# # 특정 여행 일정의 모든 방문할 장소 조회
# async def get_places_to_visit(db: AsyncSession, travel_schedule_id: int):
#     result = await db.execute(select(models.PlaceToVisit).filter(models.PlaceToVisit.travel_schedule_id == travel_schedule_id))
#     return result.scalars().all()  # 방문할 장소 목록 반환

# # 방문할 장소 삭제
# async def delete_place_to_visit(db: AsyncSession, place_to_visit_id: int):
#     # db_place_to_visit = await get_place_to_visit(db, place_to_visit_id)
#     db_place_to_visit = await db.execute(select(models.PlaceToVisit).filter(models.PlaceToVisit.id == place_to_visit_id))
#     if db_place_to_visit is None:
#         return None  # 방문할 장소 없을 시 None 반환
#     await db.delete(db_place_to_visit)  # 방문할 장소 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_place_to_visit  # 삭제된 방문할 장소 반환


# # Place CRUD
# # 새로운 장소 생성
# async def create_place(db: AsyncSession, place: schemas.PlaceCreate):
#     db_place = models.Place(**place.dict())
#     db.add(db_place)  # DB에 장소 추가
#     await db.commit()  # 변경 사항 커밋
#     await db.refresh(db_place)  # DB에서 새로 추가된 장소 정보 갱신
#     return db_place  # 새로 생성된 장소 반환

# # 특정 장소 조회
# async def get_place(db: AsyncSession, place_id: int):
#     result = await db.execute(select(models.Place).filter(models.Place.id == place_id))
#     return result.scalars().first()  # 첫 번째 장소 반환

# # 모든 장소 조회
# async def get_places(db: AsyncSession, skip: int = 0, limit: int = 100):
#     result = await db.execute(select(models.Place).offset(skip).limit(limit))
#     return result.scalars().all()  # 장소 목록 반환

# # 장소 삭제
# async def delete_place(db: AsyncSession, place_id: int):
#     db_place = await get_place(db, place_id)
#     if db_place is None:
#         return None  # 장소 없을 시 None 반환
#     await db.delete(db_place)  # 장소 삭제
#     await db.commit()  # 변경 사항 커밋
#     return db_place  # 삭제된 장소 반환

#######################

# CRUD 함수 정의
# User CRUD
# 새로운 사용자 생성
async def create_user(db: AsyncSession, user: schemas.UserCreate):
    db_user = models.User(**user.dict())  # User 모델 인스턴스 생성
    db.add(db_user)  # DB에 사용자 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_user)  # DB에서 새로 추가된 사용자 정보 갱신
    # print("생성된 user"+user.dict())
    # logging.info(f"생성된 db_user: {db_user.dict()}")
    # logging.info(f"생성된 db_user: {models.from_orm(db_user)}")
    return db_user  # 새로 생성된 사용자 반환

# 특정 사용자 조회
async def get_user(db: AsyncSession, user_id: int):
    result = await db.execute(select(models.User).filter(models.User.id == user_id))
    return result.scalars().first()  # 첫 번째 사용자 반환

# 모든 사용자 조회
async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(models.User).offset(skip).limit(limit))
    return result.scalars().all()  # 사용자 목록 반환

# 사용자 정보 업데이트
async def update_user(db: AsyncSession, user_id: int, user: schemas.UserCreate):
    db_user = await get_user(db, user_id)
    if db_user is None:
        return None  # 사용자 없을 시 None 반환
    for key, value in user.dict().items():
        setattr(db_user, key, value)  # 사용자 정보 업데이트
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_user)  # DB에서 갱신된 사용자 정보 가져오기
    return db_user  # 업데이트된 사용자 반환

# 사용자 삭제
async def delete_user(db: AsyncSession, user_id: int):
    db_user = await get_user(db, user_id)
    if db_user is None:
        return None  # 사용자 없을 시 None 반환
    await db.delete(db_user)  # 사용자 삭제
    await db.commit()  # 변경 사항 커밋
    return db_user  # 삭제된 사용자 반환


# RecommendationRecord CRUD
# 새로운 추천 기록 생성
async def create_recommendation_record(db: AsyncSession, recommendation_record: schemas.RecommendationRecordCreate, user_id: int):
    db_recommendation_record = models.RecommendationRecord(**recommendation_record.dict(), user_id=user_id)
    db.add(db_recommendation_record)  # DB에 추천 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_recommendation_record)  # DB에서 새로 추가된 추천 기록 정보 갱신
    return db_recommendation_record  # 새로 생성된 추천 기록 반환

# 특정 추천 기록 조회
async def get_recommendation_record(db: AsyncSession, record_id: int):
    result = await db.execute(select(models.RecommendationRecord).filter(models.RecommendationRecord.id == record_id))
    return result.scalars().first()  # 첫 번째 추천 기록 반환

# 특정 사용자의 모든 추천 기록 조회
async def get_recommendation_records(db: AsyncSession, user_id: int):
    result = await db.execute(select(models.RecommendationRecord).filter(models.RecommendationRecord.user_id == user_id))
    return result.scalars().all()  # 추천 기록 목록 반환

# 추천 기록 삭제
async def delete_recommendation_record(db: AsyncSession, record_id: int):
    db_record = await get_recommendation_record(db, record_id)
    if db_record is None:
        return None  # 추천 기록 없을 시 None 반환
    await db.delete(db_record)  # 추천 기록 삭제
    await db.commit()  # 변경 사항 커밋
    return db_record  # 삭제된 추천 기록 반환



# ChatRoom CRUD
# 새로운 채팅방 생성
async def create_chat_room(db: AsyncSession, chat_room: schemas.ChatRoomCreate, user_id: int):
    db_chat_room = models.ChatRoom(**chat_room.dict(), user_id=user_id)
    db.add(db_chat_room)  # DB에 채팅방 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_room)  # DB에서 새로 추가된 채팅방 정보 갱신
    return db_chat_room  # 새로 생성된 채팅방 반환

# 특정 채팅방 조회
async def get_chat_room(db: AsyncSession, chat_room_id: int):
    result = await db.execute(select(models.ChatRoom).filter(models.ChatRoom.id == chat_room_id))
    return result.scalars().first()  # 첫 번째 채팅방 반환

# 특정 사용자의 모든 채팅방 조회
async def get_chat_rooms(db: AsyncSession, user_id: int):
    result = await db.execute(select(models.ChatRoom).filter(models.ChatRoom.user_id == user_id))
    return result.scalars().all()  # 채팅방 목록 반환

# 채팅방 삭제
async def delete_chat_room(db: AsyncSession, chat_room_id: int):
    db_chat_room = await get_chat_room(db, chat_room_id)
    if db_chat_room is None:
        return None  # 채팅방 없을 시 None 반환
    await db.delete(db_chat_room)  # 채팅방 삭제
    await db.commit()  # 변경 사항 커밋
    return db_chat_room  # 삭제된 채팅방 반환


# ChatRecord CRUD
# 새로운 채팅 기록 생성
async def create_chat_record(db: AsyncSession, chat_record: schemas.ChatRecordCreate, chat_room_id: int):
    db_chat_record = models.ChatRecord(**chat_record.dict(), chat_room_id=chat_room_id)
    db.add(db_chat_record)  # DB에 채팅 기록 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_chat_record)  # DB에서 새로 추가된 채팅 기록 정보 갱신
    # chatgpt로부터 response 받기
    chatbot_response = await get_response_from_chatgpt(chat_record.message)
    db_chat_record_response = models.ChatRecord(
        message=chatbot_response,
        is_chatbot=True,
        chat_room_id=chat_room_id
    )
    db.add(db_chat_record_response)
    await db.commit()
    await db.refresh(db_chat_record_response)
    # 대답 반환
    return db_chat_record_response


# 특정 채팅방의 모든 채팅 기록 조회
async def get_chat_records(db: AsyncSession, chat_room_id: int):
    result = await db.execute(select(models.ChatRecord).filter(models.ChatRecord.chat_room_id == chat_room_id))
    return result.scalars().all()  # 채팅 기록 목록 반환

async def get_chat_record(db: AsyncSession, chat_record_id: int):
    result = await db.execute(select(models.ChatRecord).filter(models.ChatRecord.id == chat_record_id))
    return result.scalars().first()  # 채팅 기록 반환


# 채팅 기록 삭제
async def delete_chat_record(db: AsyncSession, chat_record_id: int):
    db_chat_record = await get_chat_record(db, chat_record_id)
    if db_chat_record is None:
        return None  # 채팅 기록 없을 시 None 반환
    await db.delete(db_chat_record)  # 채팅 기록 삭제
    await db.commit()  # 변경 사항 커밋
    return db_chat_record  # 삭제된 채팅 기록 반환


# TravelSchedule CRUD
# 새로운 여행 일정 생성
async def create_travel_schedule(db: AsyncSession, travel_schedule: schemas.TravelScheduleCreate, user_id: int):
    db_travel_schedule = models.TravelSchedule(**travel_schedule.dict(), user_id=user_id)
    db.add(db_travel_schedule)  # DB에 여행 일정 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_travel_schedule)  # DB에서 새로 추가된 여행 일정 정보 갱신
    return db_travel_schedule  # 새로 생성된 여행 일정 반환

# 특정 여행 일정 조회
async def get_travel_schedule(db: AsyncSession, schedule_id: int):
    result = await db.execute(select(models.TravelSchedule).filter(models.TravelSchedule.id == schedule_id))
    return result.scalars().first()  # 첫 번째 여행 일정 반환

# 특정 사용자의 모든 여행 일정 조회
async def get_travel_schedules(db: AsyncSession, user_id: int):
    result = await db.execute(select(models.TravelSchedule).filter(models.TravelSchedule.user_id == user_id))
    return result.scalars().all()  # 여행 일정 목록 반환

# 여행 일정 삭제
async def delete_travel_schedule(db: AsyncSession, schedule_id: int):
    db_travel_schedule = await get_travel_schedule(db, schedule_id)
    if db_travel_schedule is None:
        return None  # 여행 일정 없을 시 None 반환
    await db.delete(db_travel_schedule)  # 여행 일정 삭제
    await db.commit()  # 변경 사항 커밋
    return db_travel_schedule  # 삭제된 여행 일정 반환


# PlaceToVisit CRUD
# 새로운 방문할 장소 생성
async def create_place_to_visit(db: AsyncSession, place_to_visit: schemas.PlaceToVisitCreate, travel_schedule_id: int):
    db_place_to_visit = models.PlaceToVisit(**place_to_visit.dict(), travel_schedule_id=travel_schedule_id)
    db.add(db_place_to_visit)  # DB에 방문할 장소 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place_to_visit)  # DB에서 새로 추가된 방문할 장소 정보 갱신
    return db_place_to_visit  # 새로 생성된 방문할 장소 반환

# 특정 여행 일정의 모든 방문할 장소 조회
async def get_places_to_visit(db: AsyncSession, travel_schedule_id: int):
    result = await db.execute(select(models.PlaceToVisit).filter(models.PlaceToVisit.travel_schedule_id == travel_schedule_id))
    return result.scalars().all()  # 방문할 장소 목록 반환

# 방문 장소 조회
async def get_place_to_visit(db: AsyncSession, place_to_visit_id: int):
    result = await db.execute(select(models.PlaceToVisit).filter(models.PlaceToVisit.id == place_to_visit_id))
    return result.scalars().first()  # 방문할 장소 목록 반환

async def update_place_to_visit(db: AsyncSession, place_to_visit_id: int, place_to_visit: schemas.PlaceToVisit):
    db_place_to_visit = await get_place_to_visit(db, place_to_visit_id)
    if db_place_to_visit is None:
        return None  # 없을 시 None 반환
    for key, value in place_to_visit.dict().items():
        setattr(db_place_to_visit, key, value)  # 방문 장소 정보 업데이트
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place_to_visit)  # DB에서 갱신된 방문 장소 정보 가져오기
    return db_place_to_visit  # 업데이트된 방문 장소 반환

# 방문할 장소 삭제
async def delete_place_to_visit(db: AsyncSession, place_to_visit_id: int):
    db_place_to_visit = await get_place_to_visit(db, place_to_visit_id)
    if db_place_to_visit is None:
        return None  # 방문할 장소 없을 시 None 반환
    await db.delete(db_place_to_visit)  # 방문할 장소 삭제
    await db.commit()  # 변경 사항 커밋
    return db_place_to_visit  # 삭제된 방문할 장소 반환


# Place CRUD
# 새로운 장소 생성
async def create_place(db: AsyncSession, place: schemas.PlaceCreate):
    db_place = models.Place(**place.dict())
    db.add(db_place)  # DB에 장소 추가
    await db.commit()  # 변경 사항 커밋
    await db.refresh(db_place)  # DB에서 새로 추가된 장소 정보 갱신
    return db_place  # 새로 생성된 장소 반환

# 특정 장소 조회
async def get_place(db: AsyncSession, place_id: int):
    result = await db.execute(select(models.Place).filter(models.Place.id == place_id))
    return result.scalars().first()  # 첫 번째 장소 반환

# 모든 장소 조회
async def get_places(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(models.Place).offset(skip).limit(limit))
    return result.scalars().all()  # 장소 목록 반환

# 장소 삭제
async def delete_place(db: AsyncSession, place_id: int):
    db_place = await get_place(db, place_id)
    if db_place is None:
        return None  # 장소 없을 시 None 반환
    await db.delete(db_place)  # 장소 삭제
    await db.commit()  # 변경 사항 커밋
    return db_place  # 삭제된 장소 반환

