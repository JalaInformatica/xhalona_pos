import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';

class AppFormLayout extends Stack{
  AppFormLayout({
    required List<Widget>fields,
    required Function() onCancel,
    required Function() onSubmit
  }) : super(
    children: [
      SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: Column(
            spacing: 15.h,
            children: fields,
        )
      ),
      Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          spacing: 5.w,
          children: [
            Expanded(
              child: AppElevatedButton(
                borderColor: AppColor.transparentColor,
                backgroundColor: AppColor.grey500,
                foregroundColor: AppColor.whiteColor,
                onPressed: onCancel, 
                child: Text("Batal", style: AppTextStyle.textSubtitleStyle())
            )),
            Expanded(
              child: AppElevatedButton(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: AppColor.whiteColor,
                onPressed: onSubmit, 
                child: Text("Simpan", style: AppTextStyle.textSubtitleStyle(),)
            ))
          ],
        )
      )
    ]
  );
}