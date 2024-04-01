import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../config/color_config.dart';
import '../../../const/strings.dart';
import '../custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ConfirmationDialog({super.key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16, bottom: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                request.title ?? Strings.confirmationTitle,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Text(
                  request.description ?? Strings.confirmationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: Colors.black38),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      Strings.no,
                      backgroundColor: ColorConfig.backgroundColor,
                      textColor: Colors.black,
                      height: 42,
                      fontSize: 16,
                      buttonPressed: () {
                        completer(DialogResponse(confirmed: false));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      Strings.confirm,
                      backgroundColor: ColorConfig.accentColor,
                      height: 42,
                      fontSize: 16,
                      buttonPressed: () {
                        completer(DialogResponse(confirmed: true));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
