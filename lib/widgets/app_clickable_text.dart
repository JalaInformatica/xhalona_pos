import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

enum AppClickableTextSize {
  small,
  big
}

class AppClickableText extends TextButton {
  AppClickableText({
    super.key, 
    required VoidCallback? onPressed,
    required Widget child, 
    IconData? icon,
    Color? foregroundColor,
    bool isLoading = false, 
    bool disabled = false,
    EdgeInsets? padding = EdgeInsets.zero, 
    AppClickableTextSize size = AppClickableTextSize.small,
    Alignment? alignment,
  }) : super(
        onPressed: !disabled? onPressed : null,
        child: icon==null? child : Row(
          spacing: 5.w,
          children: [
            Icon(icon, color: !disabled? foregroundColor ?? AppColor.primaryColor : AppColor.grey400,),
            child,
          ],
        ),
        style: TextButton.styleFrom(
          foregroundColor: !disabled? foregroundColor ?? AppColor.primaryColor : AppColor.grey400,
          backgroundColor: Colors.transparent,
          visualDensity: size == AppClickableTextSize.small? VisualDensity.compact : VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: padding,
          shape: null,
          alignment: alignment
        ),
      );
}