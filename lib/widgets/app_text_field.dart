import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppTextField extends TextField{
  AppTextField({
    required BuildContext context,
    TextStyle? style,
    String? hintText,
    String? labelText,
    Color? fillColor,
    Widget? icon,
    bool isScurePass = false,
    TextInputAction? inputAction = TextInputAction.done,
    required TextEditingController textEditingController,
    EdgeInsets? contentPadding,
  }) : super(
    onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: textEditingController,
      obscureText: isScurePass,
      style: style ?? AppTextStyle.textBodyStyle(),
      cursorColor: AppColor.primaryColor,
      textInputAction: inputAction,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: AppTextStyle.textBodyStyle(
          color: AppColor.grey500,
        ),
        floatingLabelStyle: AppTextStyle.textBodyStyle(
          color: AppColor.primaryColor
        ),
        isDense: true,
        hintText: hintText,
        contentPadding: contentPadding,
        hintStyle: (
          style ?? AppTextStyle.textBodyStyle()).copyWith(
          color: AppColor.grey500,
        ),
        suffixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.grey100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.dangerColor),
        ),
      ));
}