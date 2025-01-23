import 'package:flutter/material.dart';

class AppIconButton extends IconButton {
  final Function() onPressed;
  final Widget icon;
  final OutlinedBorder? shape;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  AppIconButton({
    required this.onPressed,
    required this.icon,
    this.shape,
    this.padding,
    this.backgroundColor,
    this.foregroundColor})
      : super(
          style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: shape,
              padding: padding,
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          onPressed: onPressed,
          icon: icon,
      );
}
