import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/authentication.dart';
import 'package:xhalona_pos/repositories/authentication/authentication_repository.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/views/authentication/register_company/register_company_screen.dart';
import 'package:xhalona_pos/views/authentication/register_user/register_user_screen.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_loading_button.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';

class RegisterMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterMainScreen();
}

class _RegisterMainScreen extends State<RegisterMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        spacing: 10.h,
        children: [
          SvgPicture.asset(
            'assets/logo-only-pink.svg',
            height: 280,
            width: 280,
            color: AppColor.primaryColor,
          ),
          Center(
            child: Text(
              "Xhalona",
              style: AppTextStyle.textTitleStyle(),
            ),
          ),
          SvgPicture.asset(
            'assets/logo_text.svg',
          ),
          const SizedBox(
            height: 30,
          ),
          Text("Selamat bergabung bersama Xhalona",
              style: AppTextStyle.textSubtitleStyle()),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.maxFinite,
              child: AppElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegisterCompanyScreen()));
                  }, text: Text("Daftarkan Salon"))),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.maxFinite,
              child: AppElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegisterUserScreen()));  
                  }, text: Text("Daftar Sebagai Karyawan Salon"))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sudah Punya Akun?", style: AppTextStyle.textBodyStyle()),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Masuk",
                  style: AppTextStyle.textBodyStyle(
                      fontWeight: FontWeight.bold, color: AppColor.blackColor),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
