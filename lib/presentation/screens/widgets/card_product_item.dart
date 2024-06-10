// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:elbazar_app/data/models/product_with_images_model.dart';
// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:elbazar_app/presentation/screens/widgets/products_detail_screen.dart';
// import 'package:elbazar_app/presentation/screens/widgets/image_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../provider/categories_provider.dart';
// import '../../provider/products_repo_provider.dart';
// import '../cart_screen/cart_screen.dart';
//
// final getCategoriesProvider = FutureProvider<dynamic>((ref) async {
//   final sellerRepository = ref.read(sellerRepositoryProvider);
//   return sellerRepository.getCategoriesList();
// });
//
// final addCartItem = FutureProvider.family<void, int>((ref, productId) async {
//   final customerRepository = ref.read(customerRepositoryProvider);
//   final authState = ref.watch(authStateProvider);
//   return customerRepository.addToCart(
//       jwt: authState.token, productId: productId, quantity: 1);
// });
//
// final selectQuantityItem = StateProvider<int>((ref) => 1);
//
// class CardProductItem extends ConsumerWidget {
//   const CardProductItem({Key? key, required this.product, this.fromScreen})
//       : super(key: key);
//
//   final ProductWithImages product;
//   final String? fromScreen;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final categories = ref.read(categoriesProvider);
//
//     String? categoryName = product.categoryName;
//     if (categoryName == null) {
//       for (var category in categories) {
//         categoryName = category.getNameFromId(product.categoryId);
//         if (categoryName.isNotEmpty) break;
//       }
//     }
//
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailScreen(
//                 productId: product.id, fromScreen: fromScreen),
//           ),
//         ),
//         child: Column(
//           children: [
//             _buildImageSlider(),
//             _buildProductDetails(context, categoryName!, ref, product.id),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSlider() {
//     return Expanded(
//       flex: 2,
//       child: ImageSlider(
//         imagesBytes: product.images,
//         options: CarouselOptions(
//           enableInfiniteScroll: false,
//           height: double.infinity,
//           viewportFraction: 1,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductDetails(
//       BuildContext context, String categoryName, WidgetRef ref, int productId) {
//     return Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "${product.price.toStringAsFixed(2)} T",
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               product.name,
//               style: const TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               categoryName,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             _buildAddToCartButton(context, ref, productId),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddToCartButton(
//       BuildContext context, WidgetRef ref, int productId) {
//     return Row(children: [
//       Expanded(
//         child: IconButton(
//           onPressed: () async {
//             try {
//               // Trigger the delete operation
//               await ref.read(addCartItem(productId).future);
//               ScaffoldMessenger.of(context).clearSnackBars();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Product added to cart')),
//               );
//               ref.refresh(getCartProducts);
//             } catch (e) {
//               // Show an error if the deletion fails
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Failed to delete item: $e'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//             // ScaffoldMessenger.of(context).clearSnackBars();
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   const SnackBar(content: Text('Product added to cart')),
//             // );
//           },
//           icon: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             transitionBuilder: (child, animation) {
//               return FadeTransition(
//                 opacity: animation,
//                 child: child,
//               );
//             },
//             child: const Icon(Icons.shopping_cart),
//           ),
//           style: ButtonStyle(
//               backgroundColor:
//                   MaterialStatePropertyAll(Color.fromARGB(255, 219, 219, 42))),
//         ),
//       ),
//     ]);
//   }
// }

//
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:elbazar_app/data/models/product_with_images_model.dart';
// import 'package:elbazar_app/presentation/provider/auth_provider.dart';
// import 'package:elbazar_app/presentation/screens/widgets/products_detail_screen.dart';
// import 'package:elbazar_app/presentation/screens/widgets/image_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../provider/categories_provider.dart';
// import '../../provider/products_repo_provider.dart';
// import '../cart_screen/cart_screen.dart';
//
// final getCategoriesProvider = FutureProvider<dynamic>((ref) async {
//   final sellerRepository = ref.read(sellerRepositoryProvider);
//   return sellerRepository.getCategoriesList();
// });
//
// final addCartItem =
//     FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
//   final customerRepository = ref.read(customerRepositoryProvider);
//   final authState = ref.watch(authStateProvider);
//   return customerRepository.addToCart(
//       jwt: authState.token,
//       productId: data['productId'],
//       quantity: data['quantity']);
// });
//
// final selectQuantityItem = StateProvider<int>((ref) => 1);
//
// class CardProductItem extends ConsumerWidget {
//   const CardProductItem({Key? key, required this.product, this.fromScreen})
//       : super(key: key);
//
//   final ProductWithImages product;
//   final String? fromScreen;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final categories = ref.read(categoriesProvider);
//
//     String? categoryName = product.categoryName;
//     if (categoryName == null) {
//       for (var category in categories) {
//         categoryName = category.getNameFromId(product.categoryId);
//         if (categoryName.isNotEmpty) break;
//       }
//     }
//
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       clipBehavior: Clip.hardEdge,
//       elevation: 2,
//       child: InkWell(
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailScreen(
//                 productId: product.id, fromScreen: fromScreen),
//           ),
//         ),
//         child: Column(
//           children: [
//             _buildImageSlider(),
//             _buildProductDetails(context, categoryName!, ref, product.id),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSlider() {
//     return Expanded(
//       flex: 2,
//       child: ImageSlider(
//         imagesBytes: product.images,
//         options: CarouselOptions(
//           enableInfiniteScroll: false,
//           height: double.infinity,
//           viewportFraction: 1,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProductDetails(
//       BuildContext context, String categoryName, WidgetRef ref, int productId) {
//     return Expanded(
//       flex: 1,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "${product.price.toStringAsFixed(2)} T",
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               product.name,
//               style: const TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               categoryName,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             _buildAddToCartButton(context, ref, productId),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddToCartButton(
//       BuildContext context, WidgetRef ref, int productId) {
//     int quantity = ref.watch(selectQuantityItem);
//
//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.remove),
//           onPressed: () {
//             if (quantity > 1) {
//               ref.read(selectQuantityItem.notifier).state -= 1;
//             }
//           },
//         ),
//         Text(
//           '$quantity',
//           style: const TextStyle(fontSize: 18),
//         ),
//         IconButton(
//           icon: const Icon(Icons.add),
//           onPressed: () {
//             ref.read(selectQuantityItem.notifier).state += 1;
//           },
//         ),
//         Expanded(
//           child: TextButton(
//             onPressed: () async {
//               try {
//                 await ref.read(addCartItem({
//                   'productId': productId,
//                   'quantity': quantity,
//                 }));
//
//                 ScaffoldMessenger.of(context).clearSnackBars();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Product added to cart')),
//                 );
//
//                 // Optional: Reset quantity after adding to cart
//                 ref.read(selectQuantityItem.notifier).state = 1;
//
//                 ref.refresh(getCartProducts);
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Failed to add item to cart: $e'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: Icon(Icons.shopping_bag),
//             style: ButtonStyle(
//               backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
//               foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

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

final addCartItem =
    FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final customerRepository = ref.read(customerRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return customerRepository.addToCart(
      jwt: authState.token,
      productId: data['productId'],
      quantity: data['quantity']);
});

// Local quantity state for each product card
final selectQuantityItem =
    StateProvider.family<int, int>((ref, productId) => 1);

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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${product.price.toStringAsFixed(2)} T",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                  Text(
                    "${product.quantity.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

              ],
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
    // Watching the quantity for this specific product
    int quantity = ref.watch(selectQuantityItem(productId));

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            if (quantity > 1) {
              ref.read(selectQuantityItem(productId).notifier).state -= 1;
            }
          },
        ),
        Text(
          '$quantity',
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref.read(selectQuantityItem(productId).notifier).state += 1;
          },
        ),
        Expanded(
          child: TextButton(
            onPressed: () async {
              try {
                await ref.read(addCartItem({
                  'productId': productId,
                  'quantity': quantity,
                }));

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added to cart')),
                );

                // Optional: Reset quantity after adding to cart
                ref.read(selectQuantityItem(productId).notifier).state = 1;

                ref.refresh(getCartProducts);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to add item to cart: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Icon(Icons.shopping_cart),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
              foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
