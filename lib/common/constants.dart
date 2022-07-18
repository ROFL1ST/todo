import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kTextColor = Color.fromARGB(255, 0, 0, 0);
const kTextMediumColor = Color(0xFF53627C);
const kTextLightColor = Color(0xFFACB1C0);
const kPrimaryColor = Color(0xFF3A71FF);
const kPrimaryLightColor = Color(0xFFC5D5FF);
const kBackgroundColor = Color(0xFFF9F7F7);
const kInactiveChartColor = Color(0xFFEAECEF);
final kShadowColor = Color(0xFFCDCDCD).withOpacity(.16);
final kActiveShadowColor = Color(0xFF4056C6).withOpacity(.15);
const kTitleSub = Color(0xFF767676);
// priority
const urgent = Color(0xFFFF574C);
const normal = Color(0xFFFFD24C);

const kHeadingTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
);

const kSubTextStyle = TextStyle(fontSize: 16, color: kTextLightColor);

const kTitleTextstyle = TextStyle(
  fontSize: 20,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kTitleTask =
    TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600);

const kTimeTask =
    TextStyle(fontSize: 14, color: kTitleSub, fontWeight: FontWeight.w600);

const kTitleSubStyle = TextStyle(
  fontSize: 15,
  color: kTitleSub,
  fontWeight: FontWeight.bold,
);

const kTextAppBar = TextStyle(
  fontSize: 24,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kTitleAct = TextStyle(
  fontSize: 22,
  color: kTextColor,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.normal,
);

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);
final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  backgroundColor: kDarkSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  backgroundColor: kLightSecondaryColor,
  accentColor: kAccentColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ),
);

// tema warna
const kPerson = Color(0xFFF24E1E);
const kHealthy = Color(0xFF699BF7);
const kWork = Color(0xFF9747FF);
const kFamily = Color(0xFF0FA958);
const kOther = Color(0xFF699BF7);

// dark
const kTextColorDark = Color(0xFFFFFFFF);
const kTextMediumColorDark = Color(0xFF53627C);
const kTextLightColorDark = Color.fromARGB(255, 116, 117, 122);
const kPrimaryColorDark = Color(0xFF3A71FF);
const kPrimaryLightColorDark = Color(0xFFC5D5FF);
const kBackgroundColorDark = Color(0xFF181920);
const kInactiveChartColorDark = Color(0xFFEAECEF);
final kShadowColorDark = Color.fromARGB(255, 158, 158, 158).withOpacity(.16);
final kActiveShadowColorDark = Color(0xFF4056C6).withOpacity(.15);
const kTitleSubDark = Color(0xFF767B83);
const kCardColorDark = Color(0xFF252A34);

const kTitleTextstyleDark = TextStyle(
  fontSize: 20,
  color: kTextColorDark,
  fontWeight: FontWeight.bold,
);

const kTextAppBarDark = TextStyle(
  fontSize: 24,
  color: kTextColorDark,
  fontWeight: FontWeight.bold,
);

const kTitleActDark = TextStyle(
  fontSize: 22,
  color: kTextColorDark,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.normal,
);




