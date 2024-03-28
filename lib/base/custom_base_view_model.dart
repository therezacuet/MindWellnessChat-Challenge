
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';
import '../app/routes/setup_routes.router.dart';
import '../const/enums/bottom_sheet_enums.dart';
import '../services/firebase_auth_service.dart';

class CustomBaseViewModel extends BaseViewModel {
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();

  final NavigationService _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();

  FirebaseAuthService getAuthService() => _firebaseAuthService;

  NavigationService getNavigationService() => _navigationService;
  BottomSheetService getBottomSheetService() => _bottomSheetService;
  DialogService getDialogService() => _dialogService;

  refreshScreen() {
    notifyListeners();
  }

  showProgressBar({String title = "Please wait..."}) {
    EasyLoading.show(status: title);
  }

  stopProgressBar() {
    EasyLoading.dismiss();
  }

  goToPreviousScreen() {
    getNavigationService().back();
  }

  logOut({bool shouldRedirectToAuthenticationPage = true}) async {
    await getAuthService().logOut();
    if (shouldRedirectToAuthenticationPage) {
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }

  showErrorDialog(
      {String title = "Problem occurred",
        String description = "Some problem occurred Please try again",
        bool isDismissible = true}) async {
    stopProgressBar();
    await _bottomSheetService.showCustomSheet(
        title: title,
        description: description,
        mainButtonTitle: "OK",
        variant: BottomSheetEnum.error,
        barrierDismissible: isDismissible);
  }
}
