package com.example.traveltalk.presentation.chat

import android.annotation.SuppressLint
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.CornerSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerState
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.traveltalk.R
import com.example.traveltalk.component.CustomAlertDialog
import com.example.traveltalk.component.CustomTextField
import com.example.traveltalk.theme.Blue_85BDFF
import com.example.traveltalk.theme.Gray_100_F4F5F9
import com.example.traveltalk.theme.Gray_200_ECEDF1
import com.example.traveltalk.theme.Gray_400_C0C1C3
import com.example.traveltalk.theme.Gray_600_707276
import com.example.traveltalk.theme.Gray_700_464747
import com.example.traveltalk.theme.Gray_800_303031
import com.example.traveltalk.theme.White_FFFFFF
import com.example.traveltalk.theme.Yello_FFF0A1
import com.example.traveltalk.theme.medium14
import com.example.traveltalk.theme.medium16
import com.example.traveltalk.theme.semiBold16
import com.example.traveltalk.util.ext.addFocusCleaner
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch


@Composable
fun ChatRoute(
    modifier: Modifier,
) {
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val scope = rememberCoroutineScope()
    ChatScreenWithDrawer(
        messages = listOf(
            "안녕하세요!",
            "오늘 날씨가 좋네요.",
            "fadsfa",
            "fadfadf",
            "afdafafffaf",
            "안녕하세요!",
            "안녕하세요!",
            "안녕하세요!",
            "안녕하세요!",
            "안녕하세요!",
        ),
        drawerState = drawerState, scope = scope,
        recommendations = listOf(
            "이름: 충무호텔\n" +
                    "위치: 충무로 222번지\n" +
                    "평점: 4.5/5 \n" +
                    "link: https://www.shillahotels.com\n" +
                    "상세 설명: \n" +
                    "주요 시설: 무료 주차, 객실 내 욕실, 에어컨\n" +
                    "특징: 좋은 분위기의 객실을 제공합니다. \u2028주변에 음식점과 편의시설이 많아 편리합니다. \u2028충무로 관광을 즐기기에 좋은 위치에 있습니다. ",
            "이름: 충무호텔\n" +
                    "위치: 충무로 222번지\n" +
                    "평점: 4.5/5 \n" +
                    "link: https://www.shillahotels.com\n" +
                    "상세 설명: \n" +
                    "주요 시설: 무료 주차, 객실 내 욕실, 에어컨\n" +
                    "특징: 좋은 분위기의 객실을 제공합니다. \u2028주변에 음식점과 편의시설이 많아 편리합니다. \u2028충무로 관광을 즐기기에 좋은 위치에 있습니다. "

        ),
    )
}


@Composable
fun ChatScreenWithDrawer(
    messages: List<String>,
    recommendations: List<String>,
    drawerState: DrawerState,
    scope: CoroutineScope
) {
    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            DrawerContent()
        },
        content = {
            ChatScreen(messages, recommendations, drawerState, scope)
        }
    )
}

@Preview
@Composable
fun DrawerContent() {
    Column(
        modifier = Modifier
            .fillMaxWidth(0.8f)
            .fillMaxHeight()
            .background(White_FFFFFF)
            .padding(horizontal = 20.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 50.dp)
                .background(
                    Yello_FFF0A1,
                    shape = RoundedCornerShape(30.dp)
                )
                .clickable {
                    //새로운 채팅 시작
                },
            horizontalArrangement = Arrangement.Start,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                painter = painterResource(id = R.drawable.ic_chat_plus),
                contentDescription = "",
                modifier = Modifier.padding(start = 20.dp)
            )
            Text(
                "새로운 채팅 시작하기",
                style = medium14(),
                color = Gray_800_303031,
                modifier = Modifier
                    .padding(start = 12.dp)
                    .padding(vertical = 24.dp)
            )
        }
        Spacer(modifier = Modifier.height(30.dp))
        Text(
            "대화 내역",
            style = medium16(),
            color = Gray_600_707276
        )
        Spacer(modifier = Modifier.height(30.dp))

        ListWithDividers(
            messages = listOf(
                "멋있는 서울 여행지",
                "강원도 강릉 맛집 추천",
                "제주도 추천 데이트코스",
                "맛있는 부산 횟집"
            )
        )
    }
}

