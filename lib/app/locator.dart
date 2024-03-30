import 'package:get_it/get_it.dart';
import 'package:mind_wellness_chat/ui/auth_screens/auth_view_model.dart';
import 'package:mind_wellness_chat/ui/backup_found_screen/backup_found_view_model.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/profile/profile_view_model.dart';
import 'package:stacked_services/stacked_services.dart';
import '../base/custom_base_view_model.dart';
import '../data/data_manager.dart';
import '../data/local/app_database.dart';
import '../data/network/api_service/message_service/message_api_service.dart';
import '../data/network/api_service/user_connection_status/user_connection_status_service.dart';
import '../data/network/api_service/users/user_api_service.dart';
import '../data/prefs/shared_preference_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_push_notification_service.dart';
import '../services/socket_service.dart';
import '../ui/chat_screen/chat_view_model.dart';
import '../ui/main_screen/fragments/search/search_view_model.dart';
import '../ui/main_screen/main_screen_view_model.dart';
import '../ui/startup_screens/startup_view_model.dart';
import '../utils/client.dart';

GetIt locator = GetIt.I;

void setupLocator() {

  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  //View Models
  locator.registerLazySingleton(() => CustomBaseViewModel());
  locator.registerLazySingleton(() => StartUpViewModel());
  locator.registerLazySingleton(() => AuthViewModel());
  locator.registerLazySingleton(() => SearchViewModel());
  locator.registerLazySingleton(() => MainScreenViewModel());
  locator.registerLazySingleton(() => ChatViewModel());
  locator.registerLazySingleton(() => ProfileViewModel());
  locator.registerLazySingleton(() => BackupFoundViewModel());

  // firebase
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirebasePushNotificationService());

  //Data
  locator.registerLazySingleton(() => DataManager());
  locator.registerLazySingleton(() => Client());
  locator.registerLazySingleton(() => SharedPreferenceService());

  //Api Services
  locator.registerLazySingleton(() => UserApiService());
  locator.registerLazySingleton(() => MessageApiService());

  //Socket Services
  locator.registerLazySingleton(() => SocketService());

  //Drift Database
  locator.registerLazySingleton(() => AppDatabase());
  locator.registerLazySingleton(() => UserConnectionStatusService());
}
