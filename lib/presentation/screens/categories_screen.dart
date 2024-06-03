import 'package:elbazar_app/domain/model/category.dart';
import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCategoriesProvider = FutureProvider<dynamic>((ref) async {
  final sellerRepository = ref.read(sellerRepositoryProvider);
  return sellerRepository.getCategoriesList();
});

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsyncGetCategories = ref.watch(getCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: responseAsyncGetCategories.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
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

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            },
          );
        }).toList(),
      ),
    );
  }
}
