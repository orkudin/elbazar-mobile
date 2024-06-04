import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/home_screen/widgets/search_bar_home.dart';
import 'package:elbazar_app/presentation/screens/widgets/card_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProductsProvider =
    FutureProvider.family<List<ProductWithImages>, Map<String, dynamic>>(
        (ref, searchParams) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  return sellerRepository.searchProducts(
    page: searchParams['page'],
    size: searchParams['size'],
    sort: searchParams['sort'],
    order: searchParams['order'],
    searchText: searchParams['searchText'],
    categoryId: searchParams['categoryId'],
    salesId: searchParams['salesId'],
    searchType: searchParams['searchType'],
  );
});

class SearchProductsListScreen extends ConsumerStatefulWidget {
  const SearchProductsListScreen({Key? key}) : super(key: key);

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<SearchProductsListScreen> {
  String _searchText = '';
  int? _categoryId;
  int? _salesId;
  String? _searchType;

  void _onSearch(
      String searchText, int? categoryId, int? salesId, String? searchType) {
    setState(() {
      _searchText = searchText;
      _categoryId = categoryId;
      _salesId = salesId;
      _searchType = searchType;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responseAsyncGetProducts = ref.watch(searchProductsProvider({
      'page': 0,
      'size': 10,
      'sort': 'id',
      'order': 'ASC',
      'searchText': _searchText,
      'categoryId': _categoryId,
      'salesId': _salesId,
      'searchType': _searchType,
    }));

    return Scaffold(
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
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
