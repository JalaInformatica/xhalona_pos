import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppSwitch extends Switch{
  AppSwitch({
    required value, 
    required Function(bool) onChanged
  }):super(
    value: value,
    padding: EdgeInsets.zero,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onChanged: onChanged,
    thumbColor: WidgetStateProperty.all(AppColor.whiteColor),
    inactiveTrackColor: AppColor.grey300,
    activeTrackColor: AppColor.primaryColor,
    trackOutlineColor: WidgetStateProperty.all(AppColor.transparentColor),
  );
}