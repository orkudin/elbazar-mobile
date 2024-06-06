import 'package:elbazar_app/data/network/client_api/seller_api_client.dart';
import 'package:elbazar_app/data/network/entity/product_with_images.dart';
import 'package:elbazar_app/data/network/entity/seller_entity.dart';
import 'package:elbazar_app/domain/model/category.dart';

class SellerRepository {
  final SellerApiClient sellerApiClient;

  SellerRepository({
    required this.sellerApiClient,
  });

  Future<List<ProductWithImages>> getAllProductsWithImages({
    required int page,
    required int size,
    required String sort,
    required String order,
    required bool isActive,
  }) async {
    return await sellerApiClient.fetchProductsWithImages(
      page: page,
      size: size,
      sort: sort,
      order: order,
      isActive: isActive,
    );
  }

  Future<List<ProductWithImages>> getSellerOwnProducts({
    required String jwt,
    required int page,
    required int size,
    required String sort,
    required String order,
  }) async {
    return await sellerApiClient.getSellerOwnProducts(
      jwt: jwt,
      page: page,
      size: size,
      sort: sort,
      order: order,
    );
  }

  Future<ProductWithImages> getProductWithImagesById({
    required int productId,
  }) async {
    return await sellerApiClient.getProductWithImagesById(productId: productId);
  }

  Future<SellerEntity> getSellerInformation({
    required String jwt,
  }) async {
    return await sellerApiClient.getSellerInformation(jwt: jwt);
  }

  Future<String> updateSellerInformation({
    required String jwt,
    required String bin,
    required String firstName,
    required String lastName,
    required String phone,
    required String iin,
    required String gender,
  }) async {
    return await sellerApiClient.updateSellerInformation(
      jwt: jwt,
      bin: bin,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      iin: iin,
      gender: gender,
    );
  }

  Future<void> deleteProductById({
    required String jwt,
    required int productId,
  }) async {
    await sellerApiClient.deleteProduct(jwt: jwt, productId: productId);
  }

  Future<dynamic> uploadProduct({
    required String jwt,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required int categoryId,
  }) async {
    return await sellerApiClient.uploadProduct(
        jwt: jwt,
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        categoryId: categoryId);
  }

  Future<dynamic> uploadProductImages({
    required String jwt,
    required int productId,
    required List<String> imageFilePaths,
  }) async {
    return await sellerApiClient.uploadProductImages(
        jwt: jwt, productId: productId, imageFilePaths: imageFilePaths);
  }

  Future<dynamic> getCategoriesList() async {
    final data = await sellerApiClient.getCategoriesList();

    final List<Category> categories =
        (data['parentCategories'] as List<dynamic>)
            .map((category) => Category.fromJson(category))
            .toList();

    return categories;
  }

  Future<String> updateProduct({
    required String jwt,
    required int productId,
    required String name,
    required String description,
    required double price,
    required bool active,
    required int quantity,
    required int categoryId,
  }) async {
    return sellerApiClient.updateProduct(
        jwt: jwt,
        productId: productId,
        name: name,
        description: description,
        price: price,
        active: active,
        quantity: quantity,
        categoryId: categoryId);
  }

  Future<List<ProductWithImages>> searchProducts({
    required int page,
    required int size,
    required String sort,
    required String order,
    required String searchText,
    int? categoryId,
    int? salesId,
    String? searchType,
  }) async {
    return await sellerApiClient.fetchFromSearchProductsWithImages(
      page: page,
      size: size,
      sort: sort,
      order: order,
      searchText: searchText,
      categoryId: categoryId,
      salesId: salesId,
      searchType: searchType,
    );
  }
}
