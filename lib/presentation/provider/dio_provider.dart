import 'package:dio/dio.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  // Add an interceptor to include the authorization token in each request

  final _dio = Dio()
    ..options.baseUrl = 'https://daurendan.ru/api'
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Retrieve the current token from the auth state
        final authState = ref.read(authStateProvider);
        if (authState.isAuthenticated) {
          options.headers['Authorization'] = 'Bearer ${authState.token}';
        }
        return handler.next(options);
      },
    ));

  return _dio;
});
