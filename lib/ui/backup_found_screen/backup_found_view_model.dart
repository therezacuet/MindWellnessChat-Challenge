

import 'package:flutter/foundation.dart';

import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';
import '../../models/recent_chat_model/recent_chat_local_model.dart';
import '../../models/recent_chat_model/recent_chat_server_model.dart';
import '../../utils/api_utils/api_result/api_result.dart';
import '../../utils/api_utils/network_exceptions/network_exceptions.dart';

class BackupFoundViewModel extends CustomBaseViewModel {

  downloadBackUpData() async {
    String? idOfUser = await getAuthService().getUserid();
    ApiResult<List<RecentChatServerModel>> backUpDataModel = await getDataManager().getUserBackUpData(idOfUser!);
    backUpDataModel.when(success: (List<RecentChatServerModel> listOfRecentChat) async{
      if (kDebugMode) {
        print("BACKUP DATA MODEL :- ${listOfRecentChat.length}");
      }
      for(int i = 0;i<listOfRecentChat.length;i++){
        RecentChatServerModel recentChatServerModel = listOfRecentChat[i];
        bool isUser1 = false;
        List<String> participantList =
        List.from(recentChatServerModel.participants);
        participantList.sort();
        int indexOfCurrentUser =
        participantList.indexWhere((element) => element == idOfUser);
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

        await getDataManager().insertNewRecentChat(recentChatLocalModel);
        getNavigationService().clearStackAndShow(Routes.mainScreenView);
      }
      await getDataManager().isBackUpDataDownloadComplete(true);

    }, failure: (NetworkExceptions e) {
      showErrorDialog(description: NetworkExceptions.getErrorMessage(e));
    });
  }

}