import 'package:elbazar_app/presentation/screens/profile_screen/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/order_model/order_entity.dart';

class OrderScreenStatus extends ConsumerWidget {
  const OrderScreenStatus(
      {super.key, required this.statusList, required this.orders});

  final StatusList statusList;
  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(statusList.toString()),
      ),
      body: orders.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Card(
                  child: ListTile(
                    title: Text('Order ID: ${order.orderid}'),
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
            )
          : Center(
              child: Text('There is no ${statusList.toString()} products'),
            ),
    );
  }
}
