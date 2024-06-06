package com.example.traveltalk.theme

import androidx.compose.runtime.Composable
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.example.traveltalk.R

val FontFamily = FontFamily(
    Font(R.font.pretendard_medium, FontWeight.Medium),
    Font(R.font.pretendard_semibold, FontWeight.SemiBold)
)


//폰트 패밀리가 폰트웨이트에 따라 알아서 선택이 된다.
data class TTTypography(
    val semiBold20: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 28.sp,
        fontSize = 20.sp
    ),
    val semiBold18: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 28.sp,
        fontSize = 18.sp
    ),
    val semiBold16: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 28.sp,
        fontSize = 16.sp
    ),
    val semiBold14: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 28.sp,
        fontSize = 14.sp
    ),
    val semiBold12: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.SemiBold,
        lineHeight = 28.sp,
        fontSize = 12.sp
    ),
    val medium20: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.Medium,
        lineHeight = 28.sp,
        fontSize = 20.sp
    ),
    val medium18: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.Medium,
        lineHeight = 28.sp,
        fontSize = 18.sp
    ),
    val medium16: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.Medium,
        lineHeight = 28.sp,
        fontSize = 16.sp
    ),
    val medium14: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.Medium,
        lineHeight = 28.sp,
        fontSize = 14.sp
    ),
    val medium12: TextStyle = TextStyle(
        fontFamily = com.example.traveltalk.theme.FontFamily,
        fontWeight = FontWeight.Medium,
        lineHeight = 28.sp,
        fontSize = 12.sp
    ),
)


@Composable
fun semiBold20(): TextStyle {
    return TravelTalkAppTheme.typography.semiBold20
}

@Composable
fun semiBold18(): TextStyle {
    return TravelTalkAppTheme.typography.semiBold18
}

@Composable
fun semiBold16(): TextStyle {
    return TravelTalkAppTheme.typography.semiBold16
}

@Composable
fun semiBold14(): TextStyle {
    return TravelTalkAppTheme.typography.semiBold16
}

@Composable
fun semiBold12(): TextStyle {
    return TravelTalkAppTheme.typography.semiBold12
}

@Composable
fun medium20(): TextStyle {
    return TravelTalkAppTheme.typography.medium20
}

@Composable
fun medium18(): TextStyle {
    return TravelTalkAppTheme.typography.medium18
}

@Composable
fun medium16(): TextStyle {
    return TravelTalkAppTheme.typography.medium16
}

@Composable
fun medium14(): TextStyle {
    return TravelTalkAppTheme.typography.medium14
}

@Composable
fun medium12(): TextStyle {
    return TravelTalkAppTheme.typography.medium12
}