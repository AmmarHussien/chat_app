import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.memberList,
  });

  final String groupName;
  final String groupId;
  final List memberList;

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    super.initState();
    membersList = widget.memberList;
  }

  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where('useremail', isEqualTo: _search.text)
        .get()
        .then((user) {
      setState(() {
        userMap = user.docs[0].data();
        isLoading = false;
      });
      if (kDebugMode) {
        print(userMap);
      }
    }).catchError(
      (error) {
        showSnackBar(
          'no user contian this email',
          Colors.red,
        );
        userMap = null;
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void onAddMembers() async {
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
      });

      Navigator.of(context).pop();
    }

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupId)
        .set({
      "groupname": widget.groupName,
      "id": widget.groupId,
    });
    await _firestore
        .collection('groups')
        .doc(
          widget.groupId,
        )
        .collection('chats')
        .add({
      'message':
          "${_auth.currentUser!.displayName} Add ${userMap!['username']}",
      'type': 'notify',
      'time': FieldValue.serverTimestamp(),
    });
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
            isLoading
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
                    onTap: onAddMembers,
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
    );
  }
}
