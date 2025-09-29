import 'package:xhalona_pos/globals/authentication/models/session_response.dart';

class LoginResponse {
  String userId;
  List<SessionResponse> sessionLoginInfo;

  LoginResponse({
    this.userId = "",
    this.sessionLoginInfo = const [],
  });

  LoginResponse.fromJson(Map<String, dynamic> json)
      : userId = json['USER_ID'] ?? "",
        sessionLoginInfo = (json['SESSION_LOGIN_INFO'] as List<dynamic>?)
            ?.map((e) => SessionResponse.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'USER_ID': userId,
      'SESSION_LOGIN_INFO':
          sessionLoginInfo.map((session) => session.toJson()).toList(),
    };
  }
}