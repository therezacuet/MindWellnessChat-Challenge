import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../../app/routes/style_config.dart';
import '../../../../config/color_config.dart';
import '../../../widgets/custom_button.dart';
import '../../auth_view_model.dart';

class BottomSheetWidget extends HookViewModelWidget<AuthViewModel> {
  const BottomSheetWidget({super.key});

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();

  @override
  Widget buildViewModelWidget(BuildContext context, AuthViewModel model) {
    var userNameTextController = useTextEditingController(text: model.userName);
    var phoneNumberController = useTextEditingController();
    userNameTextController.addListener(
          () {
        String inputText = userNameTextController.text;
        model.setUserName(inputText);
      },
    );

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16, top: 18, bottom: 0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  children: [
                    Text(
                      model.isSignUpScreen ?  Strings.signUp: Strings.login,
                      style: h1Title.copyWith(
                          fontSize: 30,
                          color: ColorConfig.accentColor,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      Strings.signUpPlaceholder,
                      style: h5Title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            switchInCurve: Curves.easeInCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0.5, 0.0),
                                    end: const Offset(0.0, 0.0),
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: model.isSignUpScreen
                                ? Padding(
                              padding:
                              const EdgeInsets.only(bottom: 16.0),
                              child: FadeInAnimation(
                                duration: model.previousNumber == ""
                                    ? const Duration(seconds: 1)
                                    : const Duration(seconds: 0),
                                child: Form(
                                  key: model.formKey,
                                  child: TextFormField(
                                    controller: userNameTextController,
                                    validator: (text) {
                                      if (text == null ||
                                          text.length < 2) {
                                        return Strings.nameValidationMessage;
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xffE3E3E3),
                                        hintText: Strings.nameInputHint,
                                        contentPadding: EdgeInsets.only(
                                            left: 26.0,
                                            bottom: 20.0,
                                            top: 20.0),
                                        border: InputBorder.none),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ),
                          InternationalPhoneNumberInput(
                              textFieldController: phoneNumberController,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              validator: (value) {},
                              onInputChanged: (number) {
                                phoneNumberController.selection =
                                    TextSelection.collapsed(
                                        offset:
                                        phoneNumberController.text.length);
                                if (number.phoneNumber != null) {
                                  model.setPhoneNumber(number.phoneNumber!);
                                }
                                model.setCountryAndDialCode(
                                    number.isoCode!, number.dialCode!);
                              },
                              initialValue: PhoneNumber(
                                  dialCode: model.selectedDialCode,
                                  isoCode: model.selectedIsoCode,
                                  phoneNumber: model.phoneNumber),
                              formatInput: true,
                              // ignoreBlank: false,
                              selectorConfig: const SelectorConfig(
                                  trailingSpace: true,
                                  selectorType:
                                  PhoneInputSelectorType.BOTTOM_SHEET,
                                  setSelectorButtonAsPrefixIcon: true,
                                  leadingPadding: 20),
                              inputDecoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffE3E3E3),
                                hintText: Strings.phoneInputHint,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 16.0, top: 20.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              )),
                        ],
                      ),
                    ),
                    model.errorText != ""
                        ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 38.0, top: 6),
                        child: Text(model.errorText,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4)),
                      ),
                    )
                        : Container(),
                    const SizedBox(
                      height: 26,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CustomButton(
                        Strings.sendOtp,
                        buttonPressed: () {
                          bool isSignUpScreen = model.isSignUpScreen;
                          isSignUpScreen
                              ? model.formKey.currentState!.validate()
                              : null;
                          String enteredPhoneNumber = model.phoneNumber;

                          if (enteredPhoneNumber.isEmpty) {
                            model.setErrorText(Strings.phoneEmptyValidationMessage);
                          } else if (enteredPhoneNumber.length < 10) {
                            model.setErrorText(Strings.phoneInvalidMessage);
                          } else {
                            if (isSignUpScreen ? model.formKey.currentState!.validate() : true) {
                              model.sendOtp();
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        model.toggleSignUpScreen();
                      },
                      child: Text(
                        model.isSignUpScreen
                            ? Strings.loginHint
                            : Strings.signUpHint,
                        style: const TextStyle(letterSpacing: 0.6),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                  duration: const Duration(milliseconds: 800),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: model.previousNumber == "" ? 80.0 : 0,
                    child: FadeInAnimation(
                      duration: model.previousNumber == ""
                          ? null
                          : const Duration(milliseconds: 30),
                      child: widget,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
