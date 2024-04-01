
import 'local/dao/message_dao/messages_helper.dart';
import 'local/dao/recent_chat_dao/recent_chat_helper.dart';
import 'network/api_helper.dart';
import 'network/api_service/user_connection_status/user_connection_status_helper.dart';
import 'prefs/shared_preference_helper.dart';

abstract class DataManagerHelper implements ApiHelper,UserConnectionStatusHelper,SharedPreferenceHelper, MessagesDaoHelper, RecentChatDaoHelper{
}