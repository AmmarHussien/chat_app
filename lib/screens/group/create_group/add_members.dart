import 'package:chat_app/screens/group/create_group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  List<Map<String, dynamic>> membersList = [];
  final TextEditingController _search = TextEditingController();
  bool isloading = false;
  Map<String, dynamic>? userMap;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetalis();
  }

  void getCurrentUserDetalis() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      membersList.add({
        'username': map['username'],
        'useremail': map['useremail'],
        'uid': map['uid'],
        'isAdmin': true,
      });
    });
  }

  void onSearch() async {
    setState(() {
      isloading = true;
    });

    await _firestore
        .collection('users')
        .where('useremail', isEqualTo: _search.text)
        .get()
        .then((user) {
      setState(() {
        userMap = user.docs[0].data();
        isloading = false;
      });
      if (kDebugMode) {
        print(userMap);
      }
    }).catchError((error) {
      // showSnackBar(
      //   'no user contian this email',
      //   Colors.red,
      // );
      userMap = null;
      setState(() {
        isloading = false;
      });
    });
  }

  void onResultTap() {
    bool isAleardyExist = false;
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap?['uid']) {
        isAleardyExist = true;
      }
    }

    if (!isAleardyExist) {
      setState(() {
        membersList.add({
          'username': userMap?['username'],
          'useremail': userMap?['useremail'],
          'uid': userMap?['uid'],
          'isAdmin': false,
        });
        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onRemoveMembers(index),
                    title: Text(
                      membersList[index]['username'],
                    ),
                    subtitle: Text(
                      membersList[index]['useremail'],
                    ),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.black,
                    ),
                    trailing: const Icon(
                      Icons.close,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isloading
                ? Container(
                    height: size.height / 10,
                    width: size.width / 12,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: const Text('Search'),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onResultTap,
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.black,
                    ),
                    title: Text(
                      userMap?['username'],
                    ),
                    subtitle: Text(
                      userMap?['useremail'],
                    ),
                    trailing: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreatGroup(
                    memberList: membersList,
                  ),
                ),
              ),
              child: const Icon(
                Icons.forward,
              ),
            )
          : const SizedBox(),
    );
  }
}
