import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xhalona_pos/services/response_handler.dart';

import '../../../services/app_service.dart';

class ServerService extends XhalonaService {
  Future<String> getServerInfo() async {
    try {
      await dotenv.load(fileName: 'env/.env_dev');
      var url = dotenv.env['BASE_URL_KEY'].toString();
      var server = dotenv.env['SERVER_ID'].toString();
      var client = dotenv.env['CLIENT_ID'].toString();
      var pass = dotenv.env['SERVER_PASSWORD'].toString();

      final response = await getServerInfoRq(
        '$url?SERVER_ID=$server&CLIENT_ID=$client&SERVER_PASSWORD=$pass'
      );

      return ResponseHandler.handle(response);
    }
    catch(e){
      rethrow;
    }
  }

  Future<String> getClientKey() async{
    try{
      final response = await getClientKeyRq();
      return ResponseHandler.handle(response);
    }
    catch(e){
      rethrow;
    }
  }
}