import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/services.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/recent_chat/recent_chat_view_model.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/recent_chat/widgets/empty_chat_screen.dart';
import 'package:stacked/stacked.dart';

import '../../../../config/color_config.dart';
import '../../../../data/local/app_database.dart';
import '../../../../models/user/user_basic_data_model.dart';
import '../../../../utils/date_time_util.dart';
import '../../../widgets/single_chat_widget.dart';

class RecentChatView extends StatelessWidget {
  Function gotoSearchCallback;

  RecentChatView(this.gotoSearchCallback, {super.key});

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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56.0),
            child: Container()
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
  Function gotoSearchCallback;

  AllRecentChatDisplayWidget(this.gotoSearchCallback);

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

            print("HEt :- " + snapshot.data!.length.toString());

            return ListView.separated(
              key: const PageStorageKey(
                  'listview-recent-chat-maintain-state-key'),
              itemCount: snapshot.data!.length,
              // controller: _msgScrollController,
              itemBuilder: (BuildContext context, int index) {
                RecentChatTableData _recentChatTableData =
                    snapshot.data![index];

                String name = "";
                String? compressedProfileImage;

                int indexOfUserId = _recentChatTableData.participants
                    .indexWhere((element) => element == viewModel.userId);

                String lastMsg = _recentChatTableData.last_msg_text ?? "";

                name = _recentChatTableData.user_name;
                compressedProfileImage =
                    _recentChatTableData.user_compressed_image;

                List<String> participants = List.from(_recentChatTableData.participants);

                print("participants 0:- " + participants.toString());

                participants.removeWhere((element) => element == viewModel.userId);

                print("participants 1 :- " + participants.toString());

                return SingleChatWidget(
                  chatClickCallback: () {
                    UserDataBasicModel _userDataBasicModel = UserDataBasicModel(
                        name: name,
                        id: participants[0],
                        statusLine: "",
                        compressedProfileImage: compressedProfileImage);
                    viewModel.gotoChatScreen(_userDataBasicModel);
                  },
                  name: name,
                  description: lastMsg,
                  compressedProfileImage: compressedProfileImage,
                  time: DateTimeUtil()
                      .getTimeAgo(_recentChatTableData.last_msg_time),
                  unreadMessage: _recentChatTableData.unread_msg,
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