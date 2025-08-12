import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppTextDropdown<T> extends Container{
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final Color? backgroundColor;
  final Color? borderColor;

  AppTextDropdown({
    super.key, 
    required this.value,
    required this.items,
    required this.onChanged,
    this.backgroundColor,
    this.borderColor
  }) : super(
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: backgroundColor ?? AppColor.whiteColor,
      border: Border.all(color: borderColor ?? AppColor.grey300),
      borderRadius: BorderRadius.circular(5)
    ),
    child: DropdownButton<T>(
    value: value,
    dropdownColor: AppColor.whiteColor,
    underline: SizedBox.shrink(),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    elevation: 2,
    isDense: true,
    items: items,
    onChanged: onChanged)
  );
}