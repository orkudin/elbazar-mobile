import 'package:elbazar_app/data/models/product_with_images_model.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/widgets/card_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsWithImagesProvider =
    FutureProvider<List<ProductWithImages>>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return sellerRepository.getSellerOwnProducts(
    jwt: authState.token,
    page: 0,
    size: 10,
    sort: 'id',
    order: 'ASC',
  );
});

class SellerProducts extends ConsumerWidget {
  const SellerProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsyncGetProducts = ref.watch(productsWithImagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: responseAsyncGetProducts.when(
        data: (products) => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 4,
              mainAxisSpacing: 20,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return CardProductItem(
                product: product,
                fromScreen: 'from_my_products_screen',
              );
            }),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
