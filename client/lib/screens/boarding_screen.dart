import 'package:anon_chat/core/supabase_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

  void boardUser() {
    if (_formKey.currentState!.validate()) {
      var result = _formKey.currentState!.value;
      // create user
      supabase.from("users").insert(
        {
          "username": result["username"],
        },
      ).then((_) {
        context.push("/");
      });
    }
  }

  void refreshUsername() {
    // regenerate username here
    var username = _formKey.currentState!.fields["username"];
    username!.didChange("initial-username");
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: const {
        "username": "initial-username",
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormBuilderTextField(
            name: "username",
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: "Don't use your real name!",
              suffixIcon: IconButton(
                onPressed: refreshUsername,
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
            onPressed: boardUser,
            child: const Text("start chatting"),
          ),
        ],
      ),
    );
  }
}
