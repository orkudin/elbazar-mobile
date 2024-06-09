import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/models/cart_model.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import '../../provider/products_repo_provider.dart';

final getCartProducts = FutureProvider<List<CartItem>>((ref) async {
  final customerRepository = ref.watch(customerApiClientProvider);
  final authState = ref.watch(authStateProvider);
  return customerRepository.fetchCartItems(jwtToken: authState.token);
});

final deleteItemCart =
    FutureProvider.family<void, int>((ref, cartItemId) async {
  final customerRepository = ref.watch(customerApiClientProvider);
  final authState = ref.watch(authStateProvider);
  return customerRepository.deleteCartItem(
      jwtToken: authState.token, cartItemId: cartItemId);
});

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartScreen> {
  Future<void> _refreshCartProducts() async {
    await ref.refresh(getCartProducts.future);
  }

  @override
  Widget build(BuildContext context) {
    final getCustomerCart = ref.watch(getCartProducts);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: getCustomerCart.when(
        data: (products) {
          return RefreshIndicator(
            onRefresh: _refreshCartProducts,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(item.product.name),
                    subtitle: Text(item.product.category.name),
                    // trailing: Text('${item.quantity} x \$${item.product.price} = \$${item.totalPrice}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          // Trigger the delete operation
                          await ref.read(deleteItemCart(item.id).future);

                          // Refresh the cart items to update the UI after deletion
                          ref.refresh(getCartProducts);
                        } catch (e) {
                          // Show an error if the deletion fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete item: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    isThreeLine: true,
                    leading: CircleAvatar(
                      child: Text(item.product.quantity.toString()),
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stackTrace) {
          print('Error: $error');
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
