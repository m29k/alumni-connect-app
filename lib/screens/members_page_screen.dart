import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/dialogs.dart';
import '../styles.dart';
import '../models/chat_user.dart';
import '../api/apis.dart';

class MembersPageScreen extends StatelessWidget {
  // final ChatUser loggedInUser;
  // const MembersPageScreen({super.key, required this.loggedInUser});
  // const MembersPageScreen(this.loggedInUser);
  const MembersPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator(); // Display a loading indicator
          } else {
            // Extract user data from the 'users' collection
            final users = snapshot.data!.docs;
            ChatUser loggedInUser = APIs.me;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var userData = users[index].data() as Map<String, dynamic>;

                // Access 'name' and 'about' fields for each user
                var userId = userData['id'];
                var name = userData['name'];
                var email = userData['email'];
                var about = userData['about'] ?? 'No description available';
                print(name);
                print(loggedInUser.name);

                if (userId == loggedInUser.id) {
                  return SizedBox(); // Return an empty container for logged-in user
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: background_color2.withOpacity(0.2),
                    backgroundImage: NetworkImage(userData['image']),
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
                          Dialogs.showSnackbar(
                              context, 'Created a New Chat in Messages Tab');
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_comment_rounded,
                      // color: Colors.white,
                      color: accent_color1,
                    ),
                  ),
                  // You can add more widgets to display additional user information
                );
              },
            );
          }
        },
      ),
    );
  }
}
