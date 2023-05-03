import 'package:anon_chat/core/ws_client.dart';
import 'package:anon_chat/screens/chat_room_screen.dart';
import 'package:anon_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  // init ws connection
  wsClient.connect();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => HomeScreen(key: state.pageKey),
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
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Anonymous Chat',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
