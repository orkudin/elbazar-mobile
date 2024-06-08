
import 'city_model.dart';
import 'region_model.dart';

class AddressModel {
  final int id;
  final bool deleted;
  final DateTime created;
  final RegionModel region;
  final CityModel city;
  final String street;
  final String house;
  final String apartments;
  final String fullAddress;

  AddressModel({
    required this.id,
    required this.deleted,
    required this.created,
    required this.region,
    required this.city,
    required this.street,
    required this.house,
    required this.apartments,
    required this.fullAddress,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      region: RegionModel.fromJson(json['region']),
      city: CityModel.fromJson(json['city']),
      street: json['street'],
      house: json['house'],
      apartments: json['apartments'],
      fullAddress: json['fullAddress'],
    );
  }
}