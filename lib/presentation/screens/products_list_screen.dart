import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/widgets/card_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsWithImagesProvider =
    FutureProvider<List<ProductWithImages>>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  return sellerRepository.getAllProductsWithImages(
    page: 0,
    size: 10,
    sort: 'id',
    order: 'ASC',
    isActive: true,
  );
});

class ProductsListScreen extends ConsumerWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

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
              return CardProductItem(product: product);
            }),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
