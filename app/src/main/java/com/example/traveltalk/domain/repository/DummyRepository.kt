package com.example.traveltalk.domain.repository

import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.domain.entity.DummyInfoList

interface DummyRepository {

    suspend fun insertDummy(requestDummyDto: RequestDummyDto): Result<DummyInfoList>
}