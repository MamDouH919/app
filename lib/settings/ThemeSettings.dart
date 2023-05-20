import 'package:flutter/material.dart';

abstract class ThemeSettings {
  static const Color primaryColor = Color(0xff0e1380);
  static const Color lightColor = Color(0xff339dfa);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color headerColor = Colors.black;
  static const Color textColor = Color(0xff2e2626);
  static const Color invertedTextColor = Colors.white;
  static const List<Color> gradientColors = <Color>[
    Color(0xff1C0554),
    Color(0xff0B3377)
  ];
  static const List<Color> lightGradientColors = <Color>[
    Color(0xff32BEA6),
    Color(0xff32BEd8)
  ];
  static const List<Color> gradientGrayColors = <Color>[
    Color(0xff151515),
    Color(0xff2F2F2F)
  ];
  static const List<Color> lightGradientGrayColors = <Color>[
    Color(0xff555555),
    Color(0xff888888)
  ];

  static const double borderRadius = 10;
  static const double smallBorderRadius = 5;
  static const double largeBorderRadius = 30;

  static const double screenPadding = 20;
  static const double standardPadding = 20;
  static const double textPadding = 5;

  static const double fontSmallSize = 8;
  static const double fontMedSize = 12;
  static const double fontNormalSize = 14;
  static const double fontSubHeaderSize = 16;
  static const double fontMedCardSize = 18;
  static const double fontCardSize = 20;
  static const double fontHeaderSize = 24;
  static const double fontMegaHeader = 34;

  static const double tileiconSize = 45;
  static const double indicatorSize = 100;

  static const double buttonWidth = 200;
  static const double buttonHeight = 50;

  static const double iconContainerWidth = 102;
  static const double iconContainerHeight = 102;

  static const Color picksAppBarGradientColor = Color(0xff191A1D);

  static const Color submitBtnColor = Color(0xffD56584);
  static const Color linkColor = Color(0xffCECECE);
  static const Color selectedUserColor = Color(0xff32BEA6);
  static const Color homeAppbarColor = Color(0xffFF8787);
  static const Color breakLineColor = Color(0xffE6E6E6);
  static const Color textFiledColor = Color(0xffeeeeee);
  static const MaterialColor kPrimaryColor = const MaterialColor(
    0xff32BEA6,
    const <int, Color>{
      50: const Color(0xff32BEA6),
      100: const Color(0xff32BEA6),
      200: const Color(0xff32BEA6),
      300: const Color(0xff32BEA6),
      400: const Color(0xff32BEA6),
      500: const Color(0xff32BEA6),
      600: const Color(0xff32BEA6),
      700: const Color(0xff32BEA6),
      800: const Color(0xff32BEA6),
      900: const Color(0xff32BEA6),
    },
  );
  static const Color coursesAppBar = Color(0xffFF7747);
  static const Color nurseryAppBar = Color(0xffF26D5C);
  static const Color registerAppBar = Color(0xff20160E);
  static const Color kidsColor = Color(0xffD56584);
  static const Color yourOpinionColor = Color(0xff51A2FE);
  static const Color cClassColor = Color(0xffA7D163);
  static const Color nClassColor = Color(0xffF26D5C);
  static const Color picChange = Color(0xff040000);
  static const Color bgClassTextColor = Color(0xffFFEEBC);
  static const Color tableColor = Color(0xffF5F5F5);
  static const Color btnBorderColor = Color(0xff61CB3C);
  static const Color indicatorColor = Color(0xffFEFAFB);
  static const Color financialsColor = Color(0xffF1F1F1);
  static const Color messagesHeader = Color(0xff49B279);
  static const Color greyBubble = Color(0xffEAECF2);
}
