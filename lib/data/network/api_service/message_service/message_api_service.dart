
import '../../../../app/locator.dart';
import '../../../../const/end_points.dart';
import '../../../../models/basic_models/id_model.dart';
import '../../../../models/chat_models/deliver_at_update_model.dart';
import '../../../../models/chat_models/private_message_model.dart';
import '../../../../models/chat_models/seen_at_update_model.dart';
import '../../../../models/recent_chat_model/recent_chat_server_model.dart';
import '../../../../utils/api_utils/api_result/api_result.dart';
import '../../../../utils/api_utils/network_exceptions/network_exceptions.dart';
import '../../../../utils/client.dart';
import 'message_api_helper.dart';

class MessageApiService implements MessageApiHelper {
  Client _client = locator<Client>();

  MessageApiService() {
    _client = Client();
  }

  @override
  Future<ApiResult<bool>> sendPrivateMessage(
      PrivateMessageModel privateMessageModel,RecentChatServerModel _recentChatServerModel) async {
    Client tempClient = await _client.builder().setProtectedApiHeader();

    print("privateMessageModel 1 : - " + tempClient.header.toString());

    Map<String,Object> messageModel = {};
    messageModel.putIfAbsent("privateMessageModel", () => privateMessageModel.toJson());
    messageModel.putIfAbsent("recentChatModel", () => _recentChatServerModel.toJson());

    try {
      await tempClient
          // .setUrlEncoded()
          .build()
          .post(EndPoints.sendMessage, data: messageModel);
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> updateMsgSeenTime(
      SeenAtUpdateModel seenAtUpdateModel) async {
    Client tempClient = await _client.builder().setProtectedApiHeader();

    try {
      await tempClient
          // .setUrlEncoded()
          .build()
          .patch(EndPoints.updateMessageSeenAt, data: seenAtUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> updateMsgDeliverTime(DeliverAtUpdateModel deliveredAtUpdateModel)async {
    Client tempClient = await _client.builder().setProtectedApiHeader();

    try {
      await tempClient
      // .setUrlEncoded()
          .build()
          .patch(EndPoints.updateMessageDeliverTime, data: deliveredAtUpdateModel.toJson());
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> msgUpdatedLocallyForSender(IdModel idModel) async{
    Client tempClient = await _client.builder().setProtectedApiHeader();

    try {
      await tempClient
      // .setUrlEncoded()
          .build()
          .patch(EndPoints.msgUpdatedLocallyForSender,data: idModel);
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> updateRecentChat(Map<String, Object> updateObject) async{
    Client tempClient = await _client.builder().setProtectedApiHeader();
    try {
      await tempClient
          .build()
          .patch(EndPoints.recentChatUpdate,data: updateObject);
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

}
