import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppRadioText<T> extends GestureDetector {
  AppRadioText({
    required String text,
    required T value,
    required T groupValue,
    required Function(T?) onChanged
  }):super(
    onTap: () {
      onChanged(value);
    },
    child: Row(
      children: [
        Radio(
          activeColor: AppColor.primaryColor,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: value, 
          groupValue: groupValue, 
          onChanged: onChanged
        ),
        Text(text, style: AppTextStyle.textBodyStyle(),)
      ]
    )
  );
}