import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';

Widget transactionFilterButton({
  required String text, 
  required VoidCallback onPressed,
  required bool isSelected
  }) {
  return AppElevatedButton(
    backgroundColor: isSelected? AppColor.primaryColor : AppColor.whiteColor,
    foregroundColor: isSelected? AppColor.whiteColor : AppColor.primaryColor,
    onPressed: onPressed,
    text: Text(text, style: AppTextStyle.textBodyStyle(),)
  );
}
