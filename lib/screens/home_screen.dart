import 'package:chat_app/model/methods.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () => logout(context),
        child: const Text('Logout'),
      ),
    );
  }
}
