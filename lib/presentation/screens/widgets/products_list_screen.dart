import 'package:elbazar_app/data/models/product_with_images_model.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/widgets/card_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


final getProductsListWithImages =
    FutureProvider.family<List<ProductWithImages>, Map<String, dynamic>>(
        (ref, paginationParams) {
  final sellerRepository = ref.watch(sellerRepositoryProvider);
  return sellerRepository.getAllProductsWithImages(
      page: paginationParams['page'],
      size: paginationParams['size'],
      sort: paginationParams['sort'],
      order: paginationParams['order'],
      isActive: true);
});

class ProductsListScreen extends ConsumerStatefulWidget {
  const ProductsListScreen({super.key});

  @override
  _ProductsListScreen createState() => _ProductsListScreen();
}

class _ProductsListScreen extends ConsumerState<ProductsListScreen> {
  late Map<String, dynamic> paginationParams;
  final int _pageSize = 4; // Adjust as needed
  late PagingController<int, ProductWithImages> _pagingController;

  @override
  void dispose() {
    _pagingController.dispose();
    super.deactivate();
  }

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await ref.read(getProductsListWithImages(
        {
          'page': pageKey,
          'size': _pageSize,
          'sort': 'id', // Replace with your desired sorting
          'order': 'ASC', // Replace with ASC or DESC
        },
      ).future);

      final newItems = response;
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return  RefreshIndicator(
      onRefresh: _refresh,
      child: PagedGridView<int, ProductWithImages>(
        pagingController: _pagingController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 4,
          mainAxisSpacing: 20,
        ),
        builderDelegate: PagedChildBuilderDelegate<ProductWithImages>(
          itemBuilder: (context, item, index) {
            final product = item;
            return CardProductItem(product: product);
          },
          firstPageProgressIndicatorBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          newPageProgressIndicatorBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: Text('No items found'),
          ),
        ),

      ),
    );
  }
}

