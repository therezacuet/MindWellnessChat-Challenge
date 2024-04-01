
import '../../../../base/custom_base_view_model.dart';
import '../../../../data/local/app_database.dart';

class RecentChatViewModel extends CustomBaseViewModel {

  String userId = "";

  Stream<List<RecentChatTableData>> getRecentChats() {
    Stream<List<RecentChatTableData>>? msgStream = getDataManager().watchRecentChat();
    return msgStream;
  }

  getUserId() async{
    userId = (await getAuthService().getUserid())!;
  }
}
