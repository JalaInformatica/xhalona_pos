import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class AppLoadingIndicator extends SizedBox{
  AppLoadingIndicator({
    double size = 12,
    double strokerSize = 2,
    Color? color
  }):super.square(
    dimension: size,
    child: CircularProgressIndicator(
      color: color ?? AppColor.primaryColor,
      strokeWidth: strokerSize,
    )
  );
}