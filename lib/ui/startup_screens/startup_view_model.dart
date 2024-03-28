import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';

class StartUpViewModel extends CustomBaseViewModel {
  runStartupLogic() async {
    bool isLoggedIn = await getAuthService().isUserLoggedIn();
    if (isLoggedIn) {
      getNavigationService().clearStackAndShow(Routes.mainScreenView);
    } else {
      await getAuthService().logOut();
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }
}