import 'package:flutter/material.dart';

class AppCheckbox extends Checkbox{
  const AppCheckbox({
    super.key, 
    required super.value, 
    required super.onChanged,
  }) : super(
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}