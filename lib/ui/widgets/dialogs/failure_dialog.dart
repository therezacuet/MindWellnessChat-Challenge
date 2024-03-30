import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../config/color_config.dart';
import '../../../const/strings.dart';

class FailureDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const FailureDialog({super.key, required this.request, required this.completer});

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
                padding:
                const  EdgeInsets.only(left: 13, top: 16, right: 13, bottom: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 130,
                        height: 130, //
                        color: Colors.transparent,
                        child: Lottie.asset(Images.failureAnimation),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        request.title ?? Strings.failure,
                        style: const TextStyle(fontSize: 23),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(request.description ?? Strings.failureMessage,
                          style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
                              color: ColorConfig.redColor,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Center(
                                  child: Text(
                                    Strings.ok,
                                    style: TextStyle(color: Colors.white),
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
