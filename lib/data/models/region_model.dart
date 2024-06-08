class RegionModel {
  final int id;
  final bool deleted;
  final DateTime created;
  final String name;

  RegionModel({
    required this.id,
    required this.deleted,
    required this.created,
    required this.name,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      deleted: json['deleted'],
      created: DateTime.parse(json['created']),
      name: json['name'],
    );
  }
}