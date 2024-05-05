import 'package:flutter/material.dart';

const kDeepOrangeAccent = Color(0xffde7254);
const kWhiteCanvas = Color(0xff135D66);
const kGreyColor = Color(0xff8e9aa6);
const radius = 35;

const kOnBoardingMessage = TextStyle(
  fontFamily: 'Kalam',
  fontSize: 20.0,
  color: kGreyColor,
);

textFieldDecor(String text, Widget icon) => InputDecoration(
      hintText: text,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      suffixIcon: icon,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(35),
      ),
    );

const kWelcomeMessage = TextStyle(
  fontFamily: 'Kalam',
  fontSize: 17.0,
);

const kOnBoardingHeading = TextStyle(
  fontFamily: 'Kalam',
  fontSize: 32.0,
  fontWeight: FontWeight.w700,
);

const kHeading = TextStyle(
  fontFamily: 'Kalam',
  fontSize: 24.0,
  fontWeight: FontWeight.w700,
);

const kButton = TextStyle(
  fontFamily: 'Kalam',
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
  color: Color(0xffE3FEF7),
);

const kAppBarShapeStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomRight: Radius.circular(25),
    bottomLeft: Radius.circular(25),
  ),
);
