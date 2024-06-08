class CityModel {
  final int id;
  final bool deleted;
  final DateTime created;
  final String name;

  CityModel({
    required this.id,
    required this.deleted,
    required this.created,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      name: json['name'],
    );
  }
}