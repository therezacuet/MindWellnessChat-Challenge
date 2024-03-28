
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';
import '../const/enums/bottom_sheet_enums.dart';

class CustomBaseViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final DialogService _dialogService = locator<DialogService>();


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
