import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../config/color_config.dart';
import '../../const/msg_status_const.dart';
import '../../const/msg_type_const.dart';
import '../../data/local/app_database.dart';
import '../../models/user/user_basic_data_model.dart';
import '../../utils/date_time_util.dart';
import '../widgets/custom_bubble.dart';
import '../widgets/custom_circular_image.dart';
import '../widgets/image_bubble.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  UserDataBasicModel _userDataBasicModel;
  final ScrollController _msgScrollController = ScrollController();

  ChatView(this._userDataBasicModel, {Key? key}) : super(key: key);

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
        return SafeArea(
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
              // color: const Color(0x60D9D9D9),
              child: Column(
                children: [
                  Container(
                    color: Color(0xffF2F3F7),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              model.goToPreviousScreen();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color(0xff95979D),
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
                  MessageSendContainer(),
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => ChatViewModel(),
    );
  }
}

class AppbarWidget extends ViewModelWidget<ChatViewModel> {
  const AppbarWidget({Key? key}) : super(key: key, reactive: false);

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(
            viewModel.userDataBasicModel.name,
            style: const TextStyle(
                fontSize: 15, letterSpacing: 0.4, fontWeight: FontWeight.w700),
          ),
        ),
        StreamBuilder<String>(
          stream: viewModel.listenForUserActivityStatus(),
          initialData: "",
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return snapshot.data != ""
                ? Text(
                    snapshot.data.toString(),
                    style: const TextStyle(
                        fontSize: 13,
                        letterSpacing: 1,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                  )
                : Container(height: 0);
          },
        ),
      ],
    );
  }
}

class MsgDisplayWidget extends ViewModelWidget<ChatViewModel> {
  ScrollController _msgScrollController;

