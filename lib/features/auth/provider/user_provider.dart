import 'package:elbazar_app/features/auth/model/token.dart';
import 'package:riverpod/riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, Token?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<Token?> {
  UserNotifier() : super(null);

  void login(String jwt, String role) {
    state = Token(jwt: jwt, role: role);
  }

  void logout() {
    state = null;
  }
}