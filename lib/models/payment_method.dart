import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod {
  late int id;
  late String name;
  @JsonKey(defaultValue: "")
  late String account_number;

  PaymentMethod();

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
