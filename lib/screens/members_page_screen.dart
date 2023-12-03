import 'package:alumni_connect_app/widgets/appBarCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/dialogs.dart';
import '../styles.dart';
import '../models/chat_user.dart';
import '../api/apis.dart';

class MembersPageScreen extends StatefulWidget {
  // final ChatUser loggedInUser;
  // const MembersPageScreen({super.key, required this.loggedInUser});
  // const MembersPageScreen(this.loggedInUser);
  const MembersPageScreen({super.key});

  @override
  State<MembersPageScreen> createState() => _MembersPageScreenState();
}

class _MembersPageScreenState extends State<MembersPageScreen> {
  List<Map<String, dynamic>> _list = [];
  final List<Map<String, dynamic>> _searchList = [];

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.person_2_fill),
        // backgroundColor: background_color1,
        // backgroundColor: Colors.teal[100],
        backgroundColor: accent_color1.withOpacity(0.3),
        shape: const Border(
          bottom: BorderSide(
            width: 1,
            color: accent_color1,
          ),
          top: BorderSide(
            width: 1,
            color: accent_color1,
          ),
        ),
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                //when search text changes then updated search list
                onChanged: (val) {
                  //search logic
                  _searchList.clear();

                  for (var i in _list) {
                    if (i['name'].toLowerCase().contains(val.toLowerCase()) ||
                        i['email'].toLowerCase().contains(val.toLowerCase())) {
                      _searchList.add(i);
                      setState(() {
                        _searchList;
                      });
                    }
                  }
                },
              )
            : const Text('Members',
                style: TextStyle(fontSize: page_title_size)),
        actions: [
          //search user button
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),
        ],
      ),
      backgroundColor: background_color1,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            // Extract user data from the 'users' collection
            final users = snapshot.data!.docs;
            ChatUser loggedInUser = APIs.me;

            _list.clear();

            for (var userDoc in users) {
              var userData = userDoc.data() as Map<String, dynamic>;
              _list.add(userData);
            }

            if (_list.isNotEmpty) {
              return ListView.builder(
                // itemCount: users.length,
                itemCount: _isSearching ? _searchList.length : _list.length,
                itemBuilder: (context, index) {
                  var userData = users[index].data() as Map<String, dynamic>;

                  // Access 'name' and 'about' fields for each user
                  // var userId = userData['id'];
                  // var name = userData['name'];
                  // var email = userData['email'];
                  // var about = userData['about'] ?? 'No description available';

                  var userId = _isSearching
                      ? _searchList[index]['id']
                      : _list[index]['id'];
                  var name = _isSearching
                      ? _searchList[index]['name']
                      : _list[index]['name'];
                  var email = _isSearching
                      ? _searchList[index]['email']
                      : _list[index]['email'];
                  var about = _isSearching
                      ? _searchList[index]['about']
                      : _list[index]['about'];
                  var image = _isSearching
                      ? _searchList[index]['image']
                      : _list[index]['image'];

                  print(name);
                  print(loggedInUser.name);

                  if (userId == loggedInUser.id) {
                    return SizedBox(); // Return an empty container for logged-in user
                  }

                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: background_color2.withOpacity(0.2),
                          // backgroundImage: NetworkImage(userData['image']),
                          backgroundImage: NetworkImage(image),
                        ),
                        title: Text(name),
                        subtitle: Text(about),
                        trailing: IconButton(
                          onPressed: () async {
                            await APIs.addChatUser(email).then((value) {
                              if (!value) {
                                Dialogs.showSnackbar(
                                    context, 'User does not Exists!');
                              } else {
                                Dialogs.showSnackbar(context,
                                    'Created a New Chat in Messages Tab');
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.add_comment_rounded,
                            // color: Colors.white,
                            color: accent_color1,
                          ),
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No Other Members Found!',
                    style: TextStyle(fontSize: 20)),
              );
            }
          }
        },
      ),
    );
  }
}
