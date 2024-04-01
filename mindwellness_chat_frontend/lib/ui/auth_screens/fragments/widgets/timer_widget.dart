import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerWidget extends StatelessWidget {
  int timerEndSeconds = 60;
  final Function resendOtpCallback;
  final GlobalKey _key;

  TimerWidget(this.timerEndSeconds, this.resendOtpCallback, this._key,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Countdown(
      key: _key,
      seconds: timerEndSeconds,
      build: (BuildContext context, double time) {
        if (time.toInt() == 0) {
          return GestureDetector(
            onTap: () {
              resendOtpCallback();
            },
            child: const Text(
              Strings.requestAgain,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5),
            ),
          );
        } else {
          return Text(
            "${time.toInt()}S",
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5),
          );
        }
      },
      interval: const Duration(seconds: 1),
      onFinished: () {},
    );
  }
}
