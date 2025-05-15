import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/launcher/splash_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColor.tertiaryColor, 
    statusBarIconBrightness: Brightness.dark, 
  ));
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
        return GetMaterialApp(
          theme: ThemeData(
            fontFamily: 'GlacialIndifference',
          ),
          debugShowCheckedModeBanner: false,
          builder: FlutterSmartDialog.init(),
          home: SplashScreen(),
        );
      },
    );
  }
}
