import 'package:flutter/material.dart';

// Color lPrimaryColor = Color(0xFF4C7CD8);
Color lPrimaryColor = Colors.blue;
Color lSecondaryColor = Color(0xFF59C7F2);
Color lTertiaryColor =Color(0xFF52A2E5);
Color lAuthenticationAppBarColor =Colors.blueAccent;
BorderRadius lBorderRadius = BorderRadius.all(Radius.circular(6));
double lFlatButtonHeight = 60;
const lPaddingFirstContainer =EdgeInsets.symmetric(vertical: 20, horizontal: 30);

const lPageControllerDuration = Duration(milliseconds: 500);
const lPageControllerCurve = Curves.easeOut;
const kHorizontalPadding = 10.0;

const TextStyle lHeadingStyle = TextStyle(
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
);


const lIntroStyle =TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w400,
  fontSize: 18,
);

Widget lLoadingIndicator =Container(
  height: 25,
  width: 25,
  child: CircularProgressIndicator(

    color: Colors.white,
    strokeWidth: 2,
  ),
);

//firebase collection name

const String lPublicEmailPath = "globalEmail";
const String lPublicPhonePath = "globalPhoneNumber";
