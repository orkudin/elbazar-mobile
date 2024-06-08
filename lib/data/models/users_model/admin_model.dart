import 'package:elbazar_app/data/models/users_model/user_model.dart';

class AdminModel extends UserModel{
  final String role;

  AdminModel({
    this.role = 'ADMIN', // Default role set to 'ADMIN'
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      role: json.containsKey('role') ? json['role'] : 'ADMIN',
    );
  }
}