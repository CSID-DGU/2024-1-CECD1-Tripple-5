package com.example.traveltalk.data.service

import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.data.model.response.ResponseDummyDto
import retrofit2.http.Body
import retrofit2.http.POST

interface DummyService {
    @POST("oauth/login")
    suspend fun dummy(
        @Body requestDummyDto: RequestDummyDto,
    ): ResponseDummyDto
}
