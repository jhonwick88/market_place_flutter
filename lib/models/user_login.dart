import 'package:json_annotation/json_annotation.dart';
part 'user_login.g.dart';

@JsonSerializable()
class UserLogin{
  UserLogin({
    required this.user,
    required this.token,
  });
  late final User user;
  late final String token;
  factory UserLogin.fromJson(Map<String, dynamic> json)=> _$UserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}
@JsonSerializable()
class User {
  User({
    required this.id,
    required this.name,
    required this.email,
   // this.emailVerifiedAt,
    //required this.currentTeamId,
   // this.profilePhotoPath,
   //  required this.createdAt,
   //  required this.updatedAt,
   //  required this.publicLink,
    required this.isActive,
    required this.profilePhotoUrl,
  });
  late final int id;
  late final String name;
  late final String email;
  //late final String? emailVerifiedAt;
//  late final int currentTeamId;
  //late final String? profilePhotoPath;
  // late final String createdAt;
  // late final String updatedAt;
  // late final String publicLink;
 late final int? isActive;
  late final String? profilePhotoUrl;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
  }