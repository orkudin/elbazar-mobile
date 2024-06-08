import 'package:elbazar_app/data/models/order_model/order_entity.dart'; // Import OrderEntity
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/order/order_screen_status.dart';
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

enum StatusList {
  CREATED,
  PAID,
  SENT,
  DELIVERED,
  DONE,
  CANCELED_BY_CUSTOMER,
  CANCELED_BY_SALES
}

class SellerOrdersScreen extends ConsumerWidget {
  const SellerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final ordersFrom = authState.role == 'SALES' ? 'sales' : 'customer';
    final List listStatusTitle = [
      'Created',
      'Paid',
      'Sent',
      'Delivered',
      'Done',
      'Canceled by customer',
      'Canceled by sales'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ref.watch(ordersProvider(ordersFrom)).when(
            data: (orders) {
              final createdOrders =
                  orders.where((order) => order.status == 'CREATED').toList();
              final paidOrders =
                  orders.where((order) => order.status == 'PAID').toList();
              final sentOrders =
                  orders.where((order) => order.status == 'SENT').toList();
              final deliveredOrders =
                  orders.where((order) => order.status == 'DELIVERED').toList();
              final doneOrders =
                  orders.where((order) => order.status == 'DONE').toList();
              final canceledByCustomerOrders = orders
                  .where((order) => order.status == 'CANCELED_BY_CUSTOMER')
                  .toList();
              final canceledBySalesOrders = orders
                  .where((order) => order.status == 'CANCELED_BY_SALES')
                  .toList();

              if (authState.role == 'CUSTOMER') {
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Order ID: ${order.orderid}'),
                              Text('Product ID: ${order.productId}'),
                              Text('Quantity: ${order.quantity}'),
                              Text('Price: ${order.price}'),
                              Text('Status: ${order.status}'),
                            ],
                          ),
                        ),
                      );
                    });
              }

              if (authState.role == 'SALES') {
                return ListView(
                  children: [
                    Card(
                        child: ListTile(
                      title: const Text('Created'),
                      trailing: Text('${createdOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.CREATED,
                                orders: createdOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Paid'),
                      trailing: Text('${paidOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.PAID, orders: paidOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Sent'),
                      trailing: Text('${sentOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.SENT, orders: sentOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Delivered'),
                      trailing: Text('${deliveredOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.DELIVERED,
                                orders: deliveredOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Done'),
                      trailing: Text('${doneOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.DONE, orders: doneOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Cancelled by customer'),
                      trailing: Text('${canceledByCustomerOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.CANCELED_BY_CUSTOMER,
                                orders: canceledByCustomerOrders),
                          )),
                    )),
                    Card(
                        child: ListTile(
                      title: const Text('Cancelled by sales'),
                      trailing: Text('${canceledBySalesOrders.length ?? '0'}'),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreenStatus(
                                statusList: StatusList.CANCELED_BY_SALES,
                                orders: canceledBySalesOrders),
                          )),
                    )),
                  ],
                );
              }
            },
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
