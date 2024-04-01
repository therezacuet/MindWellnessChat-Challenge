import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/const/strings.dart';

import '../../../../../config/color_config.dart';

class ResultCountWidget extends StatelessWidget {
  int totalResultCount = 20;

  ResultCountWidget(this.totalResultCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: totalResultCount.toString(),
              style: TextStyle(
                  color: ColorConfig.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: Strings.searchResultPageTitle,
              style: TextStyle(
                  color: ColorConfig.accentColor,
                  letterSpacing: 0.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 1,
            color: Colors.black38,
            width: 38,
          ),
        )
      ],
    );
  }
}
