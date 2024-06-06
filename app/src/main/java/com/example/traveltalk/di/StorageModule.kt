package com.example.traveltalk.di

import android.content.Context
import com.example.traveltalk.data.datasource.local.TravelTalkStorageImpl
import com.example.traveltalk.domain.entity.TravelTalkStorage
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object StorageModule {
    @Provides
    @Singleton
    fun provideMotivooStorage(@ApplicationContext context: Context): TravelTalkStorage =
        TravelTalkStorageImpl(context)
}
