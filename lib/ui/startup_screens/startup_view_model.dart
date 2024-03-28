import 'dart:async';

import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';

class StartUpViewModel extends CustomBaseViewModel {
  runStartupLogic() async {
    // wait 2 second then navigate
    Timer(
        const Duration(
            seconds: 2),
            () => getNavigationService().clearStackAndShow(Routes.authView)
    );
  }
}