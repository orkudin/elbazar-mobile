import 'package:elbazar_app/data/network/client_api/admin_api_client.dart';
import 'package:elbazar_app/data/repository/admin_repository.dart';
import 'package:elbazar_app/data/repository/seller_repository.dart';
import 'package:elbazar_app/config/global_providers/base_provider.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/network/client_api/seller_api_client.dart';

//Провайдер к внешнему API
final adminApiClientProvider = Provider<AdminApiClient>((ref) {
  final baseURL = ref.watch(baseURLProvider);
  final authState = ref.watch(authStateProvider);
  return AdminApiClient(baseURL: baseURL, token: authState.token);
});

//Провайдер к продуктовому провайдеру
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final adminApiClient = ref.watch(adminApiClientProvider);

  return AdminRepository(adminApiClient: adminApiClient);
});
