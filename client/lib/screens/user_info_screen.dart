import 'package:anon_chat/providers/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends ConsumerWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider);

    final userInfoNotifier = ref.watch(userInfoProvider.notifier);

    return userInfo.when(
      data: (userInfo) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "User Info",
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://api.dicebear.com/6.x/identicon/png?seed=${userInfo.userId}",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userInfo.userId,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    userInfoNotifier.regenUserId();
                  },
                  child: const Text(
                    "regenerate ID",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "caution: you cannot get back your ID\nafter regeneration!",
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}