import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widgets/widget/app_text_form_field.dart';
import 'package:flutter_widgets/widget/app_loading_button.dart';
import 'package:flutter_widgets/widget/app_clickable_text.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import '../viewmodels/sign_in_view_model.dart';

class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInViewModelProvider);
    final notifier = ref.read(signInViewModelProvider.notifier);

    return SafeArea(
      child: Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              color: AppColor.primaryColor,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/logo-only-pink.svg',
                    height: 280,
                    width: 280,
                    color: AppColor.whiteColor,
                  ),
                  Text(
                    "Xhalona",
                    style: AppTextStyle.textXlStyle(color: AppColor.whiteColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SvgPicture.asset(
                    'assets/logo_text.svg',
                    color: AppColor.whiteColor,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),            
            ),
              Form(
              key: notifier.formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTextFormField(
                      context: context,
                      textEditingController: notifier.companyController,
                      validator: (value) {
                        if (value == '') {
                          return "Kode Salon harus diisi";
                        }
                        return null;
                      },
                      labelText: "Kode Salon",
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextFormField(
                      context: context,
                      textEditingController: notifier.phoneController,
                      validator: (value) {
                        if (value == '') {
                          return "Nama Pengguna harus diisi";
                        }
                        return null;
                      },
                      labelText: "Nama Pengguna",
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppTextFormField(
                      context: context,
                      textEditingController: notifier.passController,
                      suffixIcon: AppIconButton(
                        onPressed: (){}, 
                        icon: Icon(
                        state.isHidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),),
                      obscureText: state.isHidePassword,
                      validator: (value) {
                        if (value == '') {
                          return "Password harus diisi!";
                        }
                        return null;
                      },
                      labelText: "Password",
                      inputAction: TextInputAction.send,
                      onFieldSubmitted: (_) async {
                        await notifier.handleSignIn(
                          userId: notifier.phoneController.text,
                          password: notifier.passController.text,
                          companyId: notifier.companyController.text,
                          context: context
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/forget-password');
                        },
                        child: Text(
                          "Lupa Password",
                          style:
                              AppTextStyle.textNStyle(color: AppColor.grey500),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppLoadingButton(
                        isLoading: state.isLoading,
                        onPressed: () async {
                          await notifier.handleSignIn(
                            userId: notifier.phoneController.text,
                            password: notifier.passController.text,
                            companyId: notifier.companyController.text,
                            context: context
                          );
                        },
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        size: AppLoadingButtonSize.big,
                        child: Text(
                          "Masuk",
                          style: AppTextStyle.textMdStyle(),
                        ),
                      )
                    ),
                    SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text("Atau",
                            style: AppTextStyle.textNStyle()),
                        AppClickableText(
                          onPressed: () {
                            launchUrl(Uri.parse('https://xhalona.com'));
                          },
                          child: Text(
                            "Daftarkan Salonmu",
                            style: AppTextStyle.textNStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.secondaryColor
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
        ])
        ,
      ),
    ));
  }
}
