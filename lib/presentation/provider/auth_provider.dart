import 'package:elbazar_app/data/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_constants.dart';
import '../../config/secure_Storage_service.dart';
import '../../data/datasources/client_api/auth_api_client.dart';
import '../../data/models/users_model/user_model.dart';
import '../../main.dart';

//Провайдер к внешнему API авторизации
final authApiClientProvider = Provider<AuthApiClient>((ref) {
  return AuthApiClient(baseURL: AppConstants.baseUrl);
});


//Провайдер к репозиторию авторизации
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiClient = ref.watch(authApiClientProvider);
  return AuthRepository(authApiClient: authApiClient);
});

//Провайдер к слушателю авторизации
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      final secureStorageService = getIt<SecureStorageService>();
  return AuthStateNotifier(secureStorageService: secureStorageService);
});


//Класс слушателя авториазации
class AuthStateNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _secureStorageService;

  AuthStateNotifier({required SecureStorageService secureStorageService}) :
        _secureStorageService = secureStorageService, super(const AuthState.unauthenticated());

  void authenticate(String token, String role, UserModel userInfo) async {
    await _secureStorageService.saveApiToken(token);
    state = AuthState.authenticated(token, role, userInfo);
  }

  void logout() async {
    await _secureStorageService.deleteApiToken();
    state = const AuthState.unauthenticated();
  }

  void updateUserInfo(UserModel newUserInfo) {
    // Update the userInfo in the auth state
    state = AuthState.authenticated(state.token, state.role, newUserInfo);
  }
}


//Класс состояния авторизации
class AuthState {
  const AuthState.authenticated(this.token, this.role, this.userInfo)
      : isAuthenticated = true;
  const AuthState.unauthenticated()
      : isAuthenticated = false,
        token = '',
        role = '',
        userInfo = null;

  final bool isAuthenticated;
  final String token;
  final String role;
  final UserModel? userInfo; // Make userInfo nullable
}
