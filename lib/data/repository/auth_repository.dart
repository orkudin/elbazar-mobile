// data/auth_repository.dart
import 'package:elbazar_app/data/network/client/auth_api_client.dart';
import 'package:elbazar_app/domain/model/token.dart';

class AuthRepository {
  final AuthApiClient authApiClient;

  AuthRepository({required this.authApiClient});

  Future<Token> loginUserData({
    required String username,
    required String password,
    required String role,
  }) async {
    return await authApiClient.loginUserData(
      password: password,
      username: username,
      role: role,
    );
  }

  Future<String> registerSeller({
    required String firstName,
    required String lastName,
    required String email,
    required String companyType,
    required String bin,
  }) async {
    return await authApiClient.registerSeller(
      firstName: firstName,
      lastName: lastName,
      email: email,
      companyType: companyType,
      bin: bin,
    );
  }

  Future<String> registerSellerConfirm({
    required String uuid,
    required String code,
    required String password,
  }) async {
    return await authApiClient.registerSellerConfirm(
      uuid: uuid,
      code: code,
      password: password,
    );
  }

  Future<String> registerCustomer({required String email}) async {
    return await authApiClient.registerCustomer(email: email);
  }

  Future<String> registerCustomerConfirm({
    required String uuid,
    required String code,
  }) async {
    return await authApiClient.registerCustomerConfirm(
      uuid: uuid,
      code: code,
    );
  }

  Future<String> registerCustomerComplete({
    required String uuid,
    required String password,
    required String firstname,
    required String lastname,
    required String phone,
    required String iin,
    required String gender,
  }) async {
    return await authApiClient.registerCustomerComplete(
      uuid: uuid,
      password: password,
      firstname: firstname,
      lastname: lastname,
      phone: phone,
      iin: iin,
      gender: gender,
    );
  }

  Future<Token> loginUserAccount({
    required String username,
    required String password,
  }) async {
    return await authApiClient.loginUserAccount(
      password: password,
      username: username,
    );
  }

  Future<Token> loginAdminAccount({
    required String username,
    required String password,
  }) async {
    return await authApiClient.loginAdminAccount(
      password: password,
      username: username,
    );
  }
}


