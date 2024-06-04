package com.example.traveltalk.presentation.dummy

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.traveltalk.data.model.request.RequestDummyDto
import com.example.traveltalk.domain.usecase.DummyUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class DummyViewModel @Inject constructor(
    private val dummyUseCase: DummyUseCase
) : ViewModel() {

    fun a() {
        viewModelScope.launch {
            dummyUseCase.invoke(
                RequestDummyDto(
                    "dafa",
                    "daffa"
                )
            ).onSuccess { response ->


            }.onFailure { trowable ->


            }
        }
    }
}