  MsgDisplayWidget(this._msgScrollController, {Key? key})
      : super(key: key, reactive: false);

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    return StreamBuilder(
        stream: viewModel.getMessagesStream(),
        builder: (BuildContext context,
            AsyncSnapshot<List<MessagesTableData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                key: const PageStorageKey('listview-chat-maintain-state-key'),
                reverse: true,
                itemCount: snapshot.data!.length,
                controller: _msgScrollController,
                itemBuilder: (BuildContext context, int index) {
                  MessagesTableData singleMsgData = snapshot.data![index];

                  bool isSender = false;
                  if (singleMsgData.senderId == viewModel.currentUserId) {
                    isSender = true;
                  } else {
                    isSender = false;
                  }

                  int messageStatus = singleMsgData.msgStatus;

                  if (!isSender) {
                    //I AM Not sender it means i cant see msgStatus
                    messageStatus = 10;
                  }

                  DateTimeUtil _dateTimeUtil = DateTimeUtil();
                  viewModel.makeAllMsgReadLocally();

                  if (singleMsgData.msgContentType == MsgType.txt) {
                    return CustomBubble(
                      senderName: "",
                      text: singleMsgData.msgContent,
                      isSender:
                          viewModel.currentUserId == singleMsgData.senderId,
                      color: isSender
                          ? ColorConfig.accentColor
                          : const Color(0xFFE8E8EE),
                      textStyle: TextStyle(
                        fontSize: 13.5,
                        fontFamily: "FiraSans",
                        fontWeight: FontWeight.w400,
                        color: isSender ? Colors.white : Colors.black54,
                        letterSpacing: 0.4,
                      ),
                      tail: true,
                      sent: messageStatus == MsgStatus.sent,
                      delivered: messageStatus == MsgStatus.delivered,
                      seen: messageStatus == MsgStatus.seen,
                      sendTime:
                          _dateTimeUtil.forMateTime(singleMsgData.createdAt),
                      updateSeen: () async {
                        if ((!isSender && singleMsgData.seenAt == null) ||
                            (!isSender && singleMsgData.msgStatus == 3)) {
                          await viewModel.updateSeenForParticularMessage(
                              singleMsgData.mongoId, singleMsgData.senderId);
                        }
                      },
                    );
                  } else {
                    Map<String, dynamic>? imageInfo = singleMsgData.imageInfo;
                    int widthOfImage = imageInfo != null
                        ? int.parse(imageInfo["width"].toString())
                        : 80.horizontal().round();
                    int heightOfImage = imageInfo != null
                        ? int.parse(imageInfo["height"].toString())
                        : 45.vertical().round();

                    String imageProcessingStatus = '';

                    if (singleMsgData.localFileUrl != null &&
                        singleMsgData.networkFileUrl != null) {
                      imageProcessingStatus = 'processCompleted';
                    } else if (singleMsgData.localFileUrl != null &&
                        singleMsgData.networkFileUrl == null) {
                      imageProcessingStatus = 'toUpload';
                      //user selected photo but not uploaded

                    } else if (singleMsgData.localFileUrl == null &&
                        singleMsgData.networkFileUrl != null) {
                      //user received photo but not downloaded
                      imageProcessingStatus = 'toDownload';
                    } else {
                      return Container();
                    }

                    if (singleMsgData.msgStatus == MsgStatus.pending) {
                      imageProcessingStatus = 'toUpload';
                    }

                    if (imageProcessingStatus == 'processCompleted') {
                      //I am sender or receiver and image is uploaded to firebase as well as local storage
                      return ImageBubble(
                        senderName: "",
                        isSender:
                            viewModel.currentUserId == singleMsgData.senderId,
                        imageFileUrl: singleMsgData.localFileUrl,
                        imageNetworkUrl: singleMsgData.networkFileUrl,
                        imageNetworkBlurHash: singleMsgData.blurHashImageUrl,
                        sent: messageStatus == MsgStatus.sent,
                        delivered: messageStatus == MsgStatus.delivered,
                        seen: messageStatus == MsgStatus.seen,
                        sendTime:
                            _dateTimeUtil.forMateTime(singleMsgData.createdAt),
                        widthOfImage: widthOfImage,
                        heightOfImage: heightOfImage,
                        isLoading:
                            singleMsgData.networkFileUrl == null ? true : false,
                        updateSeen: () async {
                          if ((!isSender && singleMsgData.seenAt == null) ||
                              (!isSender && singleMsgData.msgStatus == 3)) {
                            await viewModel.updateSeenForParticularMessage(
                                singleMsgData.mongoId, singleMsgData.senderId);
                          }
                        },
                        imageProcessingStatus: imageProcessingStatus,
                      );
                    } else {
                      bool isImageJustSelected = false;
                      if (viewModel.selectedImageMsgId ==
                          singleMsgData.mongoId) {
                        isImageJustSelected = true;
                      }

                      StreamController<String> _streamController = StreamController<String>();
                      return StreamBuilder(
                        stream: _streamController.stream,
                        initialData: imageProcessingStatus,
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          String snapshotData = snapshot.data ?? imageProcessingStatus;
                          return ImageBubble(
                            senderName: "",
                            isSender: viewModel.currentUserId ==
                                singleMsgData.senderId,
                            imageFileUrl: singleMsgData.localFileUrl,
                            imageNetworkUrl: singleMsgData.networkFileUrl,
                            imageNetworkBlurHash:
                                singleMsgData.blurHashImageUrl,
                            sent: messageStatus == MsgStatus.sent,
                            delivered: messageStatus == MsgStatus.delivered,
                            seen: messageStatus == MsgStatus.seen,
                            sendTime: _dateTimeUtil
                                .forMateTime(singleMsgData.createdAt),
                            widthOfImage: widthOfImage,
                            heightOfImage: heightOfImage,
                            isLoading: isImageJustSelected
                                ? true
                                : snapshotData == "processCompleted"
                                    ? false
                                    : snapshotData == "processRunning"
                                        ? true
                                        : false,
                            clickListener: (String status) async {
                              _streamController.add("processRunning");

                              if (status == 'uploading') {
                                MessagesTableData? _msgTableData =
                                    await viewModel.getMessageObjectFromId(
                                        singleMsgData.mongoId);

                                if (_msgTableData != null) {
                                  bool uploadImageResult =
                                      await viewModel.sendMessage(
                                          inputText: 'image',
                                          localFileUrl:
                                              singleMsgData.localFileUrl,
                                          imageInfo: singleMsgData.imageInfo,
                                          msgType: MsgType.image,
                                          msgTableData: _msgTableData);

                                  if (uploadImageResult) {
                                    _streamController.add("processCompleted");
                                  }
                                }
                              } else if (status == "downloading") {
                                bool downloadImageResult =
                                    await viewModel.downloadImage(
                                        singleMsgData.mongoId,
                                        singleMsgData.networkFileUrl!);
                                if (downloadImageResult) {
                                  _streamController.add("processCompleted");
                                }
                              }
                            },
                            updateSeen: () async {
                              if ((!isSender && singleMsgData.seenAt == null) ||
                                  (!isSender && singleMsgData.msgStatus == 3)) {
                                await viewModel.updateSeenForParticularMessage(
                                    singleMsgData.mongoId,
                                    singleMsgData.senderId);
                              }
                            },
                            imageProcessingStatus: imageProcessingStatus,
                          );
                        },
                      );
                    }
                  }
                },
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
}

class MessageSendContainer extends HookViewModelWidget<ChatViewModel> {
  const MessageSendContainer({super.key}) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ChatViewModel viewModel) {
    TextEditingController _msgSendTextController = useTextEditingController();
    _msgSendTextController.addListener(() {
      String inputText = _msgSendTextController.text;
      if (inputText.isNotEmpty) {
        viewModel.setSendBtnStatus(false);
      } else {
        viewModel.setSendBtnStatus(true);
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 22.0, right: 16, top: 10, bottom: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showPicker(context, (bool isCameraSelected) {
                  viewModel.imageSelected(isCameraSelected);
                });
              },
              child: Container(
                width: 24,
                height: 24,
                child: SvgPicture.asset("assets/icons/gallery_icon.svg"),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              width: 22,
              height: 22,
              child: SvgPicture.asset("assets/icons/emogi_icon.svg"),
            ),
            Flexible(
              child: Container(
                child: TextField(
                  onChanged: (txt) {
                    viewModel.inputTextChanging();
                  },
                  controller: _msgSendTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Type Something...',
                    contentPadding:
                        EdgeInsets.only(left: 16.0, bottom: 16.0, top: 18.0),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!viewModel.isSendBtnDisable) {
                  viewModel.sendMessage(
                      inputText: _msgSendTextController.text,
                      msgType: MsgType.txt);
                  _msgSendTextController.text = "";
                }
              },
              child: SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset("assets/icons/send_icon.svg",
                    color: viewModel.isSendBtnDisable
                        ? Colors.grey.shade500
                        : ColorConfig.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPicker(context, Function callback) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    callback(false);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  callback(true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}
