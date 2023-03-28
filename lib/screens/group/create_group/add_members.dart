import 'package:chat_app/screens/group/create_group/create_group.dart';
import 'package:flutter/material.dart';

class AddMembersInGroup extends StatelessWidget {
  const AddMembersInGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextEditingController _search = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   height: size.height / 50,
            // ),

            Flexible(
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    title: const Text('user2'),
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
            ElevatedButton(
              onPressed: () {},
              child: const Text('Search'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CreatGroup(),
          ),
        ),
        child: const Icon(
          Icons.forward,
        ),
      ),
    );
  }
}
