import 'package:elbazar_app/data/datasources/client_api/admin_api_client.dart';

class AdminRepository {
  final AdminApiClient adminApiClient;

  AdminRepository({required this.adminApiClient});

  Future<List<dynamic>> getDocuments({
    required int page,
    required int size,
    required String sort,
    required String order,
    required String bin,
  }) async {
    return await adminApiClient.fetchDocuments(
      page: page,
      size: size,
      sort: sort,
      order: order,
      bin: bin,
    );
  }

  Future<dynamic> getDocumentById(int documentId) async {
    return await adminApiClient.fetchDocumentById(documentId);
  }

  Future<List<dynamic>> getSales({
    required int page,
    required int size,
    required String sort,
    required String order,
    required bool isApproved,
  }) async {
    return await adminApiClient.fetchSales(
      page: page,
      size: size,
      sort: sort,
      order: order,
      isApproved: isApproved,
    );
  }

  Future<dynamic> changeSalesStatus({
    required String bin,
    required bool isApproved,
  }) async {
    return await adminApiClient.changeSalesStatus(
      bin: bin,
      isApproved: isApproved,
    );
  }
}
