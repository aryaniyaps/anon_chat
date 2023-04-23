import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  void boardUser() async {
    if (_formKey.currentState!.validate()) {
      var result = _formKey.currentState!.value;
      // board user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormBuilderTextField(
            name: "Username",
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: "Don't enter your real name!",
            ),
            maxLength: 25,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: boardUser,
            child: const Text("start chatting"),
          ),
        ],
      ),
    );
  }
}
