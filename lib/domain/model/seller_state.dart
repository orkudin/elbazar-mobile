// 1. Define the CustomerState class
class SellerState {
  final int id;
  final bool deleted;
  final String created;
  final String bin;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? iin;
  final String? gender;
  final String companyType;
  final bool approved;

  SellerState({
    required this.id,
    required this.deleted,
    required this.created,
    required this.bin,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.iin,
    this.gender,
    required this.companyType,
    required this.approved,
  });


  factory SellerState.fromJson(Map<String, dynamic> json) {
    return SellerState(
      id: json['id'],
      deleted: json['deleted'],
      created: json['created'],
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