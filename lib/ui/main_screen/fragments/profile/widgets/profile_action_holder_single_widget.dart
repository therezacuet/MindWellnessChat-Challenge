import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileActionHolderSingleWidget extends StatelessWidget {
  Color backgroundColor = const Color(0xff47AA5A);
  String imagePath = "";
  String title = "";
  Function() onTap;

  ProfileActionHolderSingleWidget(
      {super.key, required this.backgroundColor,
        required this.imagePath,
        required this.title,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(imagePath),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8),
            )
          ],
        ),
      ),
    );
  }
}
