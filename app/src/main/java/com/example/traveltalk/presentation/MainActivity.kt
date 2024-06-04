package com.example.traveltalk.presentation

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.traveltalk.theme.TravelTalkAppTheme
import com.example.traveltalk.theme.White_FFFFFF

val LocalDeviceSizeComposition = staticCompositionLocalOf {
    DeviceSize.MEDIUM
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val deviceWidth = applicationContext?.resources?.displayMetrics?.widthPixels ?: 0
            TravelTalkAppTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = White_FFFFFF
                ) {
                    CompositionLocalProvider(
                        LocalDeviceSizeComposition provides DeviceSize.of(deviceWidth)
                    ) { Greeting("Android") }

                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    TravelTalkAppTheme {
        Greeting("Android")
    }
}

enum class DeviceSize(val minWidthSize: Int) {
    BIG(1840), // Pixel Fold 기준
    MEDIUM(1080), // Android Studio Medium Phone 기준
    SMALL(720); // Android Studio Small Phone 기준

    companion object {
        fun of(deviceWidth: Int): DeviceSize = when {
            BIG.minWidthSize <= deviceWidth -> BIG
            MEDIUM.minWidthSize <= deviceWidth -> MEDIUM
            else -> SMALL
        }
    }
}