
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
  'hex color must be #rrggbb or #rrggbbaa');
  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color buttonColor = hexToColor('#378C5C');
  static Color bottomBarColor = hexToColor('#0091C4');
  static Color buttonTextColor = Colors.white;
  static Color secondaryAppColor = hexToColor('#5E92F3');
  static Color secondaryDarkAppColor = Colors.white;
}




class ButtonConstants {
  static ButtonStyle forgotPassword =ButtonStyle(textStyle: MaterialStateProperty.
  all(GoogleFonts.montserrat(fontSize: 14,fontWeight: FontWeight.w600)),
      foregroundColor: MaterialStateProperty.all(const Color(0xff087DC0)));
}


class TextConstants {
  static TextStyle brownText =GoogleFonts.montserrat(
      color: const Color(0XFF696969),
      fontSize: 14,
      fontWeight: FontWeight.w600
  );
  static TextStyle brownTextFoodDonation =GoogleFonts.montserrat(
      color: const Color(0XFF696969),
      fontSize: 16,
      fontWeight: FontWeight.w500
  );

  static TextStyle signUpBrownText =GoogleFonts.montserrat(
      color: const Color(0XFF696969),
      fontSize: 10,
      fontWeight: FontWeight.normal
  );
  static TextStyle signupText =GoogleFonts.montserrat(
      color: const Color(0Xff087DC0),
      fontSize: 13,
      fontWeight: FontWeight.bold
  );

  static TextStyle pageTittle =GoogleFonts.montserrat(
      color: const Color(0Xff0091C4),
      fontSize: 24,
      fontWeight: FontWeight.w700
  );
  static TextStyle foodRequestTittle =GoogleFonts.montserrat(
      color: const Color(0Xff0091C4),
      fontSize: 22,
      fontWeight: FontWeight.w600
  );
  static TextStyle foodRequestCardText =GoogleFonts.montserrat(
      color:  Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600
  );
  static TextStyle foodRequestCardSmallText =GoogleFonts.montserrat(
      color:  Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.w600
  );
  static TextStyle foodRequestCardViewDetails =GoogleFonts.montserrat(
      color:  Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w700
  );

  static TextStyle foodRequestPhotosText =GoogleFonts.montserrat(fontSize: 14,color:const Color(0xFF003E69),fontWeight: FontWeight.w600 );

}
