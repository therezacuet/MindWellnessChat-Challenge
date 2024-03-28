import 'package:get_it/get_it.dart';
import 'package:mind_wellness_chat/ui/auth_screens/auth_view_model.dart';
import 'package:stacked_services/stacked_services.dart';
import '../base/custom_base_view_model.dart';
import '../ui/startup_screens/startup_view_model.dart';

GetIt locator = GetIt.I;

void setupLocator() {

  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());

  //View Models
  locator.registerLazySingleton(() => CustomBaseViewModel());
  locator.registerLazySingleton(() => StartUpViewModel());
  locator.registerLazySingleton(() => AuthViewModel());
}
