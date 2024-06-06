// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenImpl _$$TokenImplFromJson(Map<String, dynamic> json) => _$TokenImpl(
      jwt: json['jwt'] as String,
      role: json['role'] as String,
      userData: json['userData'],
    );

Map<String, dynamic> _$$TokenImplToJson(_$TokenImpl instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'role': instance.role,
      'userData': instance.userData,
    };
