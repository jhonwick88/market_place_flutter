import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  late final int id;
  late final String pay_date;
  late final int total;
  late final int user_id;
  late final int payment_method_id;
  late final int customer_id;
  late final int status;
  late final String created_at;
  late final String updated_at;
  late final int month;
  late final int year;
  late final String collector;

  Payment();

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
