import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/ui/chat_screen/widgets/appbar_widget.dart';
import 'package:mind_wellness_chat/ui/chat_screen/widgets/message_send_container_widget.dart';
import 'package:mind_wellness_chat/ui/chat_screen/widgets/msg_display_widget.dart';
import 'package:stacked/stacked.dart';

import '../../config/color_config.dart';
import '../../models/user/user_basic_data_model.dart';
import '../widgets/custom_circular_image.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  final UserDataBasicModel _userDataBasicModel;
  final ScrollController _msgScrollController = ScrollController();

  ChatView(this._userDataBasicModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.nonReactive(
      onViewModelReady: (ChatViewModel viewModel) async {
        await viewModel.setUserData(_userDataBasicModel);
        viewModel.listenForConnectionStatus();
        viewModel.listenForTypingStatus();
        _msgScrollController.addListener(() async {
          if (viewModel.isAllItemLoaded == false) {
            if (viewModel.isItemsLoading == false) {
              if (_msgScrollController.position.extentAfter < 700) {
                if (viewModel.pageNumber * viewModel.itemPerPage ==
                    viewModel.listOfMessage.length) {
                  await viewModel.getNewItems();
                }
              }
            }
          }
        });
        viewModel.makeAllMsgReadLocally();
      },
      builder: (context, model, child) {
        return Container(
          color: ColorConfig.accentColor,
          child:  SafeArea(
            maintainBottomViewPadding: false,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                width: 100.horizontal(),
                child: Column(
                  children: [
                    Container(
                      color: ColorConfig.accentColor,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                model.goToPreviousScreen();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorConfig.primaryColor,
                                  size: 18,
                                ),
                              ),
                            ),
                            CustomCircularImage(
                              width: 48,
                              height: 48,
                              imageUri:
                              _userDataBasicModel.compressedProfileImage,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const AppbarWidget()
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: MsgDisplayWidget(_msgScrollController),
                        )
                    ),
                    const MessageSendContainer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ChatViewModel(),
    );
  }
}
