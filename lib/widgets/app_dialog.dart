import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppDialog extends AlertDialog {
  AppDialog({
    super.key, 
    super.content,
    super.contentPadding,
    super.contentTextStyle,
    super.title,
    super.titlePadding,
    super.actions,
    super.actionsPadding,
  }) : super(
    backgroundColor: AppColor.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5)
    ),
    titleTextStyle: AppTextStyle.textSubtitleStyle(),
  );
}