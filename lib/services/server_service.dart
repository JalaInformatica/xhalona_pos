import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xhalona_pos/models/server.dart';

class ServerService {
  Future<ServerModel> getData({
    String? SERVER_ID,
    String? CLIENT_ID,
    String? SERVER_NAME,
    String? CLIENT_NAME,
    String? SERVER_KEY,
    String? SERVER_END_POINT,
    String? COMPANY_ID_DEFAULT,
  }) async {
    var header = {
      'User-Agent': 'PostmanRuntime/7.29.4',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive'
    };

    await dotenv.load(fileName: 'assets/env/.env_dev');

    var url = dotenv.env['BASE_URL_KEY'].toString();
    var server = dotenv.env['SERVER_ID'].toString();
    var client = dotenv.env['CLIENT_ID'].toString();
    var pass = dotenv.env['SERVER_PASSWORD'].toString();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var version = dotenv.env['VERSION'].toString();

    prefs.setString('version', version);

    final response = await http.get(
      Uri.parse(
          '${url}?SERVER_ID=${server}&CLIENT_ID=${client}&SERVER_PASSWORD=${pass}'),
      headers: header,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var it = jsonDecode(response.body);
      ServerModel server = ServerModel.fromJson(it);
      await prefs.setString('key', '${server.SERVER_KEY}');
      await prefs.setString('base', '${server.SERVER_END_POINT}');
      await prefs.setString('client', '${server.CLIENT_ID}');
      // getClientKey(server);
      return server;
    } else {
      throw Exception('Gagal');
    }
  }

  Future<GetClientKeyModel> getClientKey({
    String? CLIENT_KEY,
    String? CLIENT_NAME,
    ClientKeyCreateDateModel? CLIENT_KEY_CREATE_DATE,
    String? DATA_DS,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString('key');
    var base_url = prefs.getString('base');
    var url = '${base_url}/SYSMAN/client';
    var client = prefs.getString('client');
    var header = {'SERVER_KEY': '${key}'};
    var body = jsonEncode({
      "rqClientGetKey": {"CLIENT_ID": "${client}"}
    });
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: body,
    );
    if (response.statusCode == 200) {
      var it = jsonDecode(response.body);
      GetClientKeyModel clientkey = GetClientKeyModel.fromJson(it);
      await prefs.setString('clientkey', '${clientkey.CLIENT_KEY}');
      await prefs.setString('datads', '${clientkey.DATA_DS}');
      return clientkey;
    } else {
      throw Exception('Gagal');
    }
  }
}