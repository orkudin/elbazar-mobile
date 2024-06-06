// 1. Define a StateNotifier to hold your seller data and manage updates
import 'package:elbazar_app/presentation/provider/admin_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerListNotifier extends StateNotifier<List<dynamic>> {
  SellerListNotifier(this.ref, [List<dynamic>? initialSellers])
      : super(initialSellers ?? []);

  final StateNotifierProviderRef<SellerListNotifier, List<dynamic>> ref;

  final int _pageSize = 10;

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await ref.read(adminRepositoryProvider).getSales(
            page: pageKey,
            size: _pageSize,
            sort: 'id',
            order: 'ASC',
            isApproved: true,
          );
      state = [
        ...state,
        ...newItems,
      ];
    } catch (e) {
      print(e);
    }
  }

  void updateSellerApproval(String bin, bool isApproved) {
    // Find the index of the seller to update
    final sellerIndex = state.indexWhere((seller) => seller['bin'] == bin);

    if (sellerIndex != -1) {
      // Create an updated copy of the seller data
      final updatedSeller = {
        ...state[sellerIndex],
        'approved': isApproved,
      };

      // Update the state with the modified seller
      state = [
        ...state.sublist(0, sellerIndex),
        updatedSeller,
        ...state.sublist(sellerIndex + 1),
      ];
    }
  }
}

final sellerListProvider =
    StateNotifierProvider.autoDispose<SellerListNotifier, List<dynamic>>((ref) {
  return SellerListNotifier(ref); // Pass ref to the StateNotifier here
});
