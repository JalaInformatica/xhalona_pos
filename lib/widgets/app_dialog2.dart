import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppDialog2 extends Dialog {
  AppDialog2({
    super.key,
    EdgeInsets? insetPadding,
    Widget? title,
    Widget? child,
    List<Widget>? actions
  }) : super(
    backgroundColor: AppColor.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Padding(
      padding: insetPadding ?? EdgeInsets.all(20),
      child: Column(
        spacing: 15.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title !=null) title,
          if (child != null) child,
          Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(actions!=null) ...actions
            ],
          )

        ],
      ),
    ),
  );
}
