class EndPoints {

  static const String addUser = "/users";
  static const String updateUser = "/users";
  static const String searchUser = "/users/search";
  static const String getSingleUser = "/users";
  static const String updateUserToken = "/users/userUpdateToken";
  static const String getBackupDetails = "/users/getBackupDetails";
  static const String getUserBackupData = "/users/userBackUpData";
  static const String userConnectionStatus = "/users/userConnectionStatus";

  static const String sendMessage = "/messages";
  static const String updateMessageSeenAt = "/messages/updateMsgSeenTime";
  static const String updateMessageDeliverTime = "/messages/updateMsgDeliverTime";
  static const String getMissedMessage = "/messages/getMissedMessage";
  static const String msgUpdatedLocallyForSender = "/messages/updateSenderLocalMsgStatus";
  static const String recentChatUpdate = "/messages/recentChatUpdate";
}