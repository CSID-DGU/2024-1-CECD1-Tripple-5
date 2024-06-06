package com.example.traveltalk.presentation.history.navigation

import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavOptions
import androidx.navigation.compose.composable
import com.example.traveltalk.presentation.history.HistoryRoute

fun NavController.navigateHistory(navOptions: NavOptions) {
    navigate(HistoryRoute.ROUTE, navOptions)
}

fun NavGraphBuilder.historyNavGraph(
    modifier: Modifier
) {
    composable(route = HistoryRoute.ROUTE) {
        HistoryRoute(modifier = modifier)
    }
}

object HistoryRoute {
    const val ROUTE = "history"
}
