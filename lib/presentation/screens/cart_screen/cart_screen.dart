import 'package:elbazar_app/presentation/screens/cart_screen/payment_screen.dart';
import 'package:elbazar_app/presentation/screens/widgets/products_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
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

final selectedToBuyItemsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) => []);

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartScreen> {


  Future<void> _refreshCartProducts() async {
    await ref.refresh(getCartProducts.future);
  }

  // void _showCreditCardWidget(bool isCardCreditWidgetVisisble) {
  //   setState(() {
  //     _isCardCreditWidgetVisisble = isCardCreditWidgetVisisble;
  //   });
  // }

  void _openPayScreenOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => PaymentScreen());
  }

  @override
  Widget build(BuildContext context) {
    final getCustomerCart = ref.watch(getCartProducts);
    final selectedToBuyItems = ref.watch(selectedToBuyItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshCartProducts,
              child: getCustomerCart.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(child: Text('There is no items in cart'));
                  } else {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final item = products[index];
                        return Column(
                          children: [
                            Card(
                              margin: EdgeInsets.all(8),
                              child: ListTile(
                                title: TextButton(
                                  style: ButtonStyle(
                                      alignment: Alignment.centerLeft),
                                  child: Text(
                                    item.product.name,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                productId: item.product.id),
                                      )),
                                ),
                                subtitle: Text(item.product.category.name),
                                // trailing: Text('${item.quantity} x \$${item.product.price} = \$${item.totalPrice}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      // Trigger the delete operation
                                      await ref
                                          .read(deleteItemCart(item.id).future);

                                      // Refresh the cart items to update the UI after deletion
                                      ref.refresh(getCartProducts);
                                    } catch (e) {
                                      // Show an error if the deletion fails
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Failed to delete item: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                isThreeLine: true,
                                leading: CircleAvatar(
                                  child: Text(item.quantity.toString()),
                                ),
                              ),
                            ),
                            CheckboxListTile(
                              value: selectedToBuyItems.any((selectedItem) =>
                                  selectedItem['product_id'] ==
                                  item.product.id),
                              onChanged: (value) {
                                if (value != null && value) {
                                  // Item is checked, add it to the provider
                                  ref
                                      .read(selectedToBuyItemsProvider.notifier)
                                      .state = [
                                    ...selectedToBuyItems,
                                    {
                                      'product_id': item.product.id,
                                      'quantity': item.quantity,
                                      'order_id': item.id,
                                    }
                                  ];
                                } else {
                                  ref
                                      .read(selectedToBuyItemsProvider.notifier)
                                      .state = [
                                    ...selectedToBuyItems
                                        .where((selectedItem) =>
                                            selectedItem['product_id'] !=
                                            item.product.id)
                                        .toList()
                                  ];
                                }
                              },
                              title: Text('Select to buy'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                error: (error, stackTrace) {
                  print('Error: $error');
                  return Center(
                    child: Text('Error: $error'),
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedToBuyItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                _openPayScreenOverlay();
                debugPrint('FloatingActionButton id: ${selectedToBuyItems}');

                try {
                  // for (var items in selectedToBuyItems) {
                  //   debugPrint('selectedToBuyItems id: ${items}');
                  //
                  //   await ref.read(customerApiClientProvider).postOrder(
                  //         jwt: ref.read(authStateProvider).token,
                  //         selectedItems: items,
                  //       );
                  //   debugPrint('selectedToBuyItems id: ${items['product_id']}');
                  // }
                  ref.refresh(getCartProducts);

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Order submitted successfully')),
                  // );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit order: $e')),
                  );
                }
              },
              label: Text('Post Order'),
              icon: Icon(Icons.shopping_cart),
            )
          : null,
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}
