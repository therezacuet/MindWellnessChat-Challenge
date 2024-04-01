import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:mind_wellness_chat/ui/backup_found_screen/backup_found_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../app/routes/style_config.dart';
import '../../config/color_config.dart';

class BackUpFoundScreen extends StatelessWidget {
   const BackUpFoundScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BackupFoundViewModel>.nonReactive(
      onViewModelReady: (viewModel){
        viewModel.downloadBackUpData();
      },
      builder: (BuildContext context, BackupFoundViewModel model,
          Widget? child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16.vertical(),
                ),
                Container(
                  height: 260, //
                  color: Colors.transparent,
                  child: Lottie.asset(Images.backupFoundAnimation,fit:BoxFit.cover),
                ),
                Text(
                  Strings.lookingForBackup,
                  style: h1Title.copyWith(fontSize: 22),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Strings.lookingForBackupHint,
                  style: h4Title.copyWith(color: ColorConfig.greyColor3,fontSize: 15,letterSpacing: 0.8),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 3.vertical(),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => BackupFoundViewModel(),
    );
  }
}
