
import '../../../../models/basic_models/id_model.dart';
import '../../../../models/chat_models/deliver_at_update_model.dart';
import '../../../../models/chat_models/private_message_model.dart';
import '../../../../models/chat_models/seen_at_update_model.dart';
import '../../../../models/recent_chat_model/recent_chat_server_model.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';

abstract class MessageApiHelper {
  Future<ApiResult<bool>> sendPrivateMessage(
      PrivateMessageModel privateMessageModel,
      RecentChatServerModel recentChatModel);

  Future<ApiResult<bool>> updateMsgDeliverTime(
    DeliverAtUpdateModel statusUpdateModel,
  );

  //
  Future<ApiResult<bool>> updateMsgSeenTime(
    SeenAtUpdateModel seenAtUpdateModel,
  );

  Future<ApiResult<bool>> msgUpdatedLocallyForSender(IdModel idModel);
  Future<ApiResult<bool>> updateRecentChat(Map<String,Object> updateObject);
}
