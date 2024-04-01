import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';

import '../../../../../app/routes/style_config.dart';
import '../../../../../config/color_config.dart';

class StartSearchingWidget extends StatelessWidget {
  const StartSearchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: 34,right: 34,top: 8.vertical()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 40.horizontal(),
              height: 26.vertical(),
              child: SvgPicture.asset(Images.startSearching)),
          Text(
            Strings.startSearching,
            style: h1Title.copyWith(fontSize: 24, letterSpacing: 0.6),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            Strings.searchingHint,
            style: h4Title.copyWith(fontSize: 14, letterSpacing: 0.6,color: ColorConfig.greyColor3),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 2.vertical(),
          ),
        ],
      ),
    );
  }
}
