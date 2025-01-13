import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/authentication/login/login_provider.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/home_provider.dart';
import 'package:xhalona_pos/views/launcher/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          ResponsiveScreen.init(context, designSize: const Size(390, 844));
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'GoogleSans',
            ),
            debugShowCheckedModeBanner: false,
            builder: FlutterSmartDialog.init(),
            home: SplashScreen(),
          );
      },
    );
  }
}

