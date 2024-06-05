package com.example.traveltalk.presentation.chat.navigation

import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavOptions
import androidx.navigation.compose.composable
import com.example.traveltalk.presentation.chat.ChatRoute
import com.example.traveltalk.presentation.home.HomeRoute

fun NavController.navigateChat(navOptions: NavOptions) {
    navigate(ChatRoute.ROUTE, navOptions)
}

fun NavGraphBuilder.chatNavGraph(
    modifier: Modifier
) {
    composable(route = ChatRoute.ROUTE) {
        ChatRoute(modifier = modifier)
    }
}

object ChatRoute {
    const val ROUTE = "chat"
}
