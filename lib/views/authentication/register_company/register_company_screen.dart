import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/models/dao/authentication.dart';
import 'package:xhalona_pos/widgets/app_loading_button.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/views/authentication/login/login_screen.dart';
import 'package:xhalona_pos/repositories/authentication/authentication_repository.dart';

class RegisterCompanyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterCompanyScreen();
}

class _RegisterCompanyScreen extends State<RegisterCompanyScreen> {
  TextEditingController userIdController = TextEditingController(text: '');
  TextEditingController storeIdController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  bool isLoading = false;
  bool isScurePass = true;
  final _formkey = GlobalKey<FormState>();

  Widget tooglePass() {
    return IconButton(
      onPressed: () {
        setState(() {
          isScurePass = !isScurePass;
        });
      },
      icon: isScurePass
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  void handleLogin() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      LoginDAO login = await AuthenticationRepository().getLoginInfo(
          storeId: storeIdController.text,
          userId: userIdController.text,
          password: passwordController.text);
      if (login.companyId != "") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // print(login.companyId);
        prefs.setString(LocalStorageConst.userId, login.userId);
        prefs.setString(LocalStorageConst.userName, login.userName);
        prefs.setString(LocalStorageConst.ip, login.loginIpFrom);
        prefs.setString(LocalStorageConst.companyId, login.companyId);
        prefs.setString(LocalStorageConst.defCompanyId, login.defCompanyId);
        prefs.setString(LocalStorageConst.sessionLoginId, login.sessionLoginId);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ListView(
        children: [
          SizedBox(height: 10.h,),
          Center(
            child: Text("Daftarkan Salon",
              style: AppTextStyle.textTitleStyle()),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("Deskripsi Salon", style: AppTextStyle.textSubtitleStyle(),),
                  SizedBox(height: 10.h,),
                  AppTextFormField(
                    context: context,
                    textEditingController: storeIdController,
                    validator: (value) {
                      if (value == '') {
                        return "Nama Salon harus diisi";
                      }
                      return null;
                    },
                    labelText: "Nama Salon*",
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextFormField(
                    context: context,
                    textEditingController: userIdController,
                    validator: (value) {
                      if (value == '') {
                        return "Nama Pengguna harus diisi";
                      }
                      return null;
                    },
                    labelText: "Alamat Salon",
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppTextFormField(
                    context: context,
                    textEditingController: passwordController,
                    // icon: tooglePass(),
                    isScurePass: isScurePass,
                    validator: (value) {
                      if (value == '') {
                        return "Password harus diisi!";
                      }
                      return null;
                    },
                    labelText: "Deskripsi",
                    inputAction: TextInputAction.next,
                    // onFieldSubmitted: (_) {
                    //   handleLogin();
                    // },
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Navigator.pushNamed(context, '/forget-password');
                  //     },
                  //     child: Text(
                  //       "Lupa Password",
                  //       style:
                  //           AppTextStyle.textBodyStyle(color: AppColor.grey500),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10.h,),
                  SizedBox(
                      width: double.infinity,
                      child: AppLoadingButton(
                        isLoading: isLoading,
                        onPressed: handleLogin,
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        size: AppLoadingButtonSize.big,
                        text: Text(
                          "Daftar",
                          style: AppTextStyle.textSubtitleStyle(),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah Punya Akun?",
                          style: AppTextStyle.textBodyStyle()),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                        },
                        child: Text(
                          "Masuk",
                          style: AppTextStyle.textBodyStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.blackColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
