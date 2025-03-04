import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xhalona_pos/views/home/fragment/profile/profile_screen.dart';

class ProfilePageScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            imageProfile(),
            SizedBox(height: 10),
            Text(controller.profileData.value.userName,
                style: AppTextStyle.textTitleStyle(color: Colors.white)),
            Text(controller.profileData.value.emailAddress,
                style: AppTextStyle.textSubtitleStyle(color: Colors.white)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconButton(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()));
                      }, Icons.settings, 'Settings'),
                      _iconButton(
                        () {
                          controller.selectedMenuName.value = "transaksi";
                        },
                        Icons.notifications,
                        'Notification',
                        count: controller.todayTrx.value,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _infoTile(
                      'Tanggal Lahir',
                      controller.profileData.value.profileBirthDate.date.isNotEmpty
                          ? controller.profileData.value.profileBirthDate.date
                          : '-'),
                  _infoTile(
                      'No Handphone',
                      controller.profileData.value.phoneNumber1.isNotEmpty
                          ? controller.profileData.value.phoneNumber1
                          : '-'),
                  _infoTile(
                      'Alamat',
                      controller.profileData.value.profileAddress.isNotEmpty
                          ? controller.profileData.value.profileAddress
                          : '-'),
                  _infoTile(
                      'Kode Pos',
                      controller.profileData.value.profilePostalCode.isNotEmpty
                          ? controller.profileData.value.profilePostalCode
                          : '-'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(Function() onTap, IconData icon, String label,
      {int? count}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.secondaryColor,
                radius: 25,
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              if (count != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.warningColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyle.textSubtitleStyle(),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.textSubtitleStyle()),
          Text(
            value,
            style: AppTextStyle.textTitleStyle(),
          ),
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          controller.profileData.value.profilePic != null &&
                  controller.profileData.value.profilePic.isNotEmpty
              ? Container(
                  width:
                      100, // Ukuran `width` dan `height` harus lebih besar dari `CircleAvatar`
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.primaryColor,
                      width: 4, // Tebal border
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://dreadnought.core-erp.com/XHALONA/${controller.profileData.value.profilePic}',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          child:
                              const Icon(Icons.error, color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  width:
                      100, // Ukuran `width` dan `height` harus lebih besar dari `CircleAvatar`
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4, // Tebal border
                    ),
                  ),
                  child: CircleAvatar(
                    child: Text(
                      controller.profileData.value.userName != null &&
                              controller.profileData.value.userName.isNotEmpty
                          ? controller.profileData.value.userName[0]
                              .toUpperCase()
                          : '?',
                      style:
                          TextStyle(color: Colors.pink.shade800, fontSize: 30),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
