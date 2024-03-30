import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/services.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/recent_chat/recent_chat_view_model.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/recent_chat/widgets/empty_chat_screen.dart';
import 'package:stacked/stacked.dart';

import '../../../../config/color_config.dart';
import '../../../../const/app_const.dart';
import '../../../../data/local/app_database.dart';
import '../../../../models/user/user_basic_data_model.dart';
import '../../../../utils/date_time_util.dart';
import '../../../widgets/single_chat_widget.dart';

class RecentChatView extends StatelessWidget {
  final Function gotoSearchCallback;

  const RecentChatView(this.gotoSearchCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecentChatViewModel>.nonReactive(
      onViewModelReady: (RecentChatViewModel viewModel) async {
        await viewModel.getUserId();
      },
      viewModelBuilder: () => RecentChatViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: ColorConfig.accentColor,
              centerTitle: false,
              title: Text(
                AppConst.appName,
                style: TextStyle(
                    color: ColorConfig.primaryColor,
                    fontSize: 16,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600
                ),
              ),
          ),
          body: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AllRecentChatDisplayWidget(() {
                gotoSearchCallback();
              })),
        );
      },
    );
  }
}

class AllRecentChatDisplayWidget extends ViewModelWidget<RecentChatViewModel> {
  final Function gotoSearchCallback;

  const AllRecentChatDisplayWidget(this.gotoSearchCallback, {super.key});

  @override
  Widget build(BuildContext context, RecentChatViewModel viewModel) {
    return StreamBuilder(
      stream: viewModel.getRecentChats(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if(snapshot.data!.length == 0){
              return EmptyChatScreen(
                buttonPressedCallBack: () {
                  gotoSearchCallback();
                },
              );
            }

            return ListView.separated(
              key: const PageStorageKey('listview-recent-chat-maintain-state-key'),
              itemCount: snapshot.data!.length,
              // controller: _msgScrollController,
              itemBuilder: (BuildContext context, int index) {
                RecentChatTableData recentChatTableData = snapshot.data![index];

                String name = "";
                String? compressedProfileImage;
                String lastMsg = recentChatTableData.last_msg_text ?? "";
                name = recentChatTableData.user_name;
                compressedProfileImage = recentChatTableData.user_compressed_image;
                List<String> participants = List.from(recentChatTableData.participants);
                participants.removeWhere((element) => element == viewModel.userId);

                return SingleChatWidget(
                  chatClickCallback: () {
                    UserDataBasicModel userDataBasicModel = UserDataBasicModel(
                        name: name,
                        id: participants[0],
                        statusLine: "",
                        compressedProfileImage: compressedProfileImage);
                    viewModel.gotoChatScreen(userDataBasicModel);
                  },
                  name: name,
                  description: lastMsg,
                  compressedProfileImage: compressedProfileImage,
                  time: DateTimeUtil().getTimeAgo(recentChatTableData.last_msg_time),
                  unreadMessage: recentChatTableData.unread_msg,
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 0,
                color: ColorConfig.greyColor5,
              ),
            );
          } else {
            return EmptyChatScreen(
              buttonPressedCallBack: () {
                gotoSearchCallback();
              },
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}