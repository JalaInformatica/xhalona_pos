import 'dart:convert';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AppRepository {
  List getResponseMemberInfo(String response) {
    var result = jsonDecode(response)["rsMemberInfo"];
    if (result['RESULT_CODE'].toString().contains("01")) {
      try {
        List data = result['DATA'] ?? [];
        return data;
      } catch (e) {
        return [];
      }
    } else {
      print(result);
      SmartDialog.showToast(
          result['MESSAGE'] ??
              'Gagal, silahkan coba kembali setelah beberapa saat',
          displayTime: Duration(seconds: 5));
      throw Exception();
    }
  }

  List getMenuList(String response) {
    var result = jsonDecode(response)["rsMenuList"];
    if (result['RESULT_CODE'].toString().contains("01")) {
      try {
        var dataApplication = result['DATA_APPLICATION'][0];
        print(dataApplication);
        var dataModule = dataApplication['DATA_MODULE'][0];
        print(dataModule);
        List dataMenu = dataModule["DATA_MENU"]; 
        print(dataMenu);
        return dataMenu;
      } catch (e) {
        SmartDialog.showToast(
          'Gagal, silahkan coba kembali setelah beberapa saat',
          displayTime: Duration(seconds: 5),
        );
        throw Exception();
      }
    } else {
      SmartDialog.showToast(
        result['MESSAGE'] ??
            'Gagal, silahkan coba kembali setelah beberapa saat',
        displayTime: Duration(seconds: 5),
      );
      throw Exception();
    }
  }

  List getUserLoginInfo(String response) {
    var result = jsonDecode(response)["rsLogin"];
    if (result['RESULT_CODE'].toString().contains("01")) {
      try {
        List data = List.from(result['SESSION_LOGIN_INFO'] ?? []);
        var userId = result['USER_ID'];

        for (var session in data) {
          session['USER_ID'] = userId;
        }

        return data;
      } catch (e) {
        return [];
      }
    } else {
      SmartDialog.showToast(
        result['MESSAGE'] ??
            'Gagal, silahkan coba kembali setelah beberapa saat',
        displayTime: Duration(seconds: 5),
      );
      throw Exception();
    }
  }

  List getResponseListData(String response) {
    var result = jsonDecode(response)["rs"];
    if (result['RESULT_CODE'].toString().contains("01")) {
      try {
        List data = result['DATA'] ?? [];
        return data;
      } catch (e) {
        return [];
      }
    } else {
      print(result);
      SmartDialog.showToast(
          result['MESSAGE'] ??
              'Gagal, silahkan coba kembali setelah beberapa saat',
          displayTime: Duration(seconds: 5));
      throw Exception();
    }
  }
  // 081144024410

  List getResponseTrxData(String response) {
    var result = jsonDecode(response)["rs"];
    print(result);
    List rawdata = [];
    if (result is List) {
      rawdata = result;
    } else if (result.containsKey('DATA') && result['DATA'] is List) {
      rawdata = result['DATA'];
    }
    List sendData = [];
    for (var item in rawdata) {
      if (item['RESULT_CODE'].toString().contains("01")) {
        sendData.add(item);
      } else {
        SmartDialog.showToast(
            item['RESULT_MESSAGE'] ??
                'Gagal, silahkan coba kembali setelah beberapa saat',
            displayTime: Duration(seconds: 5));
      }
    }
    return sendData;
  }
}
