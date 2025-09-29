import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xhalona_pos/views/splash/splash_screen.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/theme.dart' as theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  AppColor.initialize(
    primaryColor: Color.fromARGB(255, 255, 105, 180),
    secondaryColor: Color(0xFFFF94CA),
    tertiaryColor: Color.fromARGB(255, 255, 241, 248)
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark, 
    statusBarColor: AppColor.whiteColor
  ));

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        theme.ResponsiveScreen.init(context, designSize: const Size(390, 844));
        return GetMaterialApp(
          theme: ThemeData(
            fontFamily: 'Arial',
            
          ),
          debugShowCheckedModeBanner: false,
          builder: FlutterSmartDialog.init(),
          home: SplashPage(),
        );
      },
    );
  }
}
