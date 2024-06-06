package com.example.traveltalk.domain.usecase

import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.domain.entity.DummyInfoList
import com.example.traveltalk.domain.repository.DummyRepository
import javax.inject.Inject

class DummyUseCase @Inject constructor(
    private val dummyRepository: DummyRepository
) {

    suspend operator fun invoke(dummy: RequestDummyDto) = dummyRepository.insertDummy(dummy)
}