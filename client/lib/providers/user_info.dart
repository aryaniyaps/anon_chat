import 'package:anon_chat/models/user_info.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoNotifier extends StateNotifier<AsyncValue<UserInfo>> {
  UserInfoNotifier({required this.ref}) : super(const AsyncLoading()) {
    // load user info
    loadUserInfo();
  }

  final Ref ref;

  Future<void> loadUserInfo({int? take}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);

    state = AsyncValue.data(
      await repo.getUserInfo(
        cancelToken: cancelToken,
      ),
    );
  }

  Future<void> regenUserId({int? take}) async {
    final repo = ref.read(repositoryProvider);

    state = AsyncValue.data(await repo.regenUserId());
  }
}

final userInfoProvider =
    StateNotifierProvider.autoDispose<UserInfoNotifier, AsyncValue<UserInfo>>(
        (ref) {
  return UserInfoNotifier(ref: ref);
});
