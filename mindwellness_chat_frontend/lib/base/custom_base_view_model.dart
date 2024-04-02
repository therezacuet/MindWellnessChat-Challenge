
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';
import '../app/routes/setup_routes.router.dart';
import '../const/enums/bottom_sheet_enums.dart';
import '../const/msg_status_const.dart';
import '../data/data_manager.dart';
import '../data/local/app_database.dart';
import '../data/prefs/shared_preference_service.dart';
import '../models/chat_models/private_message_model.dart';
import '../models/chat_models/update_message_model.dart';
import '../models/recent_chat_model/recent_chat_local_model.dart';
import '../models/recent_chat_model/recent_chat_server_model.dart';
import '../models/user/user_basic_data_model.dart';
import '../models/user/user_basic_data_offline_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_push_notification_service.dart';
import '../services/socket_service.dart';
import '../utils/mongo_utils.dart';

class CustomBaseViewModel extends BaseViewModel {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FirebasePushNotificationService _firebasePushNotificationService = locator<FirebasePushNotificationService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();

  final DataManager _dataManager = locator<DataManager>();
  final SocketService _socketService = locator<SocketService>();
  final AppDatabase _appDatabase = locator<AppDatabase>();
  final SharedPreferenceService _sharedPreferenceService = locator<SharedPreferenceService>();

  FirebaseAuthService getAuthService() => _firebaseAuthService;
  FirebasePushNotificationService getFirebasePushNotificationService() => _firebasePushNotificationService;

  NavigationService getNavigationService() => _navigationService;
  BottomSheetService getBottomSheetService() => _bottomSheetService;
  DialogService getDialogService() => _dialogService;

  DataManager getDataManager() => _dataManager;
  SocketService getSocketService() => _socketService;
  SharedPreferenceService getSharedPreferenceService() => _sharedPreferenceService;
  AppDatabase getAppDatabase() => _appDatabase;


  refreshScreen() {
    notifyListeners();
  }

  showProgressBar({String title = "Please wait..."}) {
    EasyLoading.show(status: title);
  }

  stopProgressBar() {
    EasyLoading.dismiss();
  }

  goToPreviousScreen() {
    getNavigationService().back();
  }

  gotoChatScreen(UserDataBasicModel userBasicDataModel) {
    getNavigationService().navigateTo(Routes.chatView, arguments: ChatViewArguments(userDataBasicModel: userBasicDataModel));
  }

  logOut({bool shouldRedirectToAuthenticationPage = true}) async {
    await getAuthService().logOut();
    if (shouldRedirectToAuthenticationPage) {
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }

  showErrorDialog(
      {String title = "Problem occurred",
        String description = "Some problem occurred Please try again",
        bool isDismissible = true}) async {
    stopProgressBar();
    await _bottomSheetService.showCustomSheet(
        title: title,
        description: description,
        mainButtonTitle: "OK",
        variant: BottomSheetEnum.error,
        barrierDismissible: isDismissible);
  }

  Future<void> sendMessageWithDataModel(
      {required String inputText,
        required int currentTime,
        required PrivateMessageModel privateMessageModel,
        required  String currentUserId,
        required  String id,
        required  String name,
        String? compressedProfileImage,
        required  String statusLine}) async {
    String randomMongoId2 = MongoUtils().generateUniqueMongoId();

    late UserDataBasicModel userDataBasicModel = UserDataBasicModel(
        id: id,
        name: name,
        compressedProfileImage: compressedProfileImage,
        statusLine: statusLine);

    UserBasicDataOfflineModel? userBasicDataOfflineModel = await getDataManager().getUserBasicDataOfflineModel();

    if (userBasicDataOfflineModel != null) {
      List<String> participantList = [currentUserId, userDataBasicModel.id];
      participantList.sort();

      bool isSenderUser1 = false;
      int indexOfSender =
      participantList.indexWhere((element) => element == currentUserId);
      if (indexOfSender == 0) {
        isSenderUser1 = true;
      }

      List<RecentChatTableData> recentChatTableData =
      await getDataManager()
          .getRecentChatTableDataFromUserIds(participantList);
      String recentChatId = randomMongoId2;
      if (recentChatTableData.isNotEmpty) {
        recentChatId = recentChatTableData[0].id;
      }

      RecentChatServerModel recentChatServerModel = RecentChatServerModel(
          id: recentChatId,
          user1Name: isSenderUser1
              ? userBasicDataOfflineModel.name
              : userDataBasicModel.name,
          user1CompressedImage: isSenderUser1
              ? userBasicDataOfflineModel.compressedProfileImage
              : userDataBasicModel.compressedProfileImage,
          user2Name: isSenderUser1
              ? userDataBasicModel.name
              : userBasicDataOfflineModel.name,
          user2CompressedImage: isSenderUser1
              ? userDataBasicModel.compressedProfileImage
              : userBasicDataOfflineModel.compressedProfileImage,
          participants: participantList,
          user1LocalUpdated: isSenderUser1,
          user2LocalUpdated: !isSenderUser1,
          shouldUpdateRecentChat:
          recentChatTableData.isNotEmpty ? true : false);

      if (recentChatTableData.isEmpty) {
        RecentChatLocalModel recentChatLocalModel = RecentChatLocalModel(
            id: recentChatId,
            userName: userDataBasicModel.name,
            userCompressedImage: userDataBasicModel.compressedProfileImage,
            participants: participantList,
            unreadMsg: 0,
            lastMsg: inputText,
            lastMsgTime: currentTime,
            shouldUpdate: false);
        getDataManager().insertNewRecentChat(recentChatLocalModel);
      }

      await getSocketService().sendPrivateMessage(
        privateMessageModel,
        recentChatServerModel,
            () async {
          UpdateMessageModel updateMessageModel = UpdateMessageModel(
              id: privateMessageModel.id!,
              seenAt: null,
              deliveredAt: null,
              msgStatus: MsgStatus.sent,
              isSent: true);

          RecentChatTableCompanion _recentChatTableCompanion =
          RecentChatTableCompanion(
              id: Value(recentChatId),
              last_msg_time: Value(currentTime),
              last_msg_text: Value(inputText));

          await getDataManager().updateExitingMsg(updateMessageModel);
          await getDataManager()
              .updateRecentChatTableData(_recentChatTableCompanion);
        },
      );
    }
  }

  // Request the files permission and updates the UI accordingly
  Future<bool> requestPhotoPermission() async {
    PermissionStatus result;
    // In Android we need to request the storage permission,
    // while in iOS is the photos permission
    if (Platform.isAndroid) {
      result = await Permission.manageExternalStorage.request();
    } else {
      result = await Permission.photos.request();
    }
    if (result.isGranted) {
      return true;
    }
    return false;
  }

  // Request the camera permission and updates the UI accordingly
  Future<bool> requestCameraPermission() async {
    PermissionStatus result = await Permission.camera.request();
    if (result.isGranted) {
      return true;
    }
    return false;
  }
}
