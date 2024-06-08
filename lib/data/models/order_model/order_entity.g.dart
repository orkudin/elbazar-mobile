// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => OrderEntity(
      orderid: (json['orderId'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      addressId: (json['addressId'] as num).toInt(),
      customerId: (json['customerId'] as num).toInt(),
    );

Map<String, dynamic> _$OrderEntityToJson(OrderEntity instance) =>
    <String, dynamic>{
      'orderId': instance.orderid,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'price': instance.price,
      'status': instance.status,
      'addressId': instance.addressId,
      'customerId': instance.customerId,
    };
