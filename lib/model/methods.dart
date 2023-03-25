import 'package:chat_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(
  String name,
  String email,
  String password,
) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user!;

    if (user != null) {
      print('Create Account Succesfull');
      print('Login Succesfull');
      return user;
    } else {
      print('Account creation failed');
      return user;
    }
  } catch (error) {
    print(error);
    return null;
  }
}

Future<User?> login(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user!;
    if (user != null) {
      print('Login Succesfull');
      return user;
    } else {
      print('Login failed');
      return user;
    }
  } catch (error) {
    print(error);
    return null;
  }
}

Future logout(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  } catch (error) {
    print('error');
  }
}
