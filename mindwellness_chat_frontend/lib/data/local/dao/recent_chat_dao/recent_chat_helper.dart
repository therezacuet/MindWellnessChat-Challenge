
import '../../../../models/recent_chat_model/recent_chat_local_model.dart';
import '../../app_database.dart';

abstract class RecentChatDaoHelper {

  Future insertNewRecentChat(RecentChatLocalModel recentChatModel);
  Stream<List<RecentChatTableData>> watchRecentChat();
  Future<List<RecentChatTableData>> getRecentChatTableDataFromUserIds(List<String> userIdList);
  Future updateRecentChatTableData(RecentChatTableCompanion _recentChatTableCompanion);
  Future makeAllMsgRead(List<String> userIdList);


}
