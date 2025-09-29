import 'dart:convert';

import 'package:flutter_widgets/core/models/response/response_code.dart';
import 'package:flutter_widgets/core/models/response/response_model.dart';
import 'package:flutter_widgets/core/utils/identifier_manager.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:xhalona_pos/globals/server/models/client_key_response.dart';
import 'package:xhalona_pos/globals/server/models/server_info_response.dart';

import '../services/server_service.dart';

class ServerRepository {
  final ServerService _serverService = ServerService();

  Future<ResponseModel<bool>> getServerInfo() async {
    try {
      var result = await _serverService.getServerInfo();
      var data = jsonDecode(result);
      var serverInfo = ServerInfoResponse.fromJson(data);
      var ipAddress = await IpAddress().getIpAddress();

      await IdentifierManager.saveServerInfo(
        serverKey: serverInfo.serverKey, 
        serverEndPoint: serverInfo.serverEndPoint, 
        clientId: serverInfo.clientId, 
        ip: ipAddress
      );

      return ResponseModel.success(data: true);
    } on IpAddressException catch (exception) {
      return ResponseModel.exception(resultMessage: exception.message);
    } catch(e){
      return ResponseModel.exception(resultMessage: e.toString());
    }
  }

  Future<ResponseModel<bool>> getClientKey() async {
    try {
      var result = await _serverService.getClientKey();
      var data = jsonDecode(result);
      var clientKey = ClientKeyResponse.fromJson(data);

      await IdentifierManager.saveClientInfo(
        clientKey: clientKey.clientKey,
        dataDs: clientKey.dataDS
      );

      return ResponseModel.success(data: true);
    }
    catch(e) {
      return ResponseModel.exception(resultMessage: e.toString());
    }
  }
}