import 'package:elbazar_app/data/datasources/client_api/customer_api_client.dart';
import 'package:elbazar_app/data/repository/customer_repository.dart';
import 'package:elbazar_app/data/repository/seller_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/datasources/client_api/seller_api_client.dart';

import '../../config/app_constants.dart';

//Провайдер к внешнему API
final sellerApiClientProvider = Provider<SellerApiClient>((ref) {
  return SellerApiClient(baseURL: AppConstants.baseUrl);
});

//Провайдер к продуктовому провайдеру
final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  final sellerApiClient = ref.watch(sellerApiClientProvider);
  return SellerRepository(sellerApiClient: sellerApiClient);
});

//Провайдер к внешнему API
final customerApiClientProvider = Provider<CustomerApiClient>((ref) {
  return CustomerApiClient(baseURL: AppConstants.baseUrl);
});

//Провайдер к продуктовому провайдеру
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final customerApiClient = ref.watch(customerApiClientProvider);
  return CustomerRepository(customerApiClient: customerApiClient);
});
