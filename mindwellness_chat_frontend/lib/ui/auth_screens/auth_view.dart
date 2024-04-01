import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'auth_view_model.dart';
import 'fragments/otp_view.dart';
import 'fragments/phone_view.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
      viewModelBuilder: () => AuthViewModel(),
      fireOnViewModelReadyOnce: true,
      onViewModelReady: (viewModel){
        final formKey = GlobalKey<FormState>();
        viewModel.setKeyForForm(formKey);
      },
      builder: (context, model, child) {
        return PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1000),
            // reverse: model.reverse,
            transitionBuilder: (Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
            child: model.currentIndex == 0 ? PhoneView() : OtpView(),
        );
      },
    );
  }
}