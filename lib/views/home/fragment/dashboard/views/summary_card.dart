import 'package:flutter/material.dart';
import 'package:flutter_widgets/theme/app_color.dart';
import 'package:flutter_widgets/theme/app_text_style.dart';
import 'package:flutter_widgets/widget/app_shimmer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/states/dashboard_state.dart';

Widget renderSummaryCard({Color? color, required Widget child}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: AppColor.whiteColor,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          blurRadius: 1, 
          offset: Offset(0, 1),
          color: AppColor.grey500
        )
      ]
    ),
    child: child
  );
}

Widget renderSummaryTrxToday({required DashboardState state}){
  return renderSummaryCard(
    child: state.trxToday.when(
      error: (e, _){
        return SizedBox();
      },
      loading: (){
        return AppShimmer.list(
          count: 3,
           itemBuilder: (context, i){
            return Container(
              color: AppColor.whiteColor,
              width: double.maxFinite,
              height: 15,
            );
          });
      },
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text("Hari ini", 
              style: AppTextStyle.textNStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor),
            ),
            Text(formatToRupiahShort(number: data.toInt()), style: AppTextStyle.textXsStyle(
              color: AppColor.whiteColor
            ),),
            // Text(
            //   "${.toString()} Transaksi",
            //   style: AppTextStyle.textBodyStyle(color: AppColor.whiteColor),
            // ),
          ]
        );
      }
    )
  );
}

Widget renderSummaryTrxMonth({required DashboardState state}){
  return renderSummaryCard(
    child: state.trxToday.when(
      error: (e, _){
        return SizedBox();
      },
      loading: (){
        return AppShimmer.list(
          count: 3,
           itemBuilder: (context, i){
            return Container(
              color: AppColor.whiteColor,
              width: double.maxFinite,
              height: 15,
            );
          });
      },
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            Text("Hari ini", 
              style: AppTextStyle.textNStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.whiteColor),
            ),
            Text(formatToRupiahShort(number: data.toInt()), style: AppTextStyle.textXsStyle(
              color: AppColor.whiteColor
            ),),
            // Text(
            //   "${.toString()} Transaksi",
            //   style: AppTextStyle.textBodyStyle(color: AppColor.whiteColor),
            // ),
          ]
        );
      }
    )
  );
}