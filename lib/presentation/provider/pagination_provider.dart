import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';

// State to hold pagination details and list of products
class ProductPaginationState {
  final List<ProductWithImages> products;
  final int page;
  final bool isLastPage;

  ProductPaginationState({
    this.products = const [],
    this.page = 0,
    this.isLastPage = false,
  });

  ProductPaginationState copyWith({
    List<ProductWithImages>? products,
    int? page,
    bool? isLastPage,
  }) {
    return ProductPaginationState(
      products: products ?? this.products,
      page: page ?? this.page,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

// StateNotifier to manage fetching and updating the products state
class ProductPaginationNotifier extends StateNotifier<ProductPaginationState> {
  ProductPaginationNotifier(this.ref) : super(ProductPaginationState()) {
    fetchProducts(); // Initial fetch
  }

  final Ref ref;

  Future<void> fetchProducts({bool isRefresh = false}) async {
    final sellerRepository = ref.read(sellerRepositoryProvider);
    final int nextPage = isRefresh ? 0 : state.page;

    try {
      final newProducts = await sellerRepository.getAllProductsWithImages(
        page: nextPage,
        size: 2,
        sort: 'id',
        order: 'ASC',
        isActive: true,
      );

      if (isRefresh) {
        state = ProductPaginationState(
            products: newProducts,
            page: 1,
            isLastPage: newProducts.length < 10);
      } else {
        state = state.copyWith(
          products: [...state.products, ...newProducts],
          page: state.page + 1,
          isLastPage: newProducts.length < 10,
        );
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching products: $e');
    }
  }
}

// Provider to use with Riverpod
final productsWithImagesProvider =
    StateNotifierProvider<ProductPaginationNotifier, ProductPaginationState>(
  (ref) => ProductPaginationNotifier(ref),
);
