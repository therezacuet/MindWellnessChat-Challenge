import 'dart:async';

import 'package:drift/drift.dart';
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
      print("NEW SOCKET DISPOSING");
      socket!.dispose();
    }

    try {
      print("NEW SOCKET CREATED");

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
            print("socket :-Connected");
            listenForIncomingMsg();
            List<MessagesTableData> _notSentMsg =
                await _dataManager.getNotSentMsg(userId);
            startEmittingUserStatus(userId, true);

            for (MessagesTableData msg in _notSentMsg) {
              print("MSG FROM MOOR IS SENDING :- ${msg.msgContent}");

              if (msg.msgContentType == MsgType.txt) {
                Participants participants = Participants(
                    user1Id: msg.senderId, user2Id: msg.receiverId);
                int currentTime = DateTime.now().millisecondsSinceEpoch;

                UserBasicDataOfflineModel? userBasicDataOfflineModel = await _dataManager.getUserBasicDataOfflineModel();

                if (userBasicDataOfflineModel != null) {
                  PrivateMessageModel _privateMessageModel =
                      PrivateMessageModel(
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
                      privateMessageModel: _privateMessageModel,
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
          print("socket :-DisConnect");
          socket!.clearListeners();
        });

        socket!.onReconnecting((data) => print("socket :- reconnecting"));
        socket!.onReconnectAttempt(
            (data) => print("socket :- onReconnectAttempt"));
        socket!.onReconnectFailed((data) => print("socket :- onReconnectFailed"));
        socket!.onReconnectError((data) => print("socket :- onReconnectError"));
        socket!.onReconnect((data) => print("socket :- reconnected succesfull"));
      }

      //socket?.emit("privateMsg", {"content": "Hello"});
    } catch (e) {
      print("socket :- error :- ${e.toString()}");
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
        // print("EMITING STATUS :- "  + userConnectionData.toString());
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

    print("USER ID TO LIETEN :- " + userIdToListen);

    socket!.on(
      userIdToListen + "_status",
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
      // userIdToListen + "_typing",
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
    privateMessageFullModel.putIfAbsent(
        "recentChatModel", () => recentChatServerModel);

    print("SOCKET EMIT EVENT :- " + "newPrivateMessage");

    socket!.emitWithAck("newPrivateMessage", privateMessageFullModel, ack: ([data]) async {callback();});
  }

  emitUpdateMsgEvent(Map<String, dynamic> data, Function callback) {
    print("SOCKET EMIT EVENT :- " + "updatePrivateMessage");

    socket!.emitWithAck(
      "updatePrivateMessage",
      data,
      ack: ([data]) async {
        callback();
        // await _dataManager
        //     .updateRecentChatTableData(_recentChatTableCompanion);
        // await _dataManager.insertNewMessage(_localModel);
      },
    );
  }

  List<bool> processStarted = [];
  List<bool> processEnded = [];

  listenForIncomingMsg() async {
    print("SOCKET LISNING FOR INCOMING EVENT");

    socket!.on(
      "newPrivateMessage",
      (data) async {
        print("SOCKET EVENT :- " + "newPrivateMessage :- " + data.toString());
        try {
          PrivateMessageModel _privateMessageModel = PrivateMessageModel.fromJson(data);
          MessagesTableCompanion _localModel = ModelConverters().convertMongoModelToLocalModel(_privateMessageModel);

          List<String> participantList = [
            _privateMessageModel.participants.user1Id,
            _privateMessageModel.participants.user2Id
          ];
          participantList.sort();

          for (int i = 0; i < 5; i++) {
            List<RecentChatTableData> _recentChatTable = await _dataManager
                .getRecentChatTableDataFromUserIds(participantList);

            print("LOOP STARTED");

            for (int i = 0; i < 5; i++) {
              if (processStarted.isNotEmpty) {
                await Future.delayed(const Duration(seconds: 1));
              } else {
                break;
              }
            }

            if (_recentChatTable.isNotEmpty) {
              String id = _recentChatTable[0].id;
              int count = _recentChatTable[0].unread_msg ?? 1;
              processStarted.add(true);
              print("LOOP COUNT :- " + count.toString());

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

                    print("totalMsgCount 0 :-  ${processStarted.length}");
                    print("totalMsgCount 1 :-  $totalMsgCount");
                    RecentChatTableCompanion _recentChatTableCompanion =
                        RecentChatTableCompanion(
                            id: Value(id),
                            unread_msg: Value(totalMsgCount),
                            last_msg_time: _localModel.createdAt,
                            last_msg_text: _localModel.msgContent);
                    await _dataManager
                        .updateRecentChatTableData(_recentChatTableCompanion);
                    processStarted = [];
                    processEnded = [];
                    await _dataManager.insertNewMessage(_localModel);
                  }
                },
              );

              // await _dataManager.updateMsgDeliverTime(_deliverUpdateModel);
              break;
            } else {
              await Future.delayed(const Duration(seconds: 1));
            }
          }
        } catch (e) {
          print(
              "SOCKET EVENT :- " + "newPrivateMessage ERROR:- " + e.toString());
        }
      },
    );

    socket!.on(
      "updateExistingMessageWithAcknowledgeApi",
      (data) async {
        print("SOCKET EVENT :- " + "updateExistingMessageWithAcknowledgeApi");

        try {
          Map<String, dynamic> incomingJsonData = data;
          incomingJsonData.putIfAbsent("is_sent", () => true);

          UpdateMessageModel _updateMessageModel = UpdateMessageModel.fromJson(incomingJsonData);
          IdModel idModel = IdModel(id: _updateMessageModel.id);
          await _dataManager.updateExitingMsg(_updateMessageModel);
          await _dataManager.msgUpdatedLocallyForSender(idModel);
        } catch (e) {
          print("HELLO :-  " + e.toString());
        }
      },
    );

    socket!.on('newRecentChat', (data) async {
      print("SOCKET EVENT :- " + "newRecentChat :-  " + data.toString());
      try {
        RecentChatServerModel _recentChatServerModel = RecentChatServerModel.fromJson(data);

        // String? userId = idOfUser ;//?? await (_firebaseAuthService.getUserid());

        bool isUser1 = false;
        List<String> participantList =
            List.from(_recentChatServerModel.participants);
        participantList.sort();
        int indexOfCurrentUser =
            participantList.indexWhere((element) => element == idOfUser);
        if (indexOfCurrentUser == 0) {
          isUser1 = true;
        }

        RecentChatLocalModel recentChatLocalModel = RecentChatLocalModel(
          id: _recentChatServerModel.id,
          userName: isUser1
              ? _recentChatServerModel.user2Name
              : _recentChatServerModel.user1Name,
          userCompressedImage: isUser1
              ? _recentChatServerModel.user2CompressedImage
              : _recentChatServerModel.user1CompressedImage,
          participants: participantList,
          // unreadMsg: _recentChatServerModel,
          // lastMsg: inputText,
          // lastMsgTime: currentTime,
          // shouldUpdate: false
        );

        List<RecentChatTableData> _recentChatTableData =
            await _dataManager.getRecentChatTableDataFromUserIds(recentChatLocalModel.participants);

        print("_recentChatLocalModel :- " + recentChatLocalModel.toJson().toString());

        if (_recentChatTableData.isEmpty) {
          await _dataManager.insertNewRecentChat(recentChatLocalModel);
        } else {
          int totalMsgCount = (_recentChatTableData[0].unread_msg ?? 0); // +
          RecentChatTableCompanion _recentChatTableCompanion =
              RecentChatTableCompanion(
                  id: Value(_recentChatTableData[0].id),
                  unread_msg: Value(totalMsgCount),
                  user_name: Value(recentChatLocalModel.userName),
                  user_compressed_image: Value(recentChatLocalModel.userCompressedImage),
                  last_msg_time: Value(_recentChatTableData[0].last_msg_time),
                  last_msg_text: Value(_recentChatTableData[0].last_msg_text));
          await _dataManager.updateRecentChatTableData(_recentChatTableCompanion);
        }

        Map<String, Object> _updateObject = {};
        String keyOfUserLocalUpdate = "";
        if (isUser1) {
          keyOfUserLocalUpdate = "user1_local_updated";
        } else {
          keyOfUserLocalUpdate = "user2_local_updated";
        }

        _updateObject.putIfAbsent("_id", () => recentChatLocalModel.id);
        _updateObject.putIfAbsent(keyOfUserLocalUpdate, () => true);

        await _dataManager.updateRecentChat(_updateObject);
      } catch (e) {}
    });
  }
}
