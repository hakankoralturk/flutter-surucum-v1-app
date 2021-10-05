import 'package:flutter/material.dart';

class AppConstants {
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale("en", "US");
  static const LANG_PATH = "assets/languages";

  // ignore: non_constant_identifier_names
  static List<Locale> get SUPPORTED_LOCALES => [TR_LOCALE, EN_LOCALE];

  // static const ONBOARD_SVG_01 = "assets/images/svg/container_ship.svg";
  // static const ONBOARD_SVG_02 = "assets/images/svg/location_tracking.svg";
  // static const ONBOARD_SVG_03 = "assets/images/svg/online_transactions.svg";
  static const AKAR_LOGO_LIGHT = "assets/images/svg/akar-logo-light.svg";
  static const AKAR_LOGO_DARK = "assets/images/svg/akar-logo-dark.svg";
  static const ONBOARD_SVG_01 = "assets/images/svg/onboard-1.svg";
  static const ONBOARD_SVG_02 = "assets/images/svg/onboard-2.svg";
  static const ONBOARD_SVG_03 = "assets/images/svg/onboard-3.svg";
}

// class RouteConstants {
//   static const String HOME = "/home";
//   static const String FOLLOWING = "/following";
// }
