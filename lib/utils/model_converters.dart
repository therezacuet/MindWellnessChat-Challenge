import 'package:drift/drift.dart';

import '../data/local/app_database.dart';
import '../models/chat_models/private_message_model.dart';
import '../models/chat_models/update_message_model.dart';

class ModelConverters {
  MessagesTableCompanion convertMongoModelToLocalModel(
      PrivateMessageModel privateMessageModel) {
    return MessagesTableCompanion(
      mongoId: Value(privateMessageModel.id!),
      msgContentType: Value(privateMessageModel.msgContentType),
      msgContent: Value(privateMessageModel.msgContent),
      msgStatus: Value(privateMessageModel.msgStatus),
      senderId: Value(privateMessageModel.senderId),
      receiverId: Value(privateMessageModel.receiverId),
        createdAt: Value(privateMessageModel.createdAt),
      networkFileUrl: Value(privateMessageModel.networkFileUrl),
      imageInfo: Value(privateMessageModel.imageInfo),
      blurHashImageUrl:  Value(privateMessageModel.blurHashImage),
      // receiverName:Value(_privateMessageModel.re)
    );
  }

  MessagesTableCompanion convertUpdateModelToLocalModel(UpdateMessageModel _updateMessageModel) {
    return const MessagesTableCompanion();
  }
}
