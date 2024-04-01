import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/enums/image_processing_status.dart';
import 'package:stacked/stacked.dart';

import '../../../config/color_config.dart';
import '../../../const/msg_status_const.dart';
import '../../../const/msg_type_const.dart';
import '../../../data/local/app_database.dart';
import '../../../utils/date_time_util.dart';
import '../../widgets/custom_bubble.dart';
import '../../widgets/image_bubble.dart';
import '../chat_view_model.dart';

class MsgDisplayWidget extends ViewModelWidget<ChatViewModel> {
  final ScrollController _msgScrollController;

  const MsgDisplayWidget(this._msgScrollController, {super.key})
      : super(reactive: false);

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

                  DateTimeUtil dateTimeUtil = DateTimeUtil();
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
                      dateTimeUtil.forMateTime(singleMsgData.createdAt),
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
                      imageProcessingStatus = ImageProcessingStatus.processCompleted.name;
                    } else if (singleMsgData.localFileUrl != null &&
                        singleMsgData.networkFileUrl == null) {
                      imageProcessingStatus = ImageProcessingStatus.toUpload.name;
                      //user selected photo but not uploaded

                    } else if (singleMsgData.localFileUrl == null &&
                        singleMsgData.networkFileUrl != null) {
                      //user received photo but not downloaded
                      imageProcessingStatus = ImageProcessingStatus.toDownload.name;
                    } else {
                      return Container();
                    }

                    if (singleMsgData.msgStatus == MsgStatus.pending) {
                      imageProcessingStatus = ImageProcessingStatus.toUpload.name;
                    }

                    if (imageProcessingStatus == ImageProcessingStatus.processCompleted.name) {
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
                        sendTime: dateTimeUtil.forMateTime(singleMsgData.createdAt),
                        widthOfImage: widthOfImage,
                        heightOfImage: heightOfImage,
                        isLoading: singleMsgData.networkFileUrl == null ? true : false,
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
                      if (viewModel.selectedImageMsgId == singleMsgData.mongoId) {
                        isImageJustSelected = true;
                      }

                      StreamController<String> streamController = StreamController<String>();
                      return StreamBuilder(
                        stream: streamController.stream,
                        initialData: imageProcessingStatus,
                        builder: (context, AsyncSnapshot<String> snapshot) {
                          String snapshotData = snapshot.data ?? imageProcessingStatus;
                          return ImageBubble(
                            senderName: "",
                            isSender: viewModel.currentUserId == singleMsgData.senderId,
                            imageFileUrl: singleMsgData.localFileUrl,
                            imageNetworkUrl: singleMsgData.networkFileUrl,
                            imageNetworkBlurHash: singleMsgData.blurHashImageUrl,
                            sent: messageStatus == MsgStatus.sent,
                            delivered: messageStatus == MsgStatus.delivered,
                            seen: messageStatus == MsgStatus.seen,
                            sendTime: dateTimeUtil.forMateTime(singleMsgData.createdAt),
                            widthOfImage: widthOfImage,
                            heightOfImage: heightOfImage,
                            isLoading: isImageJustSelected
                                ? true
                                : snapshotData == ImageProcessingStatus.processCompleted.name
                                ? false
                                : snapshotData == ImageProcessingStatus.processRunning.name
                                ? true
                                : false,
                            clickListener: (String status) async {
                              streamController.add(ImageProcessingStatus.processRunning.name);
                              if (status == ImageProcessingStatus.uploading.name) {
                                MessagesTableData? msgTableData =
                                await viewModel.getMessageObjectFromId(singleMsgData.mongoId);

                                if (msgTableData != null) {
                                  bool uploadImageResult =
                                  await viewModel.sendMessage(
                                      inputText: MsgType.image,
                                      localFileUrl: singleMsgData.localFileUrl,
                                      imageInfo: singleMsgData.imageInfo,
                                      msgType: MsgType.image,
                                      msgTableData: msgTableData);

                                  if (uploadImageResult) {
                                    streamController.add(ImageProcessingStatus.processCompleted.name);
                                  }
                                }
                              } else if (status == ImageProcessingStatus.downloading.name) {
                                bool downloadImageResult =
                                await viewModel.downloadImage(
                                    singleMsgData.mongoId,
                                    singleMsgData.networkFileUrl!);
                                if (downloadImageResult) {
                                  streamController.add(ImageProcessingStatus.processCompleted.name);
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
