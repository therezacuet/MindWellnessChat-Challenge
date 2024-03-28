import '../../../../models/chat_models/update_message_model.dart';
import '../../app_database.dart';

abstract class MessagesDaoHelper {

  Future insertNewMessage(MessagesTableCompanion message);
  Stream<List<MessagesTableData>> watchNewMessages(String _id,String partnerId);
  Future updateExitingMsg(UpdateMessageModel message);
  Future<List<MessagesTableData>> getOldMessages(int _id,String partnerId);
  Future<List<MessagesTableData>> getNotSentMsg(String userId);
  Future<bool> updateSeenTimeLocallyForReceiver(String msgId,int seenAt);
  Future<bool> updateMsgImageUrl({required String msgId,required bool isNetworkUrl,required String url,String? blurHashImageUri});
  Future<bool> makeAllMessageRead();
  Future<MessagesTableData?> getMessageFromId(String id);

}
