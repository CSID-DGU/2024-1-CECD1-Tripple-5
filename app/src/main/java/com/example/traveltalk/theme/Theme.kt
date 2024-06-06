package com.example.traveltalk.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable
import androidx.compose.runtime.staticCompositionLocalOf

@Composable
fun TravelTalkAppTheme(
    typography: TTTypography = TravelTalkAppTheme.typography,
    content: @Composable () -> Unit
) {
    CompositionLocalProvider(
        LocalTypography provides typography
    ) {
        MaterialTheme(content = content)
    }
}

val LocalTypography = staticCompositionLocalOf { TTTypography() }

object TravelTalkAppTheme {
    val typography: TTTypography
    @Composable
    @ReadOnlyComposable
    get() = LocalTypography.current
}