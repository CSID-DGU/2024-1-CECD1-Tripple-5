package com.example.traveltalk.presentation.main

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideIn
import androidx.compose.animation.slideOut
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import com.example.traveltalk.presentation.chat.navigation.chatNavGraph
import com.example.traveltalk.presentation.history.navigation.historyNavGraph
import com.example.traveltalk.presentation.home.navigation.homeNavGraph
import com.example.traveltalk.presentation.profile.navigation.profileNavGraph
import com.example.traveltalk.theme.Blue_85BDFF
import com.example.traveltalk.theme.Gray_400_C0C1C3
import com.example.traveltalk.theme.White_FFFFFF
import com.example.traveltalk.theme.semiBold12
import com.example.traveltalk.util.ext.noRippleClickable
import kotlinx.collections.immutable.ImmutableList
import kotlinx.collections.immutable.toImmutableList
import kotlinx.coroutines.launch

@Composable
fun MainScreen(
    navigator: MainNavigator = rememberMainNavigator(),
) {
    val snackBarHostState = remember { SnackbarHostState() }
    val coroutineScope = rememberCoroutineScope()
    val localContextResource = LocalContext.current.resources
    val onShowErrorSnackBar: (Int) -> Unit = { errorMessage ->
        coroutineScope.launch {
            snackBarHostState.currentSnackbarData?.dismiss()
            snackBarHostState.showSnackbar(localContextResource.getString(errorMessage))
        }
    }

    Scaffold(
        content = { paddingValue ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(White_FFFFFF)
            ) {
                NavHost(
                    navController = navigator.navController,
                    startDestination = navigator.startDestination,
                ) {
                    homeNavGraph(Modifier.padding(paddingValue))
                    chatNavGraph(Modifier.padding(paddingValue))
                    historyNavGraph(Modifier.padding(paddingValue))
                    profileNavGraph(Modifier.padding(paddingValue))
                }
            }
        },
        bottomBar = {
            MainBottomBar(
                visible = navigator.shouldShowBottomBar(),
                tabs = MainTab.entries.toImmutableList(),
                currentTab = navigator.currentTab,
                onTabSelected = { navigator.navigate(it) }
            )
        },
        snackbarHost = { SnackbarHost(snackBarHostState) }
    )
}

@Composable
private fun MainBottomBar(
    visible: Boolean,
    tabs: ImmutableList<MainTab>,
    currentTab: MainTab?,
    onTabSelected: (MainTab) -> Unit,
) {
    val isChatTabSelected = currentTab?.route == "chat"
    AnimatedVisibility(
        visible = visible,
        enter = fadeIn() + slideIn { IntOffset(0, it.height) },
        exit = fadeOut() + slideOut { IntOffset(0, it.height) }
    ) {
        Surface(
            shadowElevation = if (isChatTabSelected) 0.dp else 30.dp,
            color = White_FFFFFF,
        ) {
            Row(
                modifier = Modifier
                    .navigationBarsPadding()
                    .padding(bottom = 12.dp)
                    .fillMaxWidth()
                    .height(70.dp)
                    .padding(vertical = 12.dp, horizontal = 28.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                tabs.forEach { tab ->
                    MainBottomBarItem(
                        tab = tab,
                        selected = tab == currentTab,
                        onClick = { onTabSelected(tab) },
                    )
                }
            }
        }

    }
}

@Composable
private fun RowScope.MainBottomBarItem(
    tab: MainTab,
    selected: Boolean,
    onClick: () -> Unit,
) {
    Column(
        modifier = Modifier
            .weight(1f)
            .fillMaxHeight()
            .noRippleClickable(onClick),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(id = if (selected) tab.selectedIconImageVector else tab.unselectedIconImageVector),
            contentDescription = tab.contentDescription,
            modifier = Modifier.size(24.dp),
        )
        Spacer(modifier = Modifier.height(5.dp))
        Text(
            text = tab.contentDescription,
            style = semiBold12(),
            color = if (selected) Blue_85BDFF else Gray_400_C0C1C3,
        )
    }
}
