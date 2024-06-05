import 'package:elbazar_app/data/repository/seller_repository.dart';
import 'package:elbazar_app/presentation/provider/constant_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/network/client_api/seller_api_client.dart';

//Провайдер к внешнему API
final sellerApiClientProvider = Provider<SellerApiClient>((ref) {
  final baseURL = ref.watch(baseURLProvider);
  return SellerApiClient(baseURL: baseURL);
});

//Провайдер к продуктовому провайдеру
final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  final sellerApiClient = ref.watch(sellerApiClientProvider);
  

  return SellerRepository(
      sellerApiClient: sellerApiClient);
});
