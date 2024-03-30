import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/config/color_config.dart';
import 'package:mind_wellness_chat/const/app_const.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:stacked/stacked.dart';

import 'fragments/profile/profile_view.dart';
import 'fragments/recent_chat/recent_chat_view.dart';
import 'fragments/search/search_view.dart';
import 'main_screen_view_model.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});
  @override
  MainScreenViewState createState() => MainScreenViewState();
}

class MainScreenViewState extends State<MainScreenView> with TickerProviderStateMixin{
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainScreenViewModel>.reactive(
      onViewModelReady: (MainScreenViewModel viewModel){
        viewModel.initializeSocket();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
            controller: _motionTabBarController,
            children: <Widget>[
              const SearchView(),
              RecentChatView((){
                _motionTabBarController?.index = 0;
              }),
              const ProfileView()
            ]
          ),
          bottomNavigationBar: MotionTabBar(
            controller: _motionTabBarController,
            initialSelectedTab: AppConst.menuItemChat,
            useSafeArea: true,
            labels: const [AppConst.menuItemSearch, AppConst.menuItemChat, AppConst.menuItemProfile],
            icons: const [Icons.search, Icons.chat, Icons.account_circle_outlined],
            tabSize: 50,
            tabBarHeight: 55,
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            tabIconColor: ColorConfig.tabIconColor,
            tabIconSize: 28.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: ColorConfig.accentColor,
            tabIconSelectedColor: Colors.white,
            tabBarColor: Colors.white,
            onTabItemSelected: (int value) {
              setState(() {
                _motionTabBarController!.index = value;
              });
            },
          ),
        );
      },
      viewModelBuilder: () => MainScreenViewModel(),
    );
  }
}

Widget getViewForIndex(int index,Function gotoSearchScreen) {
  switch (index) {
    case 0:
      return RecentChatView((){
        gotoSearchScreen();
      });
    case 1:
      return const SearchView();
    case 2:
      return const ProfileView();
    default:
      return RecentChatView((){
        gotoSearchScreen();
      });
  }
}
