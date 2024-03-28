import 'package:mind_wellness_chat/ui/auth_screens/auth_view.dart';
import 'package:stacked/stacked_annotations.dart';

import '../../ui/startup_screens/startup_view.dart';
@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: AuthView),
  ],
)
class AppSetup {}
