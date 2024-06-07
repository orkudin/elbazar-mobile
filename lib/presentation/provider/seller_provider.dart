// 2. Define the SellerStateNotifier class
import 'package:elbazar_app/data/network/entity/seller_entity.dart';
import 'package:elbazar_app/domain/model/seller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerStateNotifier extends StateNotifier<SellerEntity?> {
  SellerStateNotifier() : super(null); // Initially null, no Seller loaded

  void setSeller(SellerEntity seller) {
    state = seller;
  }

  void clearSeller() {
    state = null;
  }
}

// 3. Create the provider for the Seller state
final sellerStateProvider =
    StateNotifierProvider<SellerStateNotifier, SellerEntity?>((ref) {
  return SellerStateNotifier();
});
