import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../config/color_config.dart';

class LogoutDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const LogoutDialog({super.key, required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(left: 13, top: 13, right: 21, bottom: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.power_settings_new,
                        color: ColorConfig.greyColor2),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      request.title ?? Strings.confirmationTitle,
                      style: TextStyle(
                        fontSize: 21,
                        color: ColorConfig.greyColor2,
                        fontFamily: 'ProximaNova',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  request.description ?? Strings.logoutConfirmationTitle,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontFamily: 'ProximaNova'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      DialogResponse dialogResponse = DialogResponse(confirmed: false);
                      completer(dialogResponse);
                    },
                    child: Text(
                      Strings.no,
                      style: TextStyle(
                          color: ColorConfig.greyColor2, fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        DialogResponse dialogResponse0 = DialogResponse(confirmed: true);
                        completer(dialogResponse0);
                      },
                      child: const Text(
                        Strings.yes,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      )),
                  const SizedBox(
                    width: 17,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
