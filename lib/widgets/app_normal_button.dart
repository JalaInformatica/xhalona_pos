import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

enum AppTextButtonSize {
  small,
  big
}

class AppTextButton extends TextButton {
  AppTextButton({
    super.key, 
    required VoidCallback? onPressed,
    required Widget child, 
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    bool isLoading = false, 
    bool disabled = false,
    EdgeInsets? padding, 
    AppTextButtonSize size = AppTextButtonSize.small,
    Alignment? alignment,
    OutlinedBorder? shape,
  }) : super(
        onPressed: !disabled? onPressed : null,
        child: child,
        style: TextButton.styleFrom(
          foregroundColor: !disabled ? foregroundColor ?? AppColor.primaryColor : AppColor.blackColor,
          backgroundColor: !disabled ? backgroundColor ?? Colors.white : AppColor.grey300,
          visualDensity: size == AppTextButtonSize.small? VisualDensity.compact : VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding,
          shape: shape ?? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: disabled? AppColor.grey500 : borderColor ?? AppColor.primaryColor),
          ),
          alignment: alignment
        ),
      );
}