import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

enum AppElevatedButtonSize {
  small,
  big
}

class AppElevatedButton extends ElevatedButton {
  AppElevatedButton({
    super.key, 
    required VoidCallback? onPressed,
    required Widget text, 
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    bool isLoading = false, 
    bool disabled = false,
    EdgeInsets? padding, 
    AppElevatedButtonSize size = AppElevatedButtonSize.small,
    double? elevation,
    BorderRadius? borderRadius
  }) : super(
        onPressed: !disabled? onPressed : null,
        child: text,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColor.primaryColor,
          backgroundColor: backgroundColor ?? Colors.white,
          visualDensity: size==AppElevatedButtonSize.small? VisualDensity.compact : VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            side: BorderSide(color: disabled? AppColor.grey500 : borderColor ?? AppColor.primaryColor),
          ),
          elevation: elevation
        ),
      );
}

