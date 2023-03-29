import 'package:chat_app/model/methods.dart';
import 'package:chat_app/screens/one%20to%20one/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group/group_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isloading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'status': status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //onlien
      setStatus('Online');
    } else {
      //offline
      setStatus('Offline');
    }
  }

  String chatRoomId(String user1, String user2) {
    user1 = user1[0].toLowerCase();
    user2 = user2[0].toLowerCase();

    if (user1.codeUnits[0] > user2.codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      print(userMap);
    }).catchError((error) {
      showSnackBar(
        'no user contian this email',
        Colors.red,
      );
      userMap = null;
      setState(() {
        isloading = false;
      });
    });
  }

  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle_outlined,
            size: 40,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Home Screen',
        ),
        actions: [
          IconButton(
            onPressed: () => logOut(context),
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
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
                ElevatedButton(
                  onPressed: _search.text.isNotEmpty ? onSearch : () {},
                  child: const Text('Search'),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomid = chatRoomId(
                            _auth.currentUser!.uid,
                            userMap?['uid'],
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                userMap: userMap!,
                                chatRoomId: roomid,
                              ),
                            ),
                          );
                        },
                        leading: const Icon(
                          Icons.account_box,
                          color: Colors.black,
                        ),
                        title: Text(
                          userMap?['username'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          userMap?['useremail'],
                        ),
                        trailing: const Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GroupChatHomeScreen(),
          ),
        ),
        child: const Icon(
          Icons.group,
        ),
      ),
    );
  }
}
