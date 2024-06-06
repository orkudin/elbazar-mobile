// 2. Define the SellerStateNotifier class
import 'package:elbazar_app/domain/model/seller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerStateNotifier extends StateNotifier<SellerState?> {
  SellerStateNotifier() : super(null); // Initially null, no Seller loaded

  void setSeller(SellerState seller) {
    state = seller;
  }

  void clearSeller() {
    state = null;
  }
}

// 3. Create the provider for the Seller state
final sellerStateProvider =
    StateNotifierProvider<SellerStateNotifier, SellerState?>((ref) {
  return SellerStateNotifier();
});
