import 'package:elbazar_app/presentation/screens/search_screen/search_screen.dart';
import 'package:elbazar_app/presentation/screens/widgets/search_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:elbazar_app/presentation/screens/home_screen/widgets/home_app_bar.dart';
import 'package:elbazar_app/presentation/screens/widgets/products_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _onSearch(String searchText) {
    // Navigate to the search results page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(searchValue: searchText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        children: [
          SearchBarCustom(onSearch: _onSearch),
          const Expanded(child: ProductsListScreen())
        ],
      ),
    );
  }
}
