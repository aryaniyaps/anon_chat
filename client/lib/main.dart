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
            key: state.pageKey,
            chatRoomId: state.params["id"]!,
          );
        },
      ),
    ],
  );

  late final IO.Socket _socket;

  @override
  void initState() {
    // note: AVD uses 10.0.2.2 as an alias to host loopback interface (localhost)
    _socket = IO.io(
      const String.fromEnvironment("API_URL"),
      <String, dynamic>{
        "autoConnect": false,
        "transports": [
          "websocket",
        ],
      },
    );
    _socket.connect();
    _socket.onConnect((data) {
      debugPrint("connected");
    });
    _socket.onError((error) {
      debugPrint(error.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    _socket.dispose();
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
