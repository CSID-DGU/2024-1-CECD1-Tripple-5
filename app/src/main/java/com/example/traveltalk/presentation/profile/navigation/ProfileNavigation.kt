package com.example.traveltalk.presentation.profile.navigation

import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavOptions
import androidx.navigation.compose.composable
import com.example.traveltalk.presentation.profile.ProfileRoute

fun NavController.navigateProfile(navOptions: NavOptions) {
    navigate(ProfileRoute.ROUTE, navOptions)
}

fun NavGraphBuilder.profileNavGraph(
    modifier: Modifier
) {
    composable(route = ProfileRoute.ROUTE) {
        ProfileRoute(modifier = modifier)
    }
}

object ProfileRoute {
    const val ROUTE = "profile"
}