@Composable
fun ListWithDividers(messages: List<String>) {
    LazyColumn {
        itemsIndexed(messages) { index, message ->
            // 여기에 각 항목을 표시하는 코드
            ListItem(message = message)
            // 마지막 항목이 아니라면 구분선 추가
            if (index < messages.size - 1) {
                Divider(
                    modifier = Modifier.padding(vertical = 20.dp),
                    color = Gray_200_ECEDF1
                )
            }
        }
    }
}

@Composable
fun ListItem(message: String) {
    Row(
        modifier = Modifier
            .clickable {
                // 해당 채팅 불러오기
            },
        horizontalArrangement = Arrangement.Start,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Image(
            painter = painterResource(id = R.drawable.ic_chatlog),
            contentDescription = "",
        )
        Text(
            text = message,
            style = medium14(),
            color = Gray_700_464747,
            modifier = Modifier.padding(start = 12.dp)
        )
    }
}

@SuppressLint("UnusedMaterial3ScaffoldPaddingParameter")
@Composable
fun ChatScreen(
    messages: List<String>,
    recommendations: List<String>,
    drawerState: DrawerState,
    scope: CoroutineScope
) {
    val focusManager = LocalFocusManager.current
    val recommendationsSelectedInfo =
        remember { mutableStateListOf(*Array(recommendations.size) { false }) }
    val showDialog = remember { mutableStateOf(false) }
    val showFloatingActionButton = remember { mutableStateOf(false) }
    val dialogShown = remember { mutableStateOf(false) }

    // 선택 상태 변경 함수
    fun updateRecommendationSelection(index: Int, isSelected: Boolean) {
        recommendationsSelectedInfo[index] = isSelected
        val selectedCount = recommendationsSelectedInfo.count { it }
        when {
            selectedCount == 1 -> {
                showFloatingActionButton.value = false
                if (!dialogShown.value) {
                    showDialog.value = true
                    dialogShown.value = true
                }
            }

            selectedCount > 1 -> {
                showDialog.value = false
                showFloatingActionButton.value = true
            }

            else -> {
                showDialog.value = false
                showFloatingActionButton.value = false
            }
        }
    }
    Scaffold(
        modifier = Modifier.addFocusCleaner(focusManager),
        topBar = {
            ChatAppBar(drawerState, scope)
        },
        bottomBar = {
            ChatInputBar(onMessageSent = { message ->
                // 메시지 보내기 로직
            })
        },
        floatingActionButton = {
            if (showFloatingActionButton.value) {
                FloatingActionButton(
                    onClick = { /* 액션 구현 */ },
                    shape = RoundedCornerShape(30.dp),
                    containerColor = White_FFFFFF,
                ) {
                    Row(
                        horizontalArrangement = Arrangement.Center,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Image(
                            modifier = Modifier.padding(start = 15.dp),
                            painter = painterResource(id = R.drawable.ic_plus),
                            contentDescription = ""
                        )
                        Text(
                            text = "여행 일정 만들기",
                            style = semiBold16(),
                            modifier = Modifier
                                .padding(start = 8.dp, end = 15.dp),
                            color = Blue_85BDFF
                        )
                    }
                }
            }
        }
    ) {
        MessageList(
            messages = messages,
            recommendations = recommendations,
            recommendationsSelectedInfo = recommendationsSelectedInfo,
            onSelectionChange = ::updateRecommendationSelection
        )
    }

    if (showDialog.value) {
        CustomAlertDialog(showDialog)
    }
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatAppBar(drawerState: DrawerState, scope: CoroutineScope) {
    TopAppBar(
        title = { },
        navigationIcon = {
            IconButton(onClick = {
                scope.launch {
                    if (drawerState.isClosed) {
                        drawerState.open() // 드로어 상태를 열기로 변경
                    }
                }
            }) {
                Image(
                    painter = painterResource(id = R.drawable._ic_menu),
                    contentDescription = "메뉴 열기"
                )
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = Gray_100_F4F5F9  // 배경색 설정
        )
    )
}


@Composable
fun MessageList(
    messages: List<String>,
    recommendations: List<String>,
    recommendationsSelectedInfo: MutableList<Boolean>,
    onSelectionChange: (Int, Boolean) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(Gray_100_F4F5F9)
            .padding(top = 64.dp, bottom = 148.dp)
    ) {
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    painter = painterResource(id = R.drawable.img_chat),
                    contentDescription = "",
                    modifier = Modifier.padding(start = 20.dp, top = 10.dp)
                )
                Text(
                    text = "AI 챗봇",
                    modifier = Modifier.padding(start = 10.dp),
                    style = medium16(),
                    color = Gray_600_707276
                )
            }
        }
        items(messages) { message ->
            ChatAiBubble(message)
            ChatUserBubble(message)
        }
        itemsIndexed(recommendations) { index, recommendation ->
            ChatAiRecommendationBubble(
                message = recommendation,
                isSelected = recommendationsSelectedInfo[index],
                onSelectionChange = { selected ->
                    onSelectionChange(index, selected)
                }
            )
        }
    }
}

