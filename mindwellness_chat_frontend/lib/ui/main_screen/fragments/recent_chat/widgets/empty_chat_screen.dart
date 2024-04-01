import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mind_wellness_chat/config/size_config.dart';
import 'package:mind_wellness_chat/const/images.dart';
import '../../../../../app/routes/style_config.dart';
import '../../../../../const/strings.dart';
import '../../../../widgets/custom_button.dart';

class EmptyChatScreen extends StatelessWidget {

  Function buttonPressedCallBack;
  EmptyChatScreen({super.key,required this.buttonPressedCallBack,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0,right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 16.vertical(),
          ),
          SvgPicture.asset(Images.noConversation),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 3.vertical(),
          ),
          Text(Strings.emptyChatMsgTitle,style: h1Title.copyWith(
              fontSize: 22
          ),),
          const SizedBox(
            height: 18,
          ),
          Text(Strings.emptyChatMsgSubTitle,style: h4Title,textAlign: TextAlign.center,),
          SizedBox(
            height: 3.vertical(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CustomButton(Strings.emptyChatButtonLabel,height: 50,buttonPressed: buttonPressedCallBack),
          )
        ],
      ),
    );
  }
}
