package com.example.traveltalk.presentation.main

import com.example.traveltalk.R
import com.example.traveltalk.presentation.chat.navigation.ChatRoute
import com.example.traveltalk.presentation.history.navigation.HistoryRoute
import com.example.traveltalk.presentation.home.navigation.HomeRoute
import com.example.traveltalk.presentation.profile.navigation.ProfileRoute

enum class MainTab(
    val selectedIconImageVector: Int,
    val unselectedIconImageVector: Int,
    val contentDescription: String,
    val route: String,
) {
    HOME(
        selectedIconImageVector = R.drawable.ic_home_active,
        unselectedIconImageVector = R.drawable.ic_home,
        contentDescription = "추천",
        route = HomeRoute.ROUTE,
    ),
    CHAT(
        selectedIconImageVector = R.drawable.ic_chat_active,
        unselectedIconImageVector = R.drawable.ic_chat,
        contentDescription = "채팅",
        route = ChatRoute.ROUTE,
    ),
    HISTORY(
        selectedIconImageVector = R.drawable.ic_history_active,
        unselectedIconImageVector = R.drawable.ic_history,
        contentDescription = "여행일정",
        route = HistoryRoute.ROUTE,
    ),
    PROFILE(
        selectedIconImageVector = R.drawable.ic_profile_active,
        unselectedIconImageVector = R.drawable.ic_profile,
        contentDescription = "프로필",
        route = ProfileRoute.ROUTE,
    );


    companion object {
        operator fun contains(route: String): Boolean {
            return entries.map { it.route }.contains(route)
        }

        fun find(route: String): MainTab? {
            return entries.find { it.route == route }
        }
    }
}
