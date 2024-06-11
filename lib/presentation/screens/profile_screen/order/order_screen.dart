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

class SellerOrdersScreen extends ConsumerStatefulWidget {
  const SellerOrdersScreen({Key? key}) : super(key: key);

  @override
  _SellerOrdersScreenState createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends ConsumerState<SellerOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final List listStatusTitle = [
      'Created',
      'Paid',
      'Sent',
      'Delivered',
      'Done',
      'Canceled by customer',
      'Canceled by sales'
    ];
    final authState = ref.watch(authStateProvider);
    final ordersFrom = authState.role == 'SALES' ? 'sales' : 'customer';
    Future<void> _refreshOrders() async {
      await ref.refresh(ordersProvider(ordersFrom));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: ref.watch(ordersProvider(ordersFrom)).when(
              data: (orders) {
                final createdOrders =
                    orders.where((order) => order.status == 'CREATED').toList();
                final paidOrders =
                    orders.where((order) => order.status == 'PAID').toList();
                final sentOrders =
                    orders.where((order) => order.status == 'SENT').toList();
                final deliveredOrders = orders
                    .where((order) => order.status == 'DELIVERED')
                    .toList();
                final doneOrders =
                    orders.where((order) => order.status == 'DONE').toList();
                final canceledByCustomerOrders = orders
                    .where((order) => order.status == 'CANCELED_BY_CUSTOMER')
                    .toList();
                final canceledBySalesOrders = orders
                    .where((order) => order.status == 'CANCELED_BY_SALES')
                    .toList();

                if (orders.isEmpty) {
                  return Center(child: Text('There is no orders'));
                }
                else if (authState.isAuthenticated) {
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
                                  statusList: StatusList.PAID,
                                  orders: paidOrders),
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
                                  statusList: StatusList.SENT,
                                  orders: sentOrders),
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
                                  statusList: StatusList.DONE,
                                  orders: doneOrders),
                            )),
                      )),
                      Card(
                          child: ListTile(
                        title: const Text('Cancelled by customer'),
                        trailing:
                            Text('${canceledByCustomerOrders.length ?? '0'}'),
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
                        trailing:
                            Text('${canceledBySalesOrders.length ?? '0'}'),
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
                } else {
                  return Center(child: Text('Log in into account'));
                }
              },
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}
