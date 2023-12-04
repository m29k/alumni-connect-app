import 'package:alumni_connect_app/widgets/appBarCommon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  // color: Colors.white,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me)));
                },
              ),
            ),
            const SizedBox(height: 20),
            Heading(title: 'PERSONAL'),
            PERSONAL(user: user),
            const SizedBox(height: 20),
            Heading(title: 'IIIT DHARWAD'),
            IIITDHARWAD(),
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

class PERSONAL extends StatelessWidget {
  const PERSONAL({
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
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.drive_folder_upload,
              // color: Colors.white,
              color: Colors.grey,
            ),
            title: Text('My Posts'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              // color: Colors.white,
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          ListTile(
            leading: const Icon(
              Icons.settings,
              // color: Colors.white,
              color: Colors.grey,
            ),
            title: Text('Settings'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              // color: Colors.white,
              color: Colors.grey,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class IIITDHARWAD extends StatelessWidget {
  const IIITDHARWAD({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background_color1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.web,
              // color: Colors.white,
              color: Colors.grey,
            ),
            title: Text('Website'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              // color: Colors.white,
              color: Colors.grey,
            ),
            onTap: () {
              const link = "https://www.iiitdwd.ac.in/";
              launch(link);
            },
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          ListTile(
            leading: const Icon(
              Icons.web_asset,
              // color: Colors.white,
              color: Colors.grey,
            ),
            title: Text('AIIMS Portal'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              // color: Colors.white,
              color: Colors.grey,
            ),
            onTap: () {
              const link = "https://aims.iiitdwd.ac.in/aims/";
              launch(link);
            },
          ),
          const Divider(height: 1, indent: 10, endIndent: 10),
          ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              // color: Colors.white,
              color: Colors.grey,
            ),
            title: Text('Location'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              // color: Colors.white,
              color: Colors.grey,
            ),
            onTap: () async {
              String location = Uri.encodeQueryComponent(
                  'Indian Institute of Information Technology (IIIT), Dharwad');
              print(location);

              String url =
                  'https://www.google.com/maps/search/?api=1&query=$location';
              await launch(url);
            },
          ),
        ],
      ),
    );
  }
}
