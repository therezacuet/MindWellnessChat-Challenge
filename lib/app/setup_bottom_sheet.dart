import 'package:mind_wellness_chat/ui/widgets/bottom_sheets/error_dialog.dart';
import 'package:mind_wellness_chat/ui/widgets/bottom_sheets/no_internet_dialog.dart';
import 'package:stacked_services/stacked_services.dart';
import '../const/enums/bottom_sheet_enums.dart';
import '../ui/main_screen/fragments/profile/widgets/edit_profile_bottom_sheet.dart';
import '../ui/widgets/bottom_sheets/basic_dialog.dart';
import 'locator.dart';

void setUpBottomSheet() {
  final bottomSheetService = locator<BottomSheetService>();
  final builders = {
    BottomSheetEnum.basic: (context, sheetRequest, completer) =>
        BasicDialog(request: sheetRequest, completer: completer),
    BottomSheetEnum.error: (context, sheetRequest, completer) =>
        ErrorDialog(request: sheetRequest, completer: completer),
    BottomSheetEnum.noInternet: (context, sheetRequest, completer) =>
        NoInternetDialog(request: sheetRequest, completer: completer),
    BottomSheetEnum.editProfile: (context, sheetRequest, completer) =>
        EditProfileBottomSheet(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}