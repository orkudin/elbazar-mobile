import 'package:carousel_slider/carousel_slider.dart';
import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/presentation/screens/widgets/products_detail_screen.dart';
import 'package:elbazar_app/presentation/screens/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardProductItem extends ConsumerWidget {
  const CardProductItem({Key? key, required this.product, this.fromScreen})
      : super(key: key);

  final ProductWithImages product;
  final String? fromScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            _buildProductDetails(context),
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

  Widget _buildProductDetails(BuildContext context) {
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
              product.categoryName == null ? 'null' : product.categoryName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAddToCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Row(children: [
      Expanded(
        child: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart')),
            );
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
