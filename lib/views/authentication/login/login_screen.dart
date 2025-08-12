import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/models/dao/authentication.dart';
import 'package:xhalona_pos/core/constant/local_storage.dart';
import 'package:xhalona_pos/repositories/authentication/authentication_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
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
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppTextFormField(
                    context: context,
                    textEditingController: storeIdController,
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
                    textEditingController: userIdController,
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
                    textEditingController: passwordController,
                    suffixIcon: tooglePass(),
                    obscureText: isScurePass,
                    validator: (value) {
                      if (value == '') {
                        return "Password harus diisi!";
                      }
                      return null;
                    },
                    labelText: "Password",
                    inputAction: TextInputAction.send,
                    onFieldSubmitted: (_) {
                      handleLogin();
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
                        isLoading: isLoading,
                        onPressed: handleLogin,
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        size: AppLoadingButtonSize.big,
                        child: Text(
                          "Masuk",
                          style: AppTextStyle.textMdStyle(),
                        ),
                      )),
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
        ],
      ),
    );
  }
}
