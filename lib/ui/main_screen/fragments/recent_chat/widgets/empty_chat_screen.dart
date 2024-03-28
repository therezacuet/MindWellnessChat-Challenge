import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../app/routes/style_config.dart';
import '../../../../widgets/custom_button.dart';

class EmptyChatScreen extends StatelessWidget {

  Function buttonPressedCallBack;
  EmptyChatScreen({Key? key,required this.buttonPressedCallBack,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0,right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           SizedBox(
            height: 24,
          ),
          SvgPicture.asset("assets/images/no_conversation_image.svg"),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 10,
          ),
          Text("No Conversation, yet",style: h1Title.copyWith(
            fontSize: 22
          ),),
          const SizedBox(
            height: 18,
          ),
          Text("Find interesting people by searching them and start the conversation",style: h4Title,textAlign: TextAlign.center,),
          SizedBox(
            height: 24,
          ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 18),
             child: CustomButton("Start Searching",height: 50,buttonPressed: buttonPressedCallBack),
           )
        ],
      ),
    );
  }
}
