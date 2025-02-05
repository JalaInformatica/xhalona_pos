import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class CheckoutScreen extends StatelessWidget{
  final int brutoVal;
  final int discVal;
  final int nettoVal;

  CheckoutScreen({
    required this.brutoVal,
    required this.discVal,
    required this.nettoVal
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Checkout", style: AppTextStyle.textTitleStyle(color: AppColor.primaryColor),),
            SizedBox(height: 5.h,),
            Text("Ringkasan Tagihan", style: AppTextStyle.textSubtitleStyle(),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Tagihan: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
              Text(formatToRupiah(brutoVal), style: AppTextStyle.textBodyStyle(),),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Diskon: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
              Text(formatToRupiah(discVal), style: AppTextStyle.textBodyStyle(),),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text("Tagihan: ", style: AppTextStyle.textBodyStyle(color: AppColor.grey500),),
              Text(formatToRupiah(nettoVal), style: AppTextStyle.textBodyStyle(),),
            ],),
          SizedBox(height: 10.h,),
          Text("Pembayaran", style: AppTextStyle.textSubtitleStyle(),),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Text("Tunai: ", style: AppTextStyle.textBodyStyle(),)
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],), 
          SizedBox(height: 5.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: DropdownButton<String>(
                value: "Non-tunai",
                items: [
                  DropdownMenuItem(
                    value: "Non-tunai",
                    child: Text(
                      "Non-tunai", style: AppTextStyle.textBodyStyle(),
                    )
                  ),
                  DropdownMenuItem(
                    value: "QRIZ",
                    child: Text(
                      "QRIZ", style: AppTextStyle.textBodyStyle(),
                    )
                  ),
                ], 
                onChanged: (v){})
              ),
              Expanded(
                flex: 2,
                child:AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],), 
          SizedBox(height: 5.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: DropdownButton<String>(
                value: "Non-tunai",
                items: [
                  DropdownMenuItem(
                    value: "Non-tunai",
                    child: Text(
                      "Non-tunai", style: AppTextStyle.textBodyStyle(),
                    )
                  ),
                  DropdownMenuItem(
                    value: "QRIZ",
                    child: Text(
                      "QRIZ", style: AppTextStyle.textBodyStyle(),
                    )
                  ),
                ], 
                onChanged: (v){})
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],), 
          SizedBox(height: 5.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Text("Komplimen: ", style: AppTextStyle.textBodyStyle(),)
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],),
          SizedBox(height: 10.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Text("Hutang: ", style: AppTextStyle.textBodyStyle(),)
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],),
          SizedBox(height: 10.h),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text("Total: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(top: 5.h),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide())
                  ),
                  child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: formatThousands(nettoVal.toString()), textAlign: TextAlign.right,))),
          ],),
          SizedBox(height:10.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text("Kembalian: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],),
          SizedBox(height: 10.h,),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text("Titipan: ", style: AppTextStyle.textBodyStyle(fontWeight: FontWeight.bold),))
              ),
              Expanded(
                flex: 2,
                child: AppTextField(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  context: context, hintText: "0", textAlign: TextAlign.right,)),
          ],),
          SizedBox(height: 10.h,),

            SizedBox(
            width: double.infinity,
            child: AppElevatedButton(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: AppColor.whiteColor,
              onPressed: (){}, 
              text: Text("Checkout", style: AppTextStyle.textSubtitleStyle(),)),
          )
        ],
      ))
    ));
  }
  
}