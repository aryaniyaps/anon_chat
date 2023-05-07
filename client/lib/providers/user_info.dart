import 'package:anon_chat/models/user_info.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userInfoProvider = FutureProvider.autoDispose<UserInfo>((ref) async {
  // cancel the HTTP request if user leaves inbetween
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repo = ref.read(repositoryProvider);

  final userInfo = await repo.getUserInfo(
    cancelToken: cancelToken,
  );

  // cache user info
  ref.keepAlive();
  return userInfo;
});
