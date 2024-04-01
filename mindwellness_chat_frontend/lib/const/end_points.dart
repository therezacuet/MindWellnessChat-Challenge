class EndPoints {

  static const String apiVersionV1 = "/api/v1";

  // User EndPoints
  static const String users = "$apiVersionV1/users";
  static const String searchUser = "$users/search";
  static const String updateUserToken = "$users/userUpdateToken";
  static const String getBackupDetails = "$users/getBackupDetails";
  static const String getUserBackupData = "$users/userBackUpData";
  static const String userConnectionStatus = "$users/userConnectionStatus";

  // Message EndPoint
  static const String messages = "$apiVersionV1/messages";
  static const String updateMessageSeenAt = "$messages/updateMsgSeenTime";
  static const String updateMessageDeliverTime = "$messages/updateMsgDeliverTime";
  static const String getMissedMessage = "$messages/getMissedMessage";
  static const String msgUpdatedLocallyForSender = "$messages/updateSenderLocalMsgStatus";
  static const String recentChatUpdate = "$messages/recentChatUpdate";
}