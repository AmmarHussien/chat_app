import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              Container(
                height: size.height / 8,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 10,
                      width: size.width / 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.group,
                        size: size.width / 14,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          'Group Name',
                          style: TextStyle(
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              SizedBox(
                width: size.width / 1.1,
                child: Text(
                  '60 Members',
                  style: TextStyle(
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // SizedBox(
              //   height: size.height / 20,
              // ),

              // members name
              Flexible(
                child: ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                      ),
                      title: Text(
                        'User 1',
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),

              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.redAccent,
                ),
                title: Text(
                  'Leave Group',
                  style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}