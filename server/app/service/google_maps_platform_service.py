import requests
from fastapi import HTTPException
import os
from dotenv import load_dotenv
import httpx

# 환경 변수 로드
load_dotenv()

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")

# Google Maps Reverse Geocoding API 호출 메소드 (비동기)
async def get_reverse_geocoding(x: float, y: float) -> str:
    """
    Google Maps Reverse Geocoding API를 호출하여 도로명 주소를 반환합니다 (비동기 처리).
    """
    # print(f"확인 @@@@@@@ {x},{y}")
    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {
        "latlng": f"{y},{x}",
        "language": "ko",  # 결과를 한국어로 반환
        "key": GOOGLE_MAPS_API_KEY,
    }

    async with httpx.AsyncClient() as client:
        try:
            response = await client.get(base_url, params=params)
            # print(f"반환된 data: {response}")
            response.raise_for_status()
            data = response.json()

            # 주소 가져오기
            if data["status"] == "OK" and data["results"]:
                locatio_str = data["results"][0]["formatted_address"]
                # print(f"위치: ({x},{y}) -> {locatio_str}")
                return locatio_str
            else:
                raise HTTPException(
                    status_code=404,
                    detail="Address not found for the given coordinates."
                )
        except httpx.RequestError as e:
            raise HTTPException(status_code=500, detail=f"External API request failed: {str(e)}")