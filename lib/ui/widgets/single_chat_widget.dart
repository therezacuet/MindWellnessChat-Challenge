import 'package:flutter/material.dart';
import 'package:mind_wellness_chat/utils/extensions/string_extension.dart';

import '../../config/color_config.dart';
import 'custom_circular_image.dart';

class SingleChatWidget extends StatelessWidget {
  Function chatClickCallback;
  String name;
  String description;
  String? time;
  String? compressedProfileImage;
  int? unreadMessage;

  SingleChatWidget({
    super.key,
    required this.name,
    required this.description,
    required this.compressedProfileImage,
    required this.chatClickCallback,
    this.time,
    this.unreadMessage = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6,bottom: 6,left: 4),
      child: ListTile(
        focusColor:Colors.grey,
        onTap: (){
          chatClickCallback();
        },
        leading: CustomCircularImage(
          width: 54,
          height: 54,
          imageUri: compressedProfileImage,
        ),
        title: Text(
          name.capitalize(),
          style: const TextStyle(
              height: 1,
              fontSize: 16,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
         description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1,
              color: Colors.black38,
              fontWeight: FontWeight.w400),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            time != null ? Text(
              time!,
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.4,
                  color: Colors.black38,
                  fontWeight: FontWeight.w500),
            ):const SizedBox(width: 0,height: 0,),
            const SizedBox(
              height: 4,
            ),
            unreadMessage == 0 || unreadMessage == null ? const SizedBox(
              width: 0,
              height: 0,
            ):Container(
              alignment: Alignment.center,
              height: 21,
              width: 21,
              decoration: BoxDecoration(
                color: ColorConfig.accentColor,
                shape: BoxShape.circle,
              ),
              child:  Text(
                unreadMessage.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.4,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
