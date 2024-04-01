import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_wellness_chat/const/images.dart';
import 'package:mind_wellness_chat/const/strings.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

import '../../../config/color_config.dart';
import '../../../const/msg_type_const.dart';
import '../chat_view_model.dart';

class MessageSendContainer extends HookViewModelWidget<ChatViewModel> {
  const MessageSendContainer({super.key}) : super(reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, ChatViewModel model) {
    TextEditingController msgSendTextController = useTextEditingController();
    msgSendTextController.addListener(() {
      String inputText = msgSendTextController.text;
      if (inputText.isNotEmpty) {
        model.setSendBtnStatus(false);
      } else {
        model.setSendBtnStatus(true);
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 8,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, right: 16, top: 10, bottom: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showPicker(context, (bool isCameraSelected) {
                  model.checkPermissionAndPickImage(isCameraSelected);
                });
              },
              child: SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(Images.gallery),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                color: Colors.white,
                child: TextField(
                  onChanged: (txt) {
                    model.inputTextChanging();
                  },
                  controller: msgSendTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: Strings.typeHint,
                    contentPadding:
                    EdgeInsets.only(left: 16.0, bottom: 16.0, top: 18.0),
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!model.isSendBtnDisable) {
                  model.sendMessage(inputText: msgSendTextController.text, msgType: MsgType.txt);
                  msgSendTextController.text = "";
                }
              },
              child: SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(Images.send,
                    color: model.isSendBtnDisable
                        ? Colors.grey.shade500
                        : ColorConfig.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showPicker(context, Function callback) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(Strings.photoLibrary),
                  onTap: () {
                    callback(false);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text(Strings.camera),
                onTap: () {
                  callback(true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
}