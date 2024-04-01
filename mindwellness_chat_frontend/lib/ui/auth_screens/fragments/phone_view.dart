import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/ui/auth_screens/fragments/widgets/bottom_sheet_widget.dart';
import 'package:stacked/stacked.dart';
import '../../../config/color_config.dart';
import '../auth_view_model.dart';

class PhoneView extends ViewModelWidget<AuthViewModel> {
  const PhoneView({super.key});

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget build(BuildContext context, AuthViewModel viewModel) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: ColorConfig.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: SizedBox(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: SvgPicture.asset(
                            Images.authImage,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const BottomSheetWidget(),
                        Container(
                          height: 10,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}