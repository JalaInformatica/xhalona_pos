import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widgets/core/errors/error_page.dart';
import 'package:flutter_widgets/core/utils/app_navigator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/authentication/signin/views/sign_in_page.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/views/splash/viewmodels/splash_view_model.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() async {
        final isAuth = await ref.read(splashViewModelProvider).isAuthenticated();
        if (context.mounted) {
          isAuth.when(
            data: (auth){
              if(auth){
                AppNavigator.navigatePushRemove(context, HomePage());
              } else {
                AppNavigator.navigatePushRemove(context, SignInPage());
              }
            }, 
            error: (err, st){
              AppNavigator.navigatePush(context, ErrorPage(title: "Terjadi kesalahan", reloadPage: SplashPage()));
            }, 
            loading: (){

            }
          );        
        }
      });
      return null;
    }, []);
    
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10.h,
          children: [
            SvgPicture.asset(
            "assets/logo-only-pink.svg",
            width: 250,
            height: 250,
            color: AppColor.primaryColor,
            ),
            Text("XHALONA", style: AppTextStyle.textTitleStyle().copyWith(fontSize: 30),),
            Text("Point Of Sales", style: AppTextStyle.textBodyStyle().copyWith(fontSize: 20),)
          ],
        )));
  }
}
