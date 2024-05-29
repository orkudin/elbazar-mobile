import 'package:elbazar_app/data/repository/products_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:elbazar_app/data/network/client/api_client.dart';
import 'package:elbazar_app/data/network/network_mapper.dart';

// Providers for ApiClient dependencies
final baseURLProvider = Provider<String>((ref) => 'https://daurendan.ru/');
final apiKeyProvider = Provider<String>((ref) => 'your_api_key_here');
final apiHostProvider = Provider<String>((ref) => 'api.example.com');

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseURL = ref.watch(baseURLProvider);
  final apiKey = ref.watch(apiKeyProvider);
  final apiHost = ref.watch(apiHostProvider);

  return ApiClient(baseURL: baseURL, apiKey: apiKey, apiHost: apiHost);
});

// Provider for NetworkMapper dependency
final loggerProvider = Provider<Logger>((ref) => Logger());

final networkMapperProvider = Provider<NetworkMapper>((ref) {
  final logger = ref.watch(loggerProvider);
  return NetworkMapper(log: logger);
});

// Provider for ProductsRepository
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkMapper = ref.watch(networkMapperProvider);

  return ProductsRepository(apiclient: apiClient, networkMapper: networkMapper);
});
