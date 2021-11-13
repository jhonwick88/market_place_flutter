class AutoGenerate {
  AutoGenerate({
    required this.code,
    required this.message,
    required this.data,
    this.option,
  });
  late final int code;
  late final String message;
  late final Data data;
  late final Null option;

  AutoGenerate.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = Data.fromJson(json['data']);
    option = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['message'] = message;
    _data['data'] = data.toJson();
    _data['option'] = option;
    return _data;
  }
}

class Data {
  Data({
    required this.user,
    required this.token,
  });
  late final User user;
  late final String token;

  Data.fromJson(Map<String, dynamic> json){
    user = User.fromJson(json['user']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['token'] = token;
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.currentTeamId,
    this.profilePhotoPath,
    required this.createdAt,
    required this.updatedAt,
    required this.publicLink,
    required this.isActive,
    required this.profilePhotoUrl,
  });
  late final int id;
  late final String name;
  late final String email;
  late final Null emailVerifiedAt;
  late final int currentTeamId;
  late final Null profilePhotoPath;
  late final String createdAt;
  late final String updatedAt;
  late final String publicLink;
  late final int isActive;
  late final String profilePhotoUrl;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = null;
    currentTeamId = json['current_team_id'];
    profilePhotoPath = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    publicLink = json['public_link'];
    isActive = json['is_active'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['current_team_id'] = currentTeamId;
    _data['profile_photo_path'] = profilePhotoPath;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['public_link'] = publicLink;
    _data['is_active'] = isActive;
    _data['profile_photo_url'] = profilePhotoUrl;
    return _data;
  }
}