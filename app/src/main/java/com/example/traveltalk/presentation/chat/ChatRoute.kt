package com.example.traveltalk.presentation.chat

import androidx.compose.foundation.layout.Box
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier

@Composable
fun ChatRoute(
    modifier: Modifier,
) {

    ChatScreen(
        modifier = modifier
    )
}

@Composable
fun ChatScreen(
    modifier: Modifier = Modifier,
) {
    Box() {
        Text(text = "Chat")
    }
}
