import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppLayout extends SafeArea {
  AppLayout({
    super.key, 
    required List<Widget> children
  }) : super(
    child: Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: children
      )
    )
  );
}