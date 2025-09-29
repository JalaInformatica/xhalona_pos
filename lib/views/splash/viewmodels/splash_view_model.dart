import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widgets/core/models/response/response_code.dart';
import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:flutter_widgets/core/utils/app_navigator.dart';
import 'package:flutter_widgets/core/utils/identifier_manager.dart';
import 'package:flutter_widgets/core/viewmodels/viewmodel_handler.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:flutter_widgets/widget/app_dialog.dart';
import 'package:flutter_widgets/widget/app_elevated_button.dart';
// import 'package:in_app_update/in_app_update.dart';
import 'package:logger/logger.dart';

import '../repositories/splash_repository.dart';

final splashViewModelProvider = Provider<SplashViewModel>((ref) {
  return SplashViewModel(SplashRepository());
});

class SplashViewModel {
  final SplashRepository repository;

  SplashViewModel(this.repository):super();

  Future<void> checkForUpdate() async {
    try {
      // AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      // if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     showUpdateDialog();
      //   });
      // }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }

  void showUpdateDialog() {
    // SmartDialog.show(
    //   builder: (_) => AppDialog(
    //     title: const Text("Versi baru Xhalon udah rilis, nih"),
    //     actions: [
    //       AppElevatedButton(
    //         backgroundColor: AppColor.grey200,
    //         foregroundColor: AppColor.blackColor,
    //         borderColor: AppColor.transparentColor,
    //         onPressed: () => SmartDialog.dismiss(),
    //         child: Text(
    //           "Nanti Aja",
    //           style: AppTextStyle.textNStyle(),
    //         ),
    //       ),
    //       AppElevatedButton(
    //         backgroundColor: AppColor.primaryColor,
    //         foregroundColor: AppColor.whiteColor,
    //         onPressed: () async {
    //           SmartDialog.dismiss();
    //           await InAppUpdate.performImmediateUpdate();
    //         },
    //         child: Text(
    //           "Update",
    //           style: AppTextStyle.textNStyle(),
    //         ),
    //       ),
    //     ],
    //     child: Text(
    //       "Yuk, Nikmati Fitur Terbarunya",
    //       style: AppTextStyle.textNStyle(),
    //     ),
    //   ),
    // );
  }

  Future<AsyncValue<bool>> isAuthenticated() async {
    try {
      if(IdentifierManager.isAuthenticated()){
        ViewModelHandler.handleResponseCode(
          await repository.getServerInfo(), 
          onSuccess: (_){
          }, 
          onError: (msg){
            throw(msg);
          }
        );
        ViewModelHandler.handleResponseCode(
          await repository.getClientKey(),
          onSuccess: (_){
          },
          onError: (msg){
            throw(msg);
          }
        );
        return const AsyncValue.data(true);
      } else {
        await IdentifierManager.removeAuthenticationInfo();
        ViewModelHandler.handleResponseCode(
          await repository.getServerInfo(), 
          onSuccess: (_){
          }, 
          onError: (msg){
            throw(msg);
          }
        );
        ViewModelHandler.handleResponseCode(
          await repository.getClientKey(),
          onSuccess: (_){
          },
          onError: (msg){
            throw(msg);
          }
        );
        return const AsyncValue.data(false);
      }
    }
    catch(e, st){
      ViewModelHandler.showErrorToast(e.toString());
      Logger().e('${e.toString()}${st.toString()}');
      return AsyncValue.error(e, st);
    }
  }
}
