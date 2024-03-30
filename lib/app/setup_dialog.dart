import 'package:stacked_services/stacked_services.dart';
import '../const/enums/dialogs_enum.dart';
import '../ui/widgets/dialogs/confirmation_dialog.dart';
import '../ui/widgets/dialogs/failure_dialog.dart';
import '../ui/widgets/dialogs/logout_dialog.dart';
import '../ui/widgets/dialogs/permission_dialog.dart';
import '../ui/widgets/dialogs/success_dialog.dart';
import 'locator.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogEnum.saveOrNot: (context, sheetRequest, completer) =>
        LogoutDialog(request: sheetRequest, completer: completer),
    DialogEnum.success: (context, sheetRequest, completer) =>
        SuccessDialog(request: sheetRequest, completer: completer),
    DialogEnum.confirmation: (context, sheetRequest, completer) =>
        ConfirmationDialog(request: sheetRequest, completer: completer),
    DialogEnum.failure: (context, sheetRequest, completer) =>
        FailureDialog(request: sheetRequest, completer: completer),
    DialogEnum.permission: (context, sheetRequest, completer) =>
        PermissionDialog(request: sheetRequest, completer: completer),
  };

  dialogService.registerCustomDialogBuilders(builders);
}