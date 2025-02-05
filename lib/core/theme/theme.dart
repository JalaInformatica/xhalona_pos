import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color.fromARGB(255, 255, 105, 180);
  static const Color secondaryColor = Color(0xffff6ead);
  static const Color tertiaryColor = Color.fromARGB(255, 255, 241, 248);
  static const Color backgroundColor = Color(0xffF1F1F1);
  static const Color starColor = Color.fromARGB(255, 244, 203, 4);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color grey500 = Colors.grey;
  static const Color grey400 = Color.fromARGB(255, 185, 185, 185);
  static const Color grey200 = Color.fromRGBO(238, 238, 238, 1);
  static const Color grey300 = Color.fromRGBO(224, 224, 224, 1);
  static const Color grey100 = Color.fromRGBO(245, 245, 245, 1);
  static const Color borderImageColor = Color(0xFFF5F5F5);
  static const Color doneColor = Colors.green;
  static const Color blueColor = Colors.blue;
  static const Color purpleColor = Colors.purple;
  static const Color dangerColor = Colors.red;
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
}

// For screen responsivity
class ResponsiveScreen {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _scaleFactor;

  static void init(BuildContext context, {Size? designSize}) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    designSize ??= const Size(390, 844);

    _scaleFactor = _screenWidth / designSize.width;
  }

  static double scaleWidth(double width) {
    return width * _scaleFactor;
  }

  static double scaleHeight(double height) {
    return height * (_screenHeight / 844);
  }

  static double scaleFont(double fontSize) {
    return fontSize * (_screenWidth / 390);
  }
}

extension ResponsiveScreenExtension on num {
  double get w => ResponsiveScreen.scaleWidth(toDouble());
  double get h => ResponsiveScreen.scaleHeight(toDouble());
  double get sp => ResponsiveScreen.scaleFont(toDouble());
}

double titleSize = 18.sp;
double subtitleSize = 15.sp;
double bodySize = 13.sp;
double captionSize = 10.sp;

class AppTextStyle {
  // static TextStyle textHeadlineStyle(
  //     {bool inherit = true,
  //     Color? color,
  //     Color? backgroundColor,
  //     FontStyle? fontStyle,
  //     double? letterSpacing,
  //     double? wordSpacing,
  //     TextBaseline? textBaseline,
  //     double? height,
  //     TextLeadingDistribution? leadingDistribution,
  //     Locale? locale,
  //     Paint? foreground,
  //     Paint? background,
  //     List<Shadow>? shadows,
  //     List<FontFeature>? fontFeatures,
  //     List<FontVariation>? fontVariations,
  //     TextDecoration? decoration,
  //     Color? decorationColor,
  //     TextDecorationStyle? decorationStyle,
  //     double? decorationThickness,
  //     String? debugLabel,
  //     String? fontFamily,
  //     List<String>? fontFamilyFallback,
  //     String? package,
  //     TextOverflow? overflow}) {
  //   double fontSize = 21;
  //   FontWeight fontWeight = FontWeight.w600;

  //   return TextStyle(
  //     inherit: inherit,
  //     color: color,
  //     backgroundColor: backgroundColor,
  //     fontSize: fontSize.sp,
  //     fontWeight: fontWeight,
  //     fontStyle: fontStyle,
  //     letterSpacing: letterSpacing,
  //     wordSpacing: wordSpacing,
  //     textBaseline: textBaseline,
  //     height: height,
  //     leadingDistribution: leadingDistribution,
  //     locale: locale,
  //     foreground: foreground,
  //     background: background,
  //     shadows: shadows,
  //     fontFeatures: fontFeatures,
  //     fontVariations: fontVariations,
  //     decoration: decoration,
  //     decorationColor: decorationColor,
  //     decorationStyle: decorationStyle,
  //     decorationThickness: decorationThickness,
  //     debugLabel: debugLabel,
  //     fontFamily: fontFamily,
  //     fontFamilyFallback: fontFamilyFallback,
  //     package: package,
  //     overflow: overflow,
  //   );
  // }

  static TextStyle textTitleStyle(
      {bool inherit = true,
      Color? color,
      Color? backgroundColor,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      TextLeadingDistribution? leadingDistribution,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      List<FontVariation>? fontVariations,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? debugLabel,
      String? fontFamily,
      List<String>? fontFamilyFallback,
      String? package,
      TextOverflow? overflow = TextOverflow.ellipsis}) {
    double fontSize = titleSize;
    FontWeight fontWeight = FontWeight.bold;

    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: 0,
      wordSpacing: 1,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }

  static TextStyle textSubtitleStyle({
      bool inherit = true,
      Color? color,
      Color? backgroundColor,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      TextLeadingDistribution? leadingDistribution,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      List<FontVariation>? fontVariations,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? debugLabel,
      String? fontFamily,
      List<String>? fontFamilyFallback,
      String? package,
      TextOverflow? overflow = TextOverflow.ellipsis
    }) {
    double fontSize = 15;
    FontWeight fontWeight = FontWeight.w500;

    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: 'GoogleSans',
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }

  static TextStyle textBodyStyle(
      {bool inherit = true,
      Color? color,
      Color? backgroundColor,
      FontWeight? fontWeight = FontWeight.normal,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      TextLeadingDistribution? leadingDistribution,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      List<FontVariation>? fontVariations,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? debugLabel,
      String? fontFamily,
      List<String>? fontFamilyFallback,
      String? package,
      TextOverflow? overflow = TextOverflow.ellipsis}) {
    double fontSize = 13;

    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
      
    );
  }

  static TextStyle textCaptionStyle(
      {bool inherit = true,
      Color? color,
      Color? backgroundColor,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      double? letterSpacing,
      double? wordSpacing,
      TextBaseline? textBaseline,
      double? height,
      TextLeadingDistribution? leadingDistribution,
      Locale? locale,
      Paint? foreground,
      Paint? background,
      List<Shadow>? shadows,
      List<FontFeature>? fontFeatures,
      List<FontVariation>? fontVariations,
      TextDecoration? decoration,
      Color? decorationColor,
      TextDecorationStyle? decorationStyle,
      double? decorationThickness,
      String? debugLabel,
      String? fontFamily,
      List<String>? fontFamilyFallback,
      String? package,
      TextOverflow? overflow = TextOverflow.ellipsis}) {
    double fontSize = 9.5;

    return TextStyle(
      inherit: inherit,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      leadingDistribution: leadingDistribution,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      fontVariations: fontVariations,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      debugLabel: debugLabel,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
      overflow: overflow,
    );
  }
}
