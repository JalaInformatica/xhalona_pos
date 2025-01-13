import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

enum AppLoadingButtonSize {
  small,
  big
}

class AppLoadingButton extends TextButton {
  AppLoadingButton({
    super.key, 
    required VoidCallback? onPressed,
    required Widget text, 
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    bool isLoading = false, 
    bool disabled = false,
    AppLoadingButtonSize size = AppLoadingButtonSize.small
  }) : super(
          onPressed: !disabled? onPressed : null,
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foregroundColor ?? AppColor.primaryColor,
                    ),
                  ),
                ),
              text, // Button label
            ],
          ),
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? AppColor.primaryColor,
            backgroundColor: backgroundColor ?? Colors.white,
            visualDensity: size==AppLoadingButtonSize.small? VisualDensity.compact : VisualDensity.standard,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: disabled? AppColor.grey500 : borderColor ?? AppColor.primaryColor),
            ),
          ),
        );
}

