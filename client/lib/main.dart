import 'package:anon_chat/screens/boarding_screen.dart';
import 'package:anon_chat/screens/chat_room_screen.dart';
import 'package:anon_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    initialLocation: "/boarding",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => HomeScreen(key: state.pageKey),
      ),
      GoRoute(
        path: "/boarding",
        builder: (context, state) => BoardingScreen(key: state.pageKey),
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
      routerConfig: _router,
    );
  }
}
