import 'package:json_annotation/json_annotation.dart';

part 'order_entity.g.dart';

@JsonSerializable()
class OrderEntity {
  final int orderid;
  final int productId;
  final int quantity;
  final double price;
  final String status;
  final int addressId;
  final int customerId;

  OrderEntity({
    required this.orderid,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.status,
    required this.addressId,
    required this.customerId,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) =>
      _$OrderEntityFromJson(json);

  Map<String, dynamic> toJson() => _$OrderEntityToJson(this);
}