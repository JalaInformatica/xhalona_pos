import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog2.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_tile.dart';

class AppDialogList {
  static AppTile defaultActionAppTile({
    required String text,
    required IconData icon,
    required Function() onTap  
  }){
    return AppTile(
      title: Text(text, style: AppTextStyle.textBodyStyle()), 
      trailing: Icon(icon),
      onTap: onTap
    );
  }

  static AppTile editAppTile({
    required Function() onTap
  }){
    return AppTile(
      title: Text("Edit", style: AppTextStyle.textBodyStyle()), 
      trailing: Icon(Icons.edit),
      onTap: onTap
    );
  }
  static AppTile deleteAppTile({
    required Function() onTap
  }){
    return AppTile(
      title: Text("Hapus", style: AppTextStyle.textBodyStyle()), 
      trailing: Icon(Icons.delete),
      onTap: onTap
    );
  }
  static void showListActionsDialog({
    required String title,
    IconData? icon,
    required List<AppTile> actionTiles,
    }){
    SmartDialog.show(
      builder: (_){
        return AppDialog2(
            insetPadding: EdgeInsets.all(5),
            child: SingleChildScrollView(child: Column(
              spacing: 5.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    spacing: 5.w,
                    children: [
                      if(icon!=null)
                      Icon(icon, color: AppColor.primaryColor),
                      Text(title, style: AppTextStyle.textSubtitleStyle(color: AppColor.primaryColor),),
                    ],
                  )
                ),
                ...actionTiles,
              ],
            ),
          )
      );
    });
  }

  static AppTextButton confirmDialogButton({
    String confirmText = "Ya",
    required Function() onPressed,
    Color? foregroundColor,
    Color? backgroundColor,
  }){
    return AppTextButton(
      foregroundColor: foregroundColor ?? AppColor.whiteColor,
      backgroundColor: backgroundColor ?? AppColor.primaryColor,
      onPressed: onPressed, 
      child: Text(confirmText, style: AppTextStyle.textBodyStyle()),
    );
  }

  static AppTextButton cancelDialogButton({
    String confirmText = "Tidak",
    required Function() onPressed,
    Color? foregroundColor,
    Color? backgroundColor,
  }){
    return AppTextButton(
      borderColor: AppColor.transparentColor,
      foregroundColor: foregroundColor ?? AppColor.whiteColor,
      backgroundColor: backgroundColor ?? AppColor.grey500,
      onPressed: onPressed, 
      child: Text(confirmText, style: AppTextStyle.textBodyStyle()),
    );
  }

  static void showConfirmationDialog({
    IconData icon = Icons.warning_amber_rounded,
    required String title, 
    required Function() onConfirm, 
    required Function() onCancel
    }){
    SmartDialog.show(builder: (_){
      return AppDialog2(
        insetPadding: EdgeInsets.all(10),
        actions: [
          cancelDialogButton(onPressed: onCancel),
          confirmDialogButton(onPressed: onConfirm),
        ],
        child: Column(
          children: [
            Icon(icon, color: AppColor.primaryColor,),
            Text(title, style: AppTextStyle.textSubtitleStyle(
              overflow: TextOverflow.visible
            ),)
          ],
        ),
      );
    });
  }

  static void showDeleteConfirmation({
    required String title, 
    required Function() onDelete, 
    required Function() onCancel}) {
    showConfirmationDialog(
      title: title, 
      onConfirm: onDelete, 
      onCancel: onCancel
    );
  }
}