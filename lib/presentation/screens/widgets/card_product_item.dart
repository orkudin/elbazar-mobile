import 'package:carousel_slider/carousel_slider.dart';
import 'package:elbazar_app/data/models/product_with_images_model.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/screens/widgets/products_detail_screen.dart';
import 'package:elbazar_app/presentation/screens/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/categories_provider.dart';
import '../../provider/products_repo_provider.dart';
import '../cart_screen/cart_screen.dart';

final getCategoriesProvider = FutureProvider<dynamic>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  return sellerRepository.getCategoriesList();
});

final addCartItem = FutureProvider.family<void, int>((ref, productId) async {
  final customerRepository = ref.read(customerRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return customerRepository.addToCart(
      jwt: authState.token, productId: productId, quantity: 1);
});

class CardProductItem extends ConsumerWidget {
  const CardProductItem({Key? key, required this.product, this.fromScreen})
      : super(key: key);

  final ProductWithImages product;
  final String? fromScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.read(categoriesProvider);

    String? categoryName = product.categoryName;
    if (categoryName == null) {
      for (var category in categories) {
        categoryName = category.getNameFromId(product.categoryId);
        if (categoryName.isNotEmpty) break;
      }
    }

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
                productId: product.id, fromScreen: fromScreen),
          ),
        ),
        child: Column(
          children: [
            _buildImageSlider(),
            _buildProductDetails(context, categoryName!, ref, product.id),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Expanded(
      flex: 2,
      child: ImageSlider(
        imagesBytes: product.images,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          height: double.infinity,
          viewportFraction: 1,
        ),
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context, String categoryName, WidgetRef ref, int productId) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${product.price.toStringAsFixed(2)} T",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              categoryName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAddToCartButton(context, ref, productId),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(
      BuildContext context, WidgetRef ref, int productId) {
    return Row(children: [
      Expanded(
        child: IconButton(
          onPressed: () async {
            try {
              // Trigger the delete operation
              await ref.read(addCartItem(productId).future);

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
            // ScaffoldMessenger.of(context).clearSnackBars();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Product added to cart')),
            // );
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: const Icon(Icons.shopping_cart),
          ),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 219, 219, 42))),
        ),
      ),
    ]);
  }
}
