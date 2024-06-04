package com.example.traveltalk.data.repository

import com.example.traveltalk.data.datasource.remote.DummyDataSource
import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.domain.entity.DummyInfoList
import com.example.traveltalk.domain.repository.DummyRepository
import javax.inject.Inject

class DummyRepositoryImpl @Inject constructor(
    private val dummyDataSource: DummyDataSource
) : DummyRepository {

    override suspend fun insertDummy(requestDummyDto: RequestDummyDto): Result<DummyInfoList> =
        runCatching { dummyDataSource.dummy(requestDummyDto).toDummyInfo() }
}