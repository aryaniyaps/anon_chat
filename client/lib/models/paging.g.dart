// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo(
      hasNextPage: json['hasNextPage'] as bool,
      cursor: json['cursor'] as String,
    );

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'hasNextPage': instance.hasNextPage,
      'cursor': instance.cursor,
    };
