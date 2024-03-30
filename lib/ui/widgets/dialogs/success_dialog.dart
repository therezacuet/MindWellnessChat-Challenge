import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../config/color_config.dart';

class SuccessDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SuccessDialog({super.key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 13, top: 10, right: 13, bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150, //
                        color: Colors.transparent,
                        child: Lottie.asset(Images.successAnimation),
                      ),
                      Text(
                        request.title ?? Strings.success,
                        style: const TextStyle(fontSize: 23),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                          request.description ?? Strings.saveSuccessMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              letterSpacing: 0.8
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            completer(DialogResponse(confirmed: true));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(14)),
                              color: ColorConfig.greenColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Center(
                                  child: Text(
                                    request.mainButtonTitle ?? Strings.ok,
                                    style: const TextStyle(color: Colors.white),
                                  )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
