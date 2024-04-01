import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../app/locator.dart';
import '../base/custom_base_view_model.dart';
import '../config/api_config.dart';
import '../const/msg_status_const.dart';
import '../const/msg_type_const.dart';
import '../data/data_manager.dart';
import '../data/local/app_database.dart';
import '../models/basic_models/id_model.dart';
import '../models/chat_models/deliver_at_update_model.dart';
import '../models/chat_models/private_message_model.dart';
import '../models/chat_models/update_message_model.dart';
import '../models/recent_chat_model/recent_chat_local_model.dart';
import '../models/recent_chat_model/recent_chat_server_model.dart';
import '../models/user/user_basic_data_offline_model.dart';
import '../utils/model_converters.dart';

class SocketService {
  final DataManager _dataManager = locator<DataManager>();

  late String idOfUser;
  Socket? socket;
  Timer? _timer;

  disconnectFromSocket() {
    if (socket != null) {
      socket!.disconnect();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  connectToSocket(String userId) async {
    idOfUser = userId;
    if (socket != null) {
      if (kDebugMode) {
        print("NEW SOCKET DISPOSING");
      }
      socket!.dispose();
    }

    try {
      if (kDebugMode) {
        print("NEW SOCKET CREATED");
      }
      socket = io(
          ApiConfig.baseUrl,
          OptionBuilder()
              .setTransports(['websocket']) //
              .disableAutoConnect()
              .disableReconnection()
              .setQuery({"userId": userId})
              .build());

      if (socket != null) {
        socket!.connect();
        socket!.onConnecting((data) => print("socket :-Connecting"));
        socket!.onConnect((_) async {
            if (kDebugMode) {
              print("socket :-Connected");
            }
            listenForIncomingMsg();
            List<MessagesTableData> notSentMsg = await _dataManager.getNotSentMsg(userId);
            startEmittingUserStatus(userId, true);

            for (MessagesTableData msg in notSentMsg) {
              if (msg.msgContentType == MsgType.txt) {
                Participants participants = Participants(
                    user1Id: msg.senderId, user2Id: msg.receiverId);
                int currentTime = DateTime.now().millisecondsSinceEpoch;

                UserBasicDataOfflineModel? userBasicDataOfflineModel = await _dataManager.getUserBasicDataOfflineModel();

                if (userBasicDataOfflineModel != null) {
                  PrivateMessageModel privateMessageModel = PrivateMessageModel(
                    id: msg.mongoId,
                    createdAt: currentTime,
                    msgContentType: msg.msgContentType,
                    receiverId: msg.receiverId,
                    senderId: msg.senderId,
                    msgContent: msg.msgContent,
                    senderName: userBasicDataOfflineModel.name,
                    senderPlaceholderImage:
                        userBasicDataOfflineModel.compressedProfileImage,
                    msgStatus: MsgStatus.sent,
                    participants: participants,
                    networkFileUrl: msg.networkFileUrl,
                    blurHashImage: msg.blurHashImageUrl,
                    imageInfo: msg.imageInfo,
                  );
                  String? currentUserId = msg.senderId;

                  await CustomBaseViewModel().sendMessageWithDataModel(
                      inputText: msg.msgContent,
                      currentTime: currentTime,
                      privateMessageModel: privateMessageModel,
                      currentUserId: currentUserId,
                      name: msg.receiverName ?? "",
                      compressedProfileImage:
                          msg.receiverCompressedProfileImage,
                      id: msg.receiverId,
                      statusLine: '');
                }
              }
            }
          },
        );
        socket!.onConnectTimeout((client) => print("socket :- timeout :-"));
        socket!.onDisconnect((data) {
          if (kDebugMode) {
            print("socket :-DisConnect");
          }
          socket!.clearListeners();
        });

        socket!.onReconnecting((data) => print("socket :- reconnecting"));
        socket!.onReconnectAttempt(
            (data) => print("socket :- onReconnectAttempt"));
        socket!.onReconnectFailed((data) => print("socket :- onReconnectFailed"));
        socket!.onReconnectError((data) => print("socket :- onReconnectError"));
        socket!.onReconnect((data) => print("socket :- reconnected succesfull"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("socket :- error :- ${e.toString()}");
      }
    }
  }

  startEmittingUserStatus(String userId, bool status) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 1500),
      (Timer timer) {
        Map<String, dynamic> userConnectionData = {
          "userStatus": status,
          "id": userId
        };
        socket!.emit("userStatus", userConnectionData);
      },
    );
  }

  Socket? getSocketInstance() {
    return socket;
  }

  Stream<bool> listenForUserConnectionStatus(String userIdToListen) {
    StreamController<bool> userConnectionStatusChangeStreamController =
        StreamController<bool>();

    if (kDebugMode) {
      print("USER ID TO LISTEN :- $userIdToListen");
    }

    socket!.on(
      "${userIdToListen}_status",
      (data) async {
        userConnectionStatusChangeStreamController.add(data);
      },
    );
    return userConnectionStatusChangeStreamController.stream
        .asBroadcastStream();
  }

  Stream<bool> listenForIsTyping(String userIdToListen) {
    StreamController<bool> userConnectionStatusChangeStreamController =
        StreamController<bool>();

    socket!.on(
      "typing",
      (data) async {
        userConnectionStatusChangeStreamController.add(data);
      },
    );
    return userConnectionStatusChangeStreamController.stream
        .asBroadcastStream();
  }

  changeTypingStatus(String receiverId, bool isTyping) {
    Map<String, dynamic> userConnectionData = {
      "id": receiverId,
      "isTyping": isTyping
    };
    socket!.emit("typing", userConnectionData);
  }

  sendPrivateMessage(PrivateMessageModel privateMessageModel, RecentChatServerModel recentChatServerModel, Function callback) async {
    Map<String, dynamic> privateMessageFullModel = {};
    privateMessageFullModel.putIfAbsent(
        "privateMessageModel", () => privateMessageModel);
    privateMessageFullModel.putIfAbsent("recentChatModel", () => recentChatServerModel);

    if (kDebugMode) {
      print("SOCKET EMIT EVENT :- " + "newPrivateMessage");
    }
    socket!.emitWithAck("newPrivateMessage", privateMessageFullModel, ack: ([data]) async {callback();});
  }

  emitUpdateMsgEvent(Map<String, dynamic> data, Function callback) {
    if (kDebugMode) {
      print("SOCKET EMIT EVENT :- " + "updatePrivateMessage");
    }
    socket!.emitWithAck(
      "updatePrivateMessage",
      data,
      ack: ([data]) async {
        callback();
      },
    );
  }

  List<bool> processStarted = [];
  List<bool> processEnded = [];

  listenForIncomingMsg() async {
    if (kDebugMode) {
      print("SOCKET LISTENING FOR INCOMING EVENT");
    }

    socket!.on(
      "newPrivateMessage",
      (data) async {
        if (kDebugMode) {
          print("SOCKET EVENT :- newPrivateMessage :- $data");
        }
        try {
          PrivateMessageModel _privateMessageModel = PrivateMessageModel.fromJson(data);
          MessagesTableCompanion _localModel = ModelConverters().convertMongoModelToLocalModel(_privateMessageModel);

          List<String> participantList = [
            _privateMessageModel.participants.user1Id,
            _privateMessageModel.participants.user2Id
          ];
          participantList.sort();

          for (int i = 0; i < 5; i++) {
            List<RecentChatTableData> recentChatTable = await _dataManager.getRecentChatTableDataFromUserIds(participantList);
            for (int i = 0; i < 5; i++) {
              if (processStarted.isNotEmpty) {
                await Future.delayed(const Duration(seconds: 1));
              } else {
                break;
              }
            }

            if (recentChatTable.isNotEmpty) {
              String id = recentChatTable[0].id;
              int count = recentChatTable[0].unread_msg ?? 1;
              processStarted.add(true);
              DeliverAtUpdateModel deliverUpdateModel = DeliverAtUpdateModel(
                  id: _privateMessageModel.id!,
                  deliveredAt: DateTime.now().millisecondsSinceEpoch,
                  senderId: _privateMessageModel.senderId);

              emitUpdateMsgEvent(
                deliverUpdateModel.toJson(),
                () async {
                  processEnded.add(true);

                  if (processStarted.length == processEnded.length) {
                    List<RecentChatTableData> _recentChatLatestData =
                        await _dataManager
                            .getRecentChatTableDataFromUserIds(participantList);

                    int totalMsgCount =
                        (_recentChatLatestData[0].unread_msg ?? 1) +
                            processStarted.length;

                    RecentChatTableCompanion recentChatTableCompanion0 = RecentChatTableCompanion(
                            id: Value(id),
                            unread_msg: Value(totalMsgCount),
                            last_msg_time: _localModel.createdAt,
                            last_msg_text: _localModel.msgContent);
                    await _dataManager
                        .updateRecentChatTableData(recentChatTableCompanion0);
                    processStarted = [];
                    processEnded = [];
                    await _dataManager.insertNewMessage(_localModel);
                  }
                },
              );
              break;
            } else {
              await Future.delayed(const Duration(seconds: 1));
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print("SOCKET EVENT :- " + "newPrivateMessage ERROR:- " + e.toString());
          }
        }
      },
    );

    socket!.on(
      "updateExistingMessageWithAcknowledgeApi",
      (data) async {
        try {
          Map<String, dynamic> incomingJsonData = data;
          incomingJsonData.putIfAbsent("is_sent", () => true);

          UpdateMessageModel updateMessageModel = UpdateMessageModel.fromJson(incomingJsonData);
          IdModel idModel = IdModel(id: updateMessageModel.id);
          await _dataManager.updateExitingMsg(updateMessageModel);
          await _dataManager.msgUpdatedLocallyForSender(idModel);
        } catch (e) {
        }
      },
    );

    socket!.on('newRecentChat', (data) async {
      try {
        RecentChatServerModel recentChatServerModel = RecentChatServerModel.fromJson(data);
        bool isUser1 = false;
        List<String> participantList = List.from(recentChatServerModel.participants);
        participantList.sort();
        int indexOfCurrentUser = participantList.indexWhere((element) => element == idOfUser);
        if (indexOfCurrentUser == 0) {
          isUser1 = true;
        }

        RecentChatLocalModel recentChatLocalModel = RecentChatLocalModel(
            id: recentChatServerModel.id,
            userName: isUser1
                ? recentChatServerModel.user2Name
                : recentChatServerModel.user1Name,
            userCompressedImage: isUser1
                ? recentChatServerModel.user2CompressedImage
                : recentChatServerModel.user1CompressedImage,
            participants: participantList,
        );

        List<RecentChatTableData> recentChatTableData = await _dataManager.getRecentChatTableDataFromUserIds(recentChatLocalModel.participants);

        if (recentChatTableData.isEmpty) {
          await _dataManager.insertNewRecentChat(recentChatLocalModel);
        } else {
          int totalMsgCount = (recentChatTableData[0].unread_msg ?? 0); // +
          RecentChatTableCompanion recentChatTableCompanion = RecentChatTableCompanion(
                  id: Value(recentChatTableData[0].id),
                  unread_msg: Value(totalMsgCount),
                  user_name: Value(recentChatLocalModel.userName),
                  user_compressed_image: Value(recentChatLocalModel.userCompressedImage),
                  last_msg_time: Value(recentChatTableData[0].last_msg_time),
                  last_msg_text: Value(recentChatTableData[0].last_msg_text)
          );
          await _dataManager.updateRecentChatTableData(recentChatTableCompanion);
        }

        Map<String, Object> updateObject = {};
        String keyOfUserLocalUpdate = "";
        if (isUser1) {
          keyOfUserLocalUpdate = "user1_local_updated";
        } else {
          keyOfUserLocalUpdate = "user2_local_updated";
        }

        updateObject.putIfAbsent("_id", () => recentChatLocalModel.id);
        updateObject.putIfAbsent(keyOfUserLocalUpdate, () => true);

        await _dataManager.updateRecentChat(updateObject);
      } catch (e) {}
    });
  }
}
