import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:mind_wellness_chat/ui/auth_screens/fragments/widgets/timer_widget.dart';
import 'package:stacked/stacked.dart';
import '../../../app/routes/style_config.dart';
import '../../../config/color_config.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/otp_widget.dart';
import '../auth_view_model.dart';

class OtpView extends ViewModelWidget<AuthViewModel> {
  OtpView({super.key});
  final timerKey = GlobalKey();

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget build(BuildContext context, AuthViewModel viewModel) {
    return WillPopScope(
      onWillPop: () async {
        viewModel.setIndex(0);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        viewModel.setIndex(0);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SvgPicture.asset(
                    Images.otpImage,
                    fit: BoxFit.fitHeight,
                    height: 140,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      Text(
                        Strings.otpVerification,
                        style: h1Title,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 20, right: 20),
                        child: Text(
                          Strings.otpVerificationHint,
                          textAlign: TextAlign.center,
                          style:
                              h5Title.copyWith(color: ColorConfig.greyColor3),
                        ),
                      ),
                      const SizedBox(
                        height: 54,
                      ),
                      Text(
                        Strings.otpInputHint,
                        style: h5Title,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      OtpWidget(
                        (value) {
                          viewModel.setOtp(value);
                        },
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.notReceiveOtpCode,
                            style: h5Title.copyWith(letterSpacing: 1.4),
                          ),
                          TimerWidget(viewModel.otpTimeoutSeconds, () {
                          }, timerKey),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                        Strings.verifyOtp,
                        buttonPressed: () {
                          viewModel.submitOtp();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}