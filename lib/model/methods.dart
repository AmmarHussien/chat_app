
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(
  String name,
  String email,
  String password,
  BuildContext context,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (kDebugMode) {
      print("Account created Succesfull");
    }

    userCrendetial.user!.updateDisplayName(name);

    await firestore.collection('users').doc(auth.currentUser!.uid).set({
      "username": name,
      "useremail": email,
      "status": "Unavalible",
      "uid": auth.currentUser!.uid,
    });

    return userCrendetial.user;
  } catch (error) {
  
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
  return null;
}

Future<User?> logIn(
  String email,
  String password,
  BuildContext context,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    firestore.collection('users').doc(auth.currentUser!.uid).get().then(
          (value) => userCredential.user!.updateDisplayName(
            value['username'],
          ),
        );

    return userCredential.user;
  } catch (error) {
    var message = ' An error occurred plase check your Credential';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
    if (kDebugMode) {
      print(error);
    }
  }
  return null;
}

Future logOut(
  BuildContext context,
) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  try {
    await auth.signOut().then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    });
  } catch (e) {
    if (kDebugMode) {
      print("error");
    }
  }
}
