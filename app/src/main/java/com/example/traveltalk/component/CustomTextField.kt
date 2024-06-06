package com.example.traveltalk.component

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.traveltalk.theme.Gray_100_F4F5F9
import com.example.traveltalk.theme.Gray_400_C0C1C3
import com.example.traveltalk.theme.TravelTalkAppTheme
import com.example.traveltalk.theme.medium14


@Composable
fun CustomTextField(
    value: String,
    onValueChanged: (String) -> Unit,
    modifier: Modifier = Modifier,
    hint: String = "",
    singleLine: Boolean = true,
    maxLines: Int = if (singleLine) 1 else Int.MAX_VALUE,
    keyboardType: KeyboardType = KeyboardType.Text,
) {
    BasicTextField(
        modifier = modifier,
        value = value,
        onValueChange = onValueChanged,
        singleLine = singleLine,
        maxLines = maxLines,
        keyboardOptions = KeyboardOptions(keyboardType = keyboardType),
        visualTransformation = if (keyboardType == KeyboardType.Password) PasswordVisualTransformation() else VisualTransformation.None
    ) { innerTextField ->
        Column(
        ) {
            Box(
                modifier = Modifier
                    .background(Gray_100_F4F5F9)
                    .padding(vertical = 10.dp)
                    .padding(horizontal = 20.dp)
                    .defaultMinSize(minWidth = 290.dp)
            ) {
                innerTextField()

                if (value.isEmpty()) {
                    Text(
                        text = hint,
                        style = medium14(),
                        color = Gray_400_C0C1C3,
                    )
                }
            }
        }
    }
}


@Preview(showBackground = true)
@Composable
fun CustomTextFieldPreview() {
    TravelTalkAppTheme {
        Column {
            CustomTextField(value = "value", onValueChanged = {}, hint = "입력해주세용")
        }
    }
}
