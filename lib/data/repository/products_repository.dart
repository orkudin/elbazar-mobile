import 'package:elbazar_app/data/network/client/api_client.dart';
import 'package:elbazar_app/data/network/entity/product_entity.dart';
import 'package:elbazar_app/data/network/network_mapper.dart';
import 'package:elbazar_app/domain/model/product.dart';

class ProductsRepository {
  final ApiClient apiclient;
  final NetworkMapper networkMapper;

  ProductsRepository({required this.apiclient, required this.networkMapper});

  Future<List<Product>> getUpcomingProducts(
      {required int page,
      required size,
      required String sort,
      required String order,
      required bool isActive}) async {
    final upcomingProducts = await apiclient.getUpcomingProducts(
        page: page, size: size, sort: sort, order: order, isActive: isActive);
    return networkMapper.toProducts(upcomingProducts.results);
  }
}
