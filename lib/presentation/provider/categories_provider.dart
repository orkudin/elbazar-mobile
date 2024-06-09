import 'package:elbazar_app/presentation/provider/products_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/category.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier(this.ref) : super([]) {
    _loadCategories();
  }

  final Ref ref;

  Future<void> _loadCategories() async {
    try {
      final sellerRepository = ref.read(sellerRepositoryProvider);
      final categories = await sellerRepository.getCategoriesList();
      state = categories;
    } catch (e) {
      // Handle error
      state = [];
    }
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier(ref);
});
