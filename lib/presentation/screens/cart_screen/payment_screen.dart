import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_number_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../provider/auth_provider.dart';
import '../../provider/products_repo_provider.dart';
import 'cart_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  PaymentScreen({super.key});

  @override
  ConsumerState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isCardCreditWidgetVisisble = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final selectedToBuyItems = ref.watch(selectedToBuyItemsProvider);

    return ListView(children: [
      CreditCardWidget(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        showBackView: isCvvFocused,
        onCreditCardWidgetChange: (CreditCardBrand brand) {},
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    inputFormatters: [CreditCardNumberInputFormatter()],
                    onChanged: (value) {
                      setState(() {
                        cardNumber = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Expired Card'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [CreditCardExpirationDateFormatter()],
                    onChanged: (value) {
                      setState(() {
                        expiryDate = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [CreditCardCvcInputFormatter()],
                    onChanged: (value) {
                      setState(() {
                        cvvCode = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Card Holder'),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          for (var items in selectedToBuyItems) {
                            debugPrint('selectedToBuyItems id: ${items}');

                            await ref.watch(customerApiClientProvider).postOrder(
                                  jwt: ref.read(authStateProvider).token,
                                  selectedItems: items,
                                );
                            debugPrint(
                                'selectedToBuyItems cart_id: ${items['cart_id']}');
                            await ref
                                .read(customerApiClientProvider)
                                .deleteCartItem(
                                    jwtToken: ref.read(authStateProvider).token,
                                    cartItemId: items['cart_id']);
                            // await ref.read(customerApiClientProvider).deleteCartItem(jwtToken: ref.read(authStateProvider).token, cartItemId: cartItemId)
                            debugPrint(
                                'selectedToBuyItems id: ${items['product_id']}');
                          }
                          ref.read(selectedToBuyItemsProvider.notifier).state =
                              [];
                          ref.refresh(getCartProducts);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Thank you for purchasing')),
                          );
                          Navigator.pop(context);
                        } on Exception catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to submit order: $e')),
                          );
                        }
                      },
                      child: Text('Pay')),
                ),
                SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back to cart'),
                )
              ],
            )
          ],
        ),
      )
    ]);
  }
}
