import 'package:flutter/material.dart';

class AppNavigator {
  static Future navigatePush(BuildContext context, Widget destination) async {
    return await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>destination));
  }

  static void navigateBack(BuildContext context){
    Navigator.of(context).pop();
  }

  static void navigatePushRemove(BuildContext context, Widget destination){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>destination), (route)=>false);
  }
  
  static Future navigatePushReplace(BuildContext context, Widget destination){
    return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>destination));
  }
}
