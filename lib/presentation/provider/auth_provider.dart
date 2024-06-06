// providers/auth_provider.dart
import 'package:elbazar_app/data/network/client_api/auth_api_client.dart';
import 'package:elbazar_app/data/repository/auth_repository.dart';
import 'package:elbazar_app/config/global_providers/base_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Провайдер к внешнему API авторизации
final authApiClientProvider = Provider<AuthApiClient>((ref) {
  final baseURL = ref.watch(baseURLProvider);
  return AuthApiClient(baseURL: baseURL);
});

//Провайдер к репозиторию авторизации
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiClient = ref.watch(authApiClientProvider);
  return AuthRepository(authApiClient: authApiClient);
});

//Провайдер к слушателю авторизации
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

//Класс слушателя авториазации
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState.unauthenticated());

  void authenticate(String token, String role, dynamic userInfo) {
    state = AuthState.authenticated(token, role, userInfo);
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }
}

//Класс состояния авторизации
class AuthState {
  const AuthState.authenticated(this.token, this.role, this.userInfo) : isAuthenticated = true;
  const AuthState.unauthenticated()
      : isAuthenticated = false,
        token = '',
        role = '',
        userInfo = null;

  final bool isAuthenticated;
  final String token;
  final String role;
  final dynamic userInfo;
}
