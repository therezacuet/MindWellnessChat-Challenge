import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_wellness_chat/const/images.dart';

class CustomCircularImage extends StatelessWidget {
  double width;
  double height;
  String? imageUri;
  bool shouldShowWhiteBorder = false;

  CustomCircularImage(
      {Key? key, required this.width, required this.height, this.imageUri,this.shouldShowWhiteBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: imageUri == null
          ? SvgPicture.asset(
              Images.userPlaceholder,
              fit: BoxFit.cover,
            )
          : CircleAvatar(
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: (width/2) -  (shouldShowWhiteBorder ? 3 : 0),
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                  imageUri!,
                ),
              ),
            ),
    );
  }
}
