import 'package:json_annotation/json_annotation.dart';
import 'package:market_place_flutter/models/payment.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  late int id;
  late String name;
  @JsonKey(defaultValue: "")
  late String adress;
  late int total_payment;
  late String network_type;
  @JsonKey(defaultValue: [])
  late List<Payment> payment;

  Customer();

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