@Composable
fun ChatAiBubble(message: String) {
    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.CenterStart
    ) {
        Column(
            modifier = Modifier
                .padding(top = 10.dp, start = 20.dp, end = 28.dp, bottom = 7.dp)
                .background(
                    color = Yello_FFF0A1,
                    shape = RoundedCornerShape(
                        topStart = CornerSize(30.dp),
                        topEnd = CornerSize(30.dp),
                        bottomEnd = CornerSize(30.dp),
                        bottomStart = CornerSize(0.dp)
                    )
                ),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = message,
                style = medium14(),
                modifier = Modifier.padding(20.dp),
                color = Gray_800_303031
            )
        }
    }
}

@Composable
fun ChatAiRecommendationBubble(
    message: String,
    isSelected: Boolean,
    onSelectionChange: (Boolean) -> Unit
) {
    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.CenterStart
    ) {
        Column(
            modifier = Modifier
                .padding(top = 10.dp, start = 20.dp, end = 28.dp, bottom = 7.dp)
                .background(
                    color = Yello_FFF0A1,
                    shape = RoundedCornerShape(
                        topStart = CornerSize(30.dp),
                        topEnd = CornerSize(30.dp),
                        bottomEnd = CornerSize(30.dp),
                        bottomStart = CornerSize(0.dp)
                    )
                ),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                text = message,
                style = medium14(),
                modifier = Modifier.padding(20.dp),
                color = Gray_800_303031
            )
            Image(
                painter = painterResource(id = R.drawable.img_sample),
                contentDescription = "",
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(20.dp)
                    .clip(RoundedCornerShape(30.dp)),
                contentScale = ContentScale.Crop
            )
            Box {
                Row(
                    modifier = Modifier
                        .clickable { onSelectionChange(!isSelected) }
                        .padding(start = 20.dp, bottom = 20.dp),
                    horizontalArrangement = Arrangement.Center
                ) {
                    Image(
                        painter = painterResource(id = if (!isSelected) R.drawable.ic_check_default else R.drawable.ic_check_active),
                        contentDescription = ""
                    )
                    Text(
                        text = "여행 일정 추가",
                        style = medium14(),
                        modifier = Modifier.padding(start = 5.dp),
                        color = if (!isSelected) Gray_400_C0C1C3 else Blue_85BDFF
                    )
                }
            }
        }
    }
}

@Composable
fun ChatUserBubble(message: String) {
    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.CenterEnd
    ) {
        Column(
            modifier = Modifier
                .padding(top = 10.dp, start = 28.dp, end = 20.dp, bottom = 7.dp)
                .background(
                    color = White_FFFFFF,
                    shape = RoundedCornerShape(
                        topStart = CornerSize(30.dp),
                        topEnd = CornerSize(30.dp),
                        bottomEnd = CornerSize(0.dp),
                        bottomStart = CornerSize(30.dp)
                    )
                ),
            horizontalAlignment = Alignment.End
        ) {
            Text(
                text = message,
                style = medium14(),
                modifier = Modifier.padding(20.dp),
                color = Gray_700_464747
            )
        }
    }
}


@Composable
fun ChatInputBar(onMessageSent: (String) -> Unit) {
    var text by remember { mutableStateOf("") }
    Surface(
        modifier = Modifier
            .padding(bottom = 70.dp)
            .fillMaxWidth()
            .imePadding(),
        shadowElevation = 30.dp,
        color = Color.White
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 10.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            CustomTextField(
                modifier = Modifier
                    .weight(1f)
                    .clip(RoundedCornerShape(50.dp)),
                value = text,
                onValueChanged = { text = it },
                hint = "질문을 입력해주세요"
            )
            Spacer(modifier = Modifier.width(9.dp))
            IconButton(
                onClick = {
                    if (text.isNotBlank()) {
                        onMessageSent(text)
                        text = ""
                    }
                }
            ) {
                Image(
                    painter = painterResource(id = if (text.isNotBlank()) R.drawable.ic_send_active else R.drawable.ic_send_default),
                    contentDescription = "Send",
                )
            }
        }
    }
}