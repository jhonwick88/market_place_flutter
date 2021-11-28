// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) {
  return PaymentMethod()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..account_number = json['account_number'] as String? ?? '';
}

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account_number': instance.account_number,
    };
