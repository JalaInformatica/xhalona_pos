import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widgets/core/utils/app_navigator.dart';
import 'package:flutter_widgets/core/utils/identifier_manager.dart';
import 'package:flutter_widgets/core/viewmodels/viewmodel_handler.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';

import '../repositories/sign_in_repository.dart';
import '../states/sign_in_state.dart';

final signInViewModelProvider = StateNotifierProvider<SignInViewModel, SignInState>((ref) {
  return SignInViewModel(SignInRepository());
});

class SignInViewModel extends StateNotifier<SignInState> {
  final SignInRepository repository;
  SignInViewModel(this.repository):super(SignInState());

  final phoneController = TextEditingController();
  final passController = TextEditingController();
  final companyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    state = state.copyWith(isHidePassword: !state.isHidePassword);
  }

  Future<void> handleSignIn({
    required String userId,
    required String password,
    required String companyId,
    required BuildContext context
  }) async {
    if (!formKey.currentState!.validate()) return;
    await ViewModelHandler.appTryAsync(execute: () async {
      state = state.copyWith(isLoading: true);
      final loginInfo = await repository.loginWeb(
        userId: userId, password: password, companyId: companyId
      );
      ViewModelHandler.handleResponseCode(
        loginInfo, 
        onSuccess: (data){
          IdentifierManager.saveAuthenticationInfo(
            userId: data.userId,
            sessionLoginId: data.sessionLoginInfo.first.sessionLoginId
          );
          state = state.copyWith(isLoading: false);
          if(context.mounted){
            AppNavigator.navigatePushRemove(context, HomePage());
          }
        }, 
        onError: (msg){
          throw(msg);
        });
    },
    onError: (){
      state = state.copyWith(isLoading: false);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    passController.dispose();
    super.dispose();
  }
}
