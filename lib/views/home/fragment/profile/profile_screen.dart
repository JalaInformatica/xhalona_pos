import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xhalona_pos/services/user/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_controller.dart';
import 'package:xhalona_pos/views/home/fragment/profile/ubah%20profile/editname_page.dart';
import 'package:xhalona_pos/views/home/fragment/profile/ubah%20profile/editemail_page.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: controller.isProfileLoading.value
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10.h,
                      children: [
                        AppTextField(
                          labelText: "Nama",
                          readOnly: true,
                          context: context,
                          hintText: controller.profileData.value.userName,
                          style: AppTextStyle.textBodyStyle(color: AppColor.blackColor),
                        ),
                        AppTextField(
                          labelText: "No. HP",
                          readOnly: true,
                          context: context,
                          hintText: controller.profileData.value.phoneNumber1,
                          style: AppTextStyle.textBodyStyle(color: AppColor.blackColor),
                        ),
                        AppTextField(
                          labelText: "Email",
                          readOnly: true,
                          context: context,
                          hintText: controller.profileData.value.emailAddress,
                          style: AppTextStyle.textBodyStyle(color: AppColor.blackColor),
                        ),
                        AppTextField(
                          labelText: "Alamat",
                          readOnly: true,
                          context: context,
                          hintText: controller.profileData.value.profileAddress,
                          style: AppTextStyle.textBodyStyle(color: AppColor.blackColor),
                        ),
                      ]),
                ),
              ));
  }
}
