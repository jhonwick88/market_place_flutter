// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..adress = json['adress'] as String? ?? ''
    ..total_payment = json['total_payment'] as int
    ..network_type = json['network_type'] as String
    ..payment = (json['payment'] as List<dynamic>?)
            ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'adress': instance.adress,
      'total_payment': instance.total_payment,
      'network_type': instance.network_type,
      'payment': instance.payment,
    };
