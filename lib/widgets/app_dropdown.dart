import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppTextDropdown<T> extends Container{
  final T value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  AppTextDropdown({
    super.key, 
    required this.value,
    required this.items,
    required this.onChanged
  }) : super(
    decoration: BoxDecoration(
        border: Border.all(color: AppColor.grey500),
        borderRadius: BorderRadius.circular(5)),
    child: DropdownButton<T>(
    value: value,
    dropdownColor: AppColor.whiteColor,
    underline: SizedBox.shrink(),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    elevation: 8,
    isDense: true,
    items: items,
    onChanged: onChanged)
  );
}