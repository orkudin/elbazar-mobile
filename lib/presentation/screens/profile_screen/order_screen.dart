import 'package:elbazar_app/data/network/entity/order_entity.dart'; // Import OrderEntity
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for fetching orders
final ordersProvider = FutureProvider.autoDispose
    .family<List<OrderEntity>, String>((ref, orderFrom) async {
  final authState = ref.watch(authStateProvider);
  final sellerRepository = ref.watch(sellerRepositoryProvider);

  return await sellerRepository.fetchSellerOrders(
      jwt: authState.token, ordersFrom: orderFrom);
});

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final ordersFrom = authState.role == 'SALES' ? 'sales' : 'customer';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ref.watch(ordersProvider(ordersFrom)).when(
            data: (orders) => ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    // title: Text('Order ID: ${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product ID: ${order.productId}'),
                        Text('Quantity: ${order.quantity}'),
                        Text('Price: ${order.price}'),
                        Text('Status: ${order.status}'),
                      ],
                    ),
                  ),
                );
              },
            ),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
