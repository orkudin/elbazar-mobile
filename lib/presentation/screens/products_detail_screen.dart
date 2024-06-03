import 'package:carousel_slider/carousel_options.dart';
import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/presentation/provider/auth_provider.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/edit_product.dart';
import 'package:elbazar_app/presentation/screens/profile_screen/my_products_screen/seller_products.dart';
import 'package:elbazar_app/presentation/screens/widgets/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productWithImagesByIdProvider =
    FutureProvider.family<ProductWithImages, int>((ref, productId) async {
  final sellerApiClient = ref.read(sellerApiClientProvider);
  return await sellerApiClient.getProductWithImagesById(productId: productId);
});

final deleteProductWithImagesByIdProvider =
    FutureProvider.family<void, int>((ref, productId) async {
  final sellerApiClient = ref.read(sellerApiClientProvider);
  final authState = ref.watch(authStateProvider);
  return await sellerApiClient.deleteProduct(
      productId: productId, jwt: authState.token);
});

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({Key? key, required this.productId})
      : super(key: key);

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValueProductById =
        ref.watch(productWithImagesByIdProvider(productId));
    final authState = ref.watch(authStateProvider);

    return asyncValueProductById.when(
      data: (product) => Scaffold(
        appBar: AppBar(
          title: Text(product.name),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSlider(product),
              const SizedBox(height: 14),
              _buildProductInfo(context, product),
              const SizedBox(height: 16),
              _buildDescription(context, product),
               SizedBox(height: 8,),
              _buildActionButtons(context, product, authState.role, ref),
            ],
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }

  Widget _buildImageSlider(ProductWithImages product) {
    return product.images.isNotEmpty
        ? ImageSlider(
            imagesBytes: product.images,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: 300.0,
              viewportFraction: 1,
            ),
          )
        : const SizedBox(
            height: 300.0,
            child: Center(child: Text("No Images Available")),
          );
  }

  Widget _buildProductInfo(BuildContext context, ProductWithImages product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              'Product Code: ${product.id}',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${product.price} T',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Category: ${product.categoryName}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, ProductWithImages product) {
    return product.description != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                product.description!,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildActionButtons(BuildContext context, ProductWithImages product,
      String role, WidgetRef ref) {
    return role == 'SALES'
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProductScreen(productId: product.id),
                          ),
                        );
                      },
                      child: const Text('Edit Product'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this product?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                  
                        if (confirmed == true) {
                          ref
                              .read(deleteProductWithImagesByIdProvider(product.id)
                                  .future)
                              .then((value) =>
                                  ref.invalidate(productsWithImagesProvider))
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product deletion requested'),
                              ),
                            );
                  
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Delete Product'),
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
