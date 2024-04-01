import 'package:flutter/material.dart';

import '../../config/color_config.dart';

TextStyle h1Title = const TextStyle(fontWeight: FontWeight.w700, fontSize: 28);

TextStyle h2Title = const TextStyle(fontWeight: FontWeight.w600, fontSize: 22);

TextStyle h3Title = const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black87,
    fontSize: 20,
    letterSpacing: 0.4);

TextStyle h4Title = const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black54,
    fontSize: 16,
    letterSpacing: 0.4);

TextStyle h5Title = const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black54,
    fontSize: 14,
    letterSpacing: 0.4);

InputDecoration textFieldDecoration = const InputDecoration(
  contentPadding: EdgeInsets.only(bottom: 0),
  focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
);

InputDecoration filledTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(6.0),
  ),
    filled: true,
    fillColor: ColorConfig.textFieldBackground,
    contentPadding: const EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 15),
);
