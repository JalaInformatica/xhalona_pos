import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.onTap,
    required BuildContext context,
    super.validator,
    super.onFieldSubmitted,
    super.maxLines,
    super.focusNode,
    super.autofocus,
    bool disabled = false,
    bool readOnly = false,
    TextStyle? style,
    String? hintText,
    String? labelText,
    Color? fillColor,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon,
    bool isScurePass = false,
    TextInputAction? inputAction = TextInputAction.done,
    required TextEditingController textEditingController,
    bool unfocusWhenTapOutside = true,
  }) : super(
      onTapOutside: unfocusWhenTapOutside
          ? (_) {
              FocusScope.of(context).unfocus();
            }
          : null,
      readOnly: disabled || readOnly,
      controller: textEditingController,
      obscureText: isScurePass,
      keyboardType: keyboardType,
      style: style ?? AppTextStyle.textBodyStyle(),
      cursorColor: AppColor.primaryColor,
      textInputAction: inputAction,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: disabled || fillColor !=null,
        fillColor: disabled ? AppColor.grey300 : fillColor,
        labelText: labelText,
        labelStyle: AppTextStyle.textBodyStyle(
          color: AppColor.grey500,
        ),
        floatingLabelStyle:
            AppTextStyle.textBodyStyle(color: AppColor.primaryColor),
        isDense: true,
        hintText: hintText,
        hintStyle: (style ?? AppTextStyle.textBodyStyle()).copyWith(
          color: AppColor.grey500,
        ),
        suffixIcon: suffixIcon,
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
          borderSide: BorderSide(color: !disabled? AppColor.primaryColor : AppColor.grey300),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: AppColor.dangerColor),
        ),
      ));
}
