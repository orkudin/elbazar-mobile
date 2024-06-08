import 'package:elbazar_app/data/repository/admin_repository.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_constants.dart';
import '../../data/datasources/client_api/admin_api_client.dart';

//Провайдер к внешнему API
final adminApiClientProvider = Provider<AdminApiClient>((ref) {
  final authState = ref.watch(authStateProvider);
  return AdminApiClient(baseURL: AppConstants.baseUrl, token: authState.token);
});

//Провайдер к продуктовому провайдеру
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final adminApiClient = ref.watch(adminApiClientProvider);

  return AdminRepository(adminApiClient: adminApiClient);
});
