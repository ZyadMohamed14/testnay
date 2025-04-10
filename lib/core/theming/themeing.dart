import 'package:flutter/material.dart';

import '../../utill/dimensions.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Rubik',
  primaryColor: const Color(0xFF3F7268),
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.dark,
  canvasColor:  Color(0xff6904b6),
  cardColor: const Color(0xFF252525),
  hintColor: const Color(0xFFbebebe),
  disabledColor: const Color(0xffa2a7ad),
  shadowColor: Colors.black.withOpacity(0.4),
  indicatorColor: const Color(0xFF1981E0),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white10),

  colorScheme:  const ColorScheme.dark(
    primary: Color(0xFF3F7268),
    secondary: Color(0xff04B200),
    error: Colors.redAccent,
  ),

  textTheme: const TextTheme(
    labelLarge: TextStyle(color: Color(0xFF252525)),

    displayLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeDefault),
    displayMedium: TextStyle(fontWeight: FontWeight.w400, fontSize: Dimensions.fontSizeDefault),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700, fontSize: Dimensions.fontSizeDefault),
    titleLarge: TextStyle(fontWeight: FontWeight.w800, fontSize: Dimensions.fontSizeDefault),
    bodySmall: TextStyle(fontWeight: FontWeight.w900, fontSize: Dimensions.fontSizeDefault),

    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);

ThemeData light = ThemeData(

  fontFamily: 'Rubik',
  canvasColor:  Color(0xffb60404),
  primaryColor: const Color(0xFF3F7268),
  // primaryColor: const Color(0xFFFC6A57),
  //#FF5555
  secondaryHeaderColor: const Color(0xff04B200),
  brightness: Brightness.light,
  cardColor: Colors.white,
  hintColor: const Color(0xFF9F9F9F),
  disabledColor: const Color(0xFFBABFC4),
  shadowColor: Colors.grey[300],
  indicatorColor: const Color(0xFF1981E0),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),

  popupMenuTheme: const PopupMenuThemeData(color: Colors.white, surfaceTintColor: Colors.white),
  dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFFFF5555),
    onPrimary: const Color(0xFFFF5555),
    secondary: const Color(0xff04B200),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white,
    onSurface:  const Color(0xFF002349),
    shadow: Colors.grey[300],
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: Dimensions.fontSizeDefault),
    displayMedium: TextStyle(fontWeight: FontWeight.w400,fontSize: Dimensions.fontSizeDefault),
    displaySmall: TextStyle(fontWeight: FontWeight.w500, fontSize: Dimensions.fontSizeDefault),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: Dimensions.fontSizeDefault),
    headlineSmall: TextStyle(fontWeight: FontWeight.w700,  fontSize: Dimensions.fontSizeDefault),
    titleLarge: TextStyle(fontWeight: FontWeight.w800,  fontSize: Dimensions.fontSizeDefault),
    bodySmall: TextStyle(fontWeight: FontWeight.w900,  fontSize: Dimensions.fontSizeDefault),
    titleMedium: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(fontSize: 12.0),
    bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
  ),
);