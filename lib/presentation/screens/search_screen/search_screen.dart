import 'package:elbazar_app/presentation/screens/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/data/models/product_with_images_model.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/widgets/card_product_item.dart';

final searchProductsProvider =
    FutureProvider.family<List<ProductWithImages>, Map<String, dynamic>>(
  (ref, searchParams) async {
    final sellerRepository = ref.read(sellerRepositoryProvider);
    try {
      return await sellerRepository.searchProducts(
        page: searchParams['page'],
        size: searchParams['size'],
        sort: searchParams['sort'],
        order: searchParams['order'],
        searchText: searchParams['searchText'],
        categoryId: searchParams['categoryId'],
        salesId: searchParams['salesId'],
        searchType: searchParams['searchType'],
      );
    } catch (error) {
      throw Exception('Error fetching search products: $error');
    }
  },
);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key, required this.searchValue, this.categoryId})
      : super(key: key);
  final String searchValue;
  final int? categoryId;

  @override
  // ignore: library_private_types_in_public_api
  _SearchProductsListScreenState createState() =>
      _SearchProductsListScreenState();
}

class _SearchProductsListScreenState extends ConsumerState<SearchScreen> {
  String _searchText = '';
  int? _categoryId;
  int? _salesId;
  String _searchType = 'NONE';
  Map<String, dynamic>? searchParams;

  @override
  void initState() {
    super.initState();
    _searchText = widget.searchValue;
    _categoryId = widget.categoryId;
    searchParams = {
      'page': 0,
      'size': 10,
      'sort': 'id',
      'order': 'ASC',
      'searchText': _searchText,
      'categoryId': _categoryId,
      'salesId': _salesId,
      'searchType': _searchType,
    };
  }

  void _onSearch(String searchText) {
    setState(() {
      _searchText = searchText;
      searchParams = {
        'page': 0,
        'size': 10,
        'sort': 'id',
        'order': 'ASC',
        'searchText': _searchText,
        'categoryId': _categoryId,
        'salesId': _salesId,
        'searchType': _searchType,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final responseAsyncGetProducts =
        ref.watch(searchProductsProvider(searchParams!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results "$_searchText"'),
      ),
      body: Column(
        children: [
          // Search bar for new searches
          SearchBarCustom(onSearch: _onSearch),
          // Add filters
          _buildFilters(),
          Expanded(
            child: responseAsyncGetProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                        'There is no ${_searchText == '' ? _categoryId : _searchText}'),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 4,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return CardProductItem(product: product);
                    },
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          hint: const Text('Sort By'),
          value: _searchType,
          items: const [
            DropdownMenuItem(value: 'POPULARITY', child: Text('Popularity')),
            DropdownMenuItem(value: 'PRICE_ASC', child: Text('Price Asc')),
            DropdownMenuItem(value: 'PRICE_DESC', child: Text('Price Desc')),
            DropdownMenuItem(value: 'RATING', child: Text('Rating')),
            DropdownMenuItem(value: 'NEW', child: Text('New')),
            DropdownMenuItem(value: 'NONE', child: Text('None')),
          ],
          onChanged: (value) {
            setState(() {
              _searchType = value!;
            });
            _onSearch(_searchText);
          },
        ),
        // if (widget.categoryId != null)
        //   DropdownButton<int>(
        //     hint: const Text('Category'),
        //     value: _categoryId,
        //     items: const [
        //       DropdownMenuItem(value: 1, child: Text('Category 1')),
        //       DropdownMenuItem(value: 2, child: Text('Category 2')),
        //       // Add more categories
        //     ],
        //     onChanged: (value) {
        //       _onSearch(_searchText);
        //     },
        //   ),
        DropdownButton<int>(
          hint: const Text('Sales'),
          value: _salesId,
          items: const [
            DropdownMenuItem(value: 1, child: Text('Sale 1')),
            DropdownMenuItem(value: 2, child: Text('Sale 2')),
            // Add more sales
          ],
          onChanged: (value) {
            _onSearch(_searchText);
          },
        ),
      ],
    );
  }
}
