import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/presentation/screens/home_screen/widgets/home_app_bar.dart';
import 'package:elbazar_app/presentation/screens/home_screen/widgets/search_bar_home.dart';
import 'package:elbazar_app/presentation/screens/products_list_screen.dart';
import 'package:elbazar_app/presentation/screens/home_screen/search_screen_list_products.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _searchText = '';

  void _onSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });

    // Navigate to the search results page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchProductsListScreen(searchValue: _searchText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          SearchBarHome(onSearch: _onSearch),
          Expanded(child: ProductsListScreen())
        ],
      ),
    );
  }
}
