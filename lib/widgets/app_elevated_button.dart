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
    VoidCallback? onPressedValidation,
    IconData? icon,
    required Widget child, 
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
        onPressed: !disabled? onPressed : onPressedValidation ?? (){},
        child: icon==null? child : Row(
          children: [
            Icon(icon, color: foregroundColor,),
            child,
          ],
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: !disabled? foregroundColor ?? AppColor.primaryColor : AppColor.grey400,
          backgroundColor: !disabled? backgroundColor ?? Colors.white : AppColor.grey200,
          visualDensity: size==AppElevatedButtonSize.small? VisualDensity.compact : VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(5),
            side: BorderSide(color: !disabled? borderColor ?? AppColor.primaryColor : AppColor.grey400),
          ),
          elevation: elevation
        ),
      );
}

