package com.example.traveltalk.data.model.response

import com.example.traveltalk.domain.entity.DummyInfoList
import kotlinx.serialization.Serializable

@Serializable
data class ResponseDummyDto(
    val status: Int,
    val message: String,
    val data: List<DummyData>,
) {
    @Serializable
    data class DummyData(
        val id: Int,
        val name: String,
        val email: String,
    )

    fun toDummyInfo() = DummyInfoList(
        dummyInfo = data.map { dummy ->
            DummyInfoList.DummyInfo(
                id = dummy.id,
                name = dummy.name,
                email = dummy.email,
            )
        }
    )
}
