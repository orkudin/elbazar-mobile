import 'package:elbazar_app/data/datasources/client_api/admin_api_client.dart';
import 'package:elbazar_app/data/datasources/client_api/customer_api_client.dart';
import 'package:flutter/cupertino.dart';

import '../models/address_model.dart';
import '../models/cart_model.dart';
import '../models/city_model.dart';

class CustomerRepository {
  final CustomerApiClient customerApiClient;

  CustomerRepository({required this.customerApiClient});

  Future<AddressModel?> getAddresses({required String jwt}) async {
    return await customerApiClient.getAddressesList(jwt: jwt);
  }

  Future<String> updateCustomerInformation({
    required String jwt,
    required String firstName,
    required String lastName,
    required String phone,
    required String iin,
    required String gender,
  }) async {
    return await customerApiClient.updateCustomerInformation(
      jwt: jwt,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      iin: iin,
      gender: gender,
    );
  }

  // Future<List<CityModel>> getCitiesList() async {
  //   return await customerApiClient.getCitiesList();
  // }
  Future<List<CityModel>> getCitiesList() async {
    return await customerApiClient.getCitiesList();
  }

  Future<void> addAddress({
    required String jwt,
    required int cityId,
    required String street,
    required String house,
    required String apartments,
  }) async {
    await customerApiClient.addAddress(
      jwt: jwt,
      cityId: cityId,
      street: street,
      house: house,
      apartments: apartments,
    );
  }

  Future<void> deleteAddress({
    required String jwt,
    required int addressId,
  }) async {
    await customerApiClient.deleteAddress(jwt: jwt, addressId: addressId);
  }

  Future<void> updateAddress({
    required String jwt,
    required int cityId,
    required String street,
    required String house,
    required String apartments,
  }) async {
    await customerApiClient.updateAddress(
      jwt: jwt,
      cityId: cityId,
      street: street,
      house: house,
      apartments: apartments,
    );
  }

  Future<List<CartItem>> fetchCartItems({required String jwt}) async {
    return await customerApiClient.fetchCartItems(jwtToken: jwt);
  }

  Future<void> deleteCartItem({
    required String jwt,
    required int cartItemId,
  }) async {
    await customerApiClient.deleteCartItem(
        jwtToken: jwt, cartItemId: cartItemId);
  }

  Future<void> addToCart({
    required String jwt,
    required int productId,
    required int quantity,
  }) async {
    await customerApiClient.addToCart(
      jwt: jwt,
      productId: productId,
      quantity: quantity,
    );
  }

  Future<void> postOrder({
    required String jwt,
    required Map<String, dynamic> selectedItems,
  }) async {
    await customerApiClient.postOrder(jwt: jwt, selectedItems: selectedItems);
    await customerApiClient.payOrder(jwt: jwt, orderId: selectedItems['order_id']);
  }

  Future<void> payOrder({
    required String jwt,
    required int orderId,
  }) async {
    await customerApiClient.payOrder(jwt: jwt, orderId: orderId);
  }
}
