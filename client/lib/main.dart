import 'package:anon_chat/providers/ws_channel.dart';
import 'package:anon_chat/screens/chat_room_screen.dart';
import 'package:anon_chat/screens/home_screen.dart';
import 'package:anon_chat/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) {
          return HomeScreen(key: state.pageKey);
        },
      ),
      GoRoute(
        path: "/user-info",
        builder: (context, state) {
          return UserInfoScreen(key: state.pageKey);
        },
      ),
      GoRoute(
        path: "/chatrooms/:id",
        builder: (context, state) {
          return ChatRoomScreen(
            key: state.pageKey,
            chatRoomId: state.params["id"]!,
          );
        },
      ),
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // initialize ws connection
    ref.read(wsChannelProvider);
    return MaterialApp.router(
      title: 'Anonymous Chat',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
