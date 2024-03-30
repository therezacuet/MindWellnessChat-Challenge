import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

import '../../app/locator.dart';
import '../../app/routes/setup_routes.router.dart';
import '../../base/custom_base_view_model.dart';
import '../../base/custom_index_tracking_view_model.dart';
import '../../services/socket_service.dart';
class MainScreenViewModel extends CustomIndexTrackingViewModel {
  final CustomBaseViewModel _baseViewModel = locator<CustomBaseViewModel>();

  initializeSocket() async {
    SocketService socketService = _baseViewModel.getSocketService();
    String? userId = await _baseViewModel.getAuthService().getUserid();

    if (userId != null) {
      connectToSocket(socketService,userId);
      Timer.periodic(
        const Duration(seconds: 5),
        (Timer timer) async{
          String? userId = await _baseViewModel.getAuthService().getUserid();
          if(userId != null){
            connectToSocket(socketService,userId);
          }
        },
      );
    } else {
      _baseViewModel.getNavigationService().clearStackAndShow(Routes.authView);
      _baseViewModel.showErrorDialog(description: "You logged out from app due to unexpected problem please login again");
    }
  }

  connectToSocket(SocketService socketService,String userId){
    if (socketService.getSocketInstance() != null) {

      if(socketService.getSocketInstance()!.disconnected){
        socketService.connectToSocket(userId);
      }
    }else{
      socketService.connectToSocket(userId);
    }
  }

}
