import 'package:json_annotation/json_annotation.dart';

part 'paging.g.dart';

@JsonSerializable()
class PageInfo {
  bool hasNextPage;
  String? cursor;

  PageInfo({required this.hasNextPage, this.cursor});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return _$PageInfoFromJson(json);
  }
}
