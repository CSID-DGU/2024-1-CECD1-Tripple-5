package com.example.traveltalk.data.datasource.remote

import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.data.model.response.ResponseDummyDto
import com.example.traveltalk.data.service.DummyService
import javax.inject.Inject

class DummyDataSource @Inject constructor(
    private val dummyService: DummyService,
) {
    suspend fun dummy(
        requestDummyDto: RequestDummyDto,
    ): ResponseDummyDto =
        dummyService.dummy(requestDummyDto)
}
