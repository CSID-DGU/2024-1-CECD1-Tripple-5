package com.example.traveltalk.component

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import com.example.traveltalk.R
import com.example.traveltalk.theme.Blue_85BDFF
import com.example.traveltalk.theme.Gray_600_707276
import com.example.traveltalk.theme.White_FFFFFF
import com.example.traveltalk.theme.medium16
import com.example.traveltalk.theme.semiBold16

@Composable
fun CustomAlertDialog(showDialog: MutableState<Boolean>) {
    if (showDialog.value) {
        Dialog(onDismissRequest = { showDialog.value = false }) {
            Surface(
                shape = RoundedCornerShape(30.dp),
                color = White_FFFFFF
            ) {
                Column(
                    modifier = Modifier
                        .padding(horizontal = 20.dp)
                        .padding(top = 30.dp, bottom = 20.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Image(
                        painter = painterResource(id = R.drawable._ic_alert),
                        contentDescription = ""
                    )
                    Spacer(modifier = Modifier.height(30.dp))
                    Text(
                        modifier = Modifier.padding(horizontal = 45.dp),
                        text = "여행일정 만들기 버튼을 눌러 \n" +
                                "일정을 2개 이상 선택 시\n" +
                                "여행 일정 만들기 버튼을 눌러\n" +
                                "여행 일정을 만들 수 있습니다. \n" +
                                "\n" +
                                "만들어진 여행 일정은 \n" +
                                "여행 일정 탭에 저장됩니다. ",
                        style = medium16(),
                        color = Gray_600_707276,
                        textAlign = TextAlign.Center
                    )
                    Spacer(modifier = Modifier.height(60.dp))
                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(
                                Blue_85BDFF,
                                shape = RoundedCornerShape(50.dp)
                            )
                            .clickable { showDialog.value = false },
                        horizontalAlignment = Alignment.CenterHorizontally,
                    ) {
                        Text(
                            "확인",
                            style = semiBold16(),
                            color = White_FFFFFF,
                            modifier = Modifier.padding(vertical = 13.dp)
                        )
                    }
                }
            }
        }
    }
}

@Preview
@Composable
fun CustomAlertDialogPreview() {
    val a = remember { mutableStateOf(true) }
    CustomAlertDialog(a)
}

