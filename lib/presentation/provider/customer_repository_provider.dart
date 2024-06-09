import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/app_constants.dart';
import '../../data/datasources/client_api/customer_api_client.dart';
import '../../data/repository/customer_repository.dart';
import 'auth_provider.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final customerApiClient = CustomerApiClient(
    baseURL: AppConstants.baseUrl,
  );
  return CustomerRepository(customerApiClient: customerApiClient);
});
