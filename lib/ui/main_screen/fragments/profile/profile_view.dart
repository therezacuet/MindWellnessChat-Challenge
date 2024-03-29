import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/app_const.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/profile/profile_view_model.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/profile/widgets/curve_clipper.dart';
import 'package:mind_wellness_chat/ui/main_screen/fragments/profile/widgets/profile_action_holder_widget.dart';
import 'package:stacked/stacked.dart';

import '../../../../app/locator.dart';
import '../../../../config/color_config.dart';
import '../../../widgets/custom_circular_image.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      onViewModelReady: (ProfileViewModel model) async {
        model.getUserData();
      },
      initialiseSpecialViewModelsOnce: true,
        disposeViewModel:false,
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: ColorConfig.lightGreyBackground,
          body: Stack(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: ColorConfig.accentColor,
                  width: 100.horizontal(),
                  height: 60.vertical(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 64),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        const Flexible(
                          flex: 1,
                          child: Text(
                            AppConst.profile,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6),
                          ),
                        ),
                        const Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.settings_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 4.vertical(),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CustomCircularImage(height: 130,width: 130,imageUri: model.profileImage,shouldShowWhiteBorder: true,),
                              Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    //model.changeProfilePicture();
                                  },
                                  elevation: 2.0,
                                  fillColor: const Color(0xff455E6C),
                                  padding: const EdgeInsets.all(12.0),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.vertical(),
                          ),
                          Text(
                            model.userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.6),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.horizontal()),
                            child: Text(
                              model.userStatus,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const ProfileActionHolderWidget(),
                          const SizedBox(
                            height: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => locator<ProfileViewModel>(),
    );
  }
}