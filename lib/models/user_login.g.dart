// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) {
  return UserLogin(
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) => <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    isActive: json['isActive'] as int?,
    profilePhotoUrl: json['profilePhotoUrl'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'isActive': instance.isActive,
      'profilePhotoUrl': instance.profilePhotoUrl,
    };
