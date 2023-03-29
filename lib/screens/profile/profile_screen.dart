import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userMap;
  bool isloading = false;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _userEmail = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {

    await _firestore
        .collection('users')
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .get()
        .then((user) {
      setState(() {
        userMap = user.docs[0].data();
        isloading = false;
      });
    });

    _userEmail.text = userMap!['useremail'];
    _username.text = userMap!['username'];
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: size.height / 40,
              ),
              //UserImagePicker(_pickedImage),
              SizedBox(
                height: size.height / 40,
              ),
              SizedBox(
                width: size.width / 1.1,
                child: TextFormField(
                  readOnly: true,
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enterr a valid email address!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: true,
                  controller: _userEmail,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 60,
              ),
              SizedBox(
                width: size.width / 1.1,
                child: TextFormField(
                  readOnly: true,
                  key: const ValueKey('Username'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enterr a valid email address!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: true,
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
