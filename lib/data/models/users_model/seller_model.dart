import 'package:elbazar_app/data/models/users_model/user_model.dart';

class SellerModel extends UserModel{
  final int id;
  final bool deleted;
  final DateTime created;
  final String bin;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String iin;
  final String gender;
  final String companyType;
  final bool approved;

  SellerModel({
    required this.id,
    required this.deleted,
    required this.created,
    required this.bin,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.iin,
    required this.gender,
    required this.companyType,
    required this.approved,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      bin: json['bin'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      iin: json['iin'],
      gender: json['gender'],
      companyType: json['companyType'],
      approved: json['approved'],
    );
  }
}