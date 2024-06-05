package com.example.traveltalk.util.ext

import androidx.navigation.NavController

fun NavController.navigateClear(route: String) = navigate(route) {
    popUpTo(graph.id) {
        inclusive = true
    }
}
