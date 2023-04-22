import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: BoardingForm(),
      ),
    );
  }
}

class BoardingForm extends StatefulWidget {
  const BoardingForm({super.key});

  @override
  State<BoardingForm> createState() => _BoardingFormState();
}

class _BoardingFormState extends State<BoardingForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: "Don't use your real name!",
              suffixIcon: IconButton(
                onPressed: () {
                  // regenerate username here
                  _usernameController.value = TextEditingValue.empty;
                },
                icon: const Icon(Icons.refresh),
              ),
            ),
            enableSuggestions: false,
            maxLength: 25,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // create session with username
                context.push("/");
              }
            },
            child: const Text("start chatting"),
          ),
        ],
      ),
    );
  }
}
