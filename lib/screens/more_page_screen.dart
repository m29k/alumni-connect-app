import 'package:alumni_connect_app/widgets/appBarCommon.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';
import '../styles.dart';
import './profile_screen.dart';

class MorePageScreen extends StatelessWidget {
  const MorePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatUser user = APIs.me;
    return Scaffold(
      appBar: AppBarCommon(title: 'More'),
      body: Container(
        color: background_color2,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: background_color1,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: background_color2.withOpacity(0.2),
                  // backgroundImage: NetworkImage(userData['image']),
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.name),
                subtitle: Text(user.about),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    // color: Colors.white,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Heading(
              title: 'COMMUNITY',
            ),
            Personal(user: user),
          ],
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  String title;
  Heading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Personal extends StatelessWidget {
  const Personal({
    super.key,
    required this.user,
  });

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background_color1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.notifications_active_outlined,
          // color: Colors.white,
          color: Colors.grey,
        ),
        title: Text(user.name),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(user: APIs.me)));
          },
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            // color: Colors.white,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
