import 'package:anon_chat/screens/boarding_screen.dart';
import 'package:anon_chat/screens/chat_room_screen.dart';
import 'package:anon_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            chatRoomId: state.params["id"]!,
          );
        },
      ),
    ],
  );

  late final IO.Socket _socket;

  void setupSocket() {
    _socket = IO.io("http://localhost:3000");
    _socket.connect();

    _socket.onConnect((data) {
      debugPrint("connection established");
    });

    _socket.onDisconnect((data) {
      debugPrint("connection discontinued");
    });
    _socket.onError((error) => {debugPrint(error.toString())});
  }

  @override
  void initState() {
    setupSocket();
    super.initState();
  }

  void discardSocket() {
    _socket.disconnect();
    _socket.dispose();
  }

  @override
  void dispose() {
    discardSocket();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Anonymous Chat',
      routerConfig: _router,
    );
  }
}
