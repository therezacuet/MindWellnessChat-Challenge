import 'package:flutter/foundation.dart';

import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';
import '../../models/user/user_basic_data_offline_model.dart';

class StartUpViewModel extends CustomBaseViewModel {
  runStartupLogic() async {
    bool isLoggedIn = await getAuthService().isUserLoggedIn();
    UserBasicDataOfflineModel? userBasicDataOfflineModel = await getDataManager().getUserBasicDataOfflineModel();
    if (isLoggedIn && userBasicDataOfflineModel != null) {
      bool result = await getDataManager().getBackUpDataDownloadStatus();
      if (kDebugMode) {
        print("RESULT : $result");
      }
      if(result){
        getNavigationService().clearStackAndShow(Routes.mainScreenView);
      }else{
        getNavigationService().clearStackAndShow(Routes.backUpFoundScreen);
      }
    } else {
      await getAuthService().logOut();
      getNavigationService().clearStackAndShow(Routes.authView);
    }
  }
}