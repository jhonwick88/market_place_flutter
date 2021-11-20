// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..id = json['id'] as int
    ..pay_date = json['pay_date'] as String
    ..total = json['total'] as int
    ..user_id = json['user_id'] as int
    ..payment_method_id = json['payment_method_id'] as int
    ..customer_id = json['customer_id'] as int
    ..status = json['status'] as int
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String
    ..month = json['month'] as int
    ..year = json['year'] as int
    ..collector = json['collector'] as String;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'pay_date': instance.pay_date,
      'total': instance.total,
      'user_id': instance.user_id,
      'payment_method_id': instance.payment_method_id,
      'customer_id': instance.customer_id,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'month': instance.month,
      'year': instance.year,
      'collector': instance.collector,
    };
