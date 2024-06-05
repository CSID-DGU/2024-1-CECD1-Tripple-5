package com.example.traveltalk.util.ext

import android.content.Context
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.composed
import androidx.compose.ui.focus.FocusManager
import androidx.compose.ui.input.pointer.pointerInput
import androidx.core.net.toUri
import java.io.File
import java.io.FileOutputStream

inline fun Modifier.noRippleClickable(
    crossinline onClick: () -> Unit = {},
): Modifier = composed {
    this.clickable(
        indication = null,
        interactionSource = remember { MutableInteractionSource() }
    ) {
        onClick()
    }
}

fun Modifier.addFocusCleaner(focusManager: FocusManager, doOnClear: () -> Unit = {}): Modifier {
    return this.pointerInput(Unit) {
        detectTapGestures(onTap = {
            doOnClear()
            focusManager.clearFocus()
        })
    }
}

fun saveImageFromUri(context: Context, uri: String, fileName: String): String {
    val inputStream = context.contentResolver.openInputStream(uri.toUri())
    val file = File(context.filesDir, fileName)
    FileOutputStream(file).use { fileOutput ->
        inputStream?.copyTo(fileOutput)
    }
    inputStream?.close()
    return file.absolutePath
}
