import 'package:hooks_riverpod/hooks_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}