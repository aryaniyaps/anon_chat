import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  String userId;

  UserInfo({
    required this.userId,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return _$UserInfoFromJson(json);
  }
}
