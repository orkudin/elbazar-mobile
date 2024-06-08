import 'package:elbazar_app/data/models/users_model/user_model.dart';

import '../address_model.dart';

class CustomerModel extends UserModel{
  final int id;
  final bool deleted;
  final DateTime created;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String iin;
  final String gender;
  final AddressModel address;

  CustomerModel({
    required this.id,
    required this.deleted,
    required this.created,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.iin,
    required this.gender,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      iin: json['iin'],
      gender: json['gender'],
      address: AddressModel.fromJson(json['address']),
    );
  }
}