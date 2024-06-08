import 'package:elbazar_app/domain/model/category.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:elbazar_app/presentation/screens/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCategoriesProvider = FutureProvider<dynamic>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  return sellerRepository.getCategoriesList();
});

class CategoriesScreen extends ConsumerWidget {
  CategoriesScreen({super.key, this.previousScreen});
  String? previousScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsyncGetCategories = ref.watch(getCategoriesProvider);
    print("1----- $previousScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: responseAsyncGetCategories.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              previousScreen: previousScreen,
            );
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

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  final Category category;
  String? previousScreen;

  CategoryCard({Key? key, required this.category, this.previousScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("2----- $previousScreen");

    return Card(
      child: ExpansionTile(
        title: Text(category.name),
        children: category.childCategories.map((childCategory) {
          return ListTile(
            title: Text(childCategory.name),
            onTap: () {
              // Handle category button tap here
              print('Tapped on: ${childCategory.name}');
              print('Tapped on: ${childCategory.id}');
              if (previousScreen == 'add_product') {
                Navigator.pop(context, childCategory);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        searchValue: '', categoryId: childCategory.id),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
