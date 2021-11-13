import 'package:json_annotation/json_annotation.dart';
part 'base_model.g.dart';

@JsonSerializable()
class BaseModel{
  int code;
  String message;
  dynamic data;
  BaseModel({required this.code,required this.message,required this.data});

  factory BaseModel.fromJson(Map<String, dynamic> json) => _$BaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BaseModelToJson(this);
}