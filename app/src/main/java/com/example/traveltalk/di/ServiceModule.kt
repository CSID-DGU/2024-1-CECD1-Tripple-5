package com.example.traveltalk.di

import com.example.traveltalk.data.service.DummyService
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object ServiceModule {
    private inline fun <reified T> Retrofit.create(): T = this.create(T::class.java)

    @Binds
    @Singleton
    fun provideDummyService(retrofit: Retrofit): DummyService = retrofit.create()

}
