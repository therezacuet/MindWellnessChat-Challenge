import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../config/color_config.dart';
import '../chat_view_model.dart';

class AppbarWidget extends ViewModelWidget<ChatViewModel> {
  const AppbarWidget({super.key}) : super(reactive: false);

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(
            viewModel.userDataBasicModel.name,
            style: TextStyle(color: ColorConfig.primaryColor, fontSize: 15, letterSpacing: 0.4, fontWeight: FontWeight.w700),
          ),
        ),
        StreamBuilder<String>(
          stream: viewModel.listenForUserActivityStatus(),
          initialData: "",
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return snapshot.data != ""
                ? Text(
              snapshot.data.toString(),
              style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 1,
                  color: ColorConfig.backgroundGray,
                  fontWeight: FontWeight.w400),
            )
                : Container(height: 0);
          },
        ),
      ],
    );
  }
}