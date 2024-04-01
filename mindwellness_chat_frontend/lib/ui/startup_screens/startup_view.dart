import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked/stacked.dart';

import '../../app/routes/style_config.dart';
import '../../config/size_config.dart';
import 'startup_view_model.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onViewModelReady: (StartUpViewModel model) {
        SizeConfig().init(context);
        model.runStartupLogic();
      },
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SvgPicture.asset(
                  Images.appLogo,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const SizedBox(height: 50,),
              Text(Strings.appName, style: h1Title,)
            ],
          ),
        );
      },
    );
  }
}