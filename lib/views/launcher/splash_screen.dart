import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/services/server_service.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    fetchServerInfo();
    fetchUserInfo();
    checkForUpdate(context);
    super.initState();
  }

  Future<void> fetchServerInfo() async {
    await ServerService().getData();
    await ServerService().getClientKey();
  }

  String currentVersion = "0.0.1";
  String versionUrl = "https://xhalona-pos.vercel.app/api/version";

  Future<void> checkForUpdate(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(versionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String latestVersion = data['version'];

        if (latestVersion != currentVersion) {
          _showUpdateDialog(context);
        }
      }
    } catch (e) {
      print("Error checking update: $e");
    }
  }

  void _showUpdateDialog(BuildContext context) {
    SmartDialog.show(
      builder: (_) => AppDialog(
        shadowColor: AppColor.blackColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Versi baru telah rilis",
              style: AppTextStyle.textSubtitleStyle(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppElevatedButton(
                  backgroundColor: AppColor.grey200,
                  borderColor: AppColor.grey200,
                  foregroundColor: AppColor.blackColor,
                  onPressed: () => SmartDialog.dismiss(),
                  child: Text(
                    "Nanti Aja",
                    style: AppTextStyle.textBodyStyle(),
                  ),
                ),
                AppElevatedButton(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  onPressed: () {
                    SmartDialog.dismiss();
                    _downloadUpdate();
                  },
                  child: Text(
                    "Unduh",
                    style: AppTextStyle.textBodyStyle(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _downloadUpdate() {
    // Open the URL where the new version can be downloaded
    const updateUrl = "https://xhalona-pos.vercel.app";
    launchUrl(Uri.parse(updateUrl));
  }

  Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(LocalStorageConst.userId) != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Center(
          child: SvgPicture.asset("assets/logo-name.svg"),
        ));
  }
}
