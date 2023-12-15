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
      // backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        backgroundColor: GlobalVariables.appBarColor,
        title: Center(
          child: Text("MORE"),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: background_color2,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                    backgroundImage: NetworkImage(user.image),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.about),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.teal,
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
              const IIITDHARWAD(),
            ],
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        title,
        style: const TextStyle(
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: background_color1,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.drive_folder_upload,
                color: Colors.teal,
              ),
              title: const Text('My Posts'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
              ),
              onTap: () {},
            ),
            const Divider(height: 1, indent: 10, endIndent: 10),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.teal,
              ),
              title: const Text('Settings'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
              ),
              onTap: () {},
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: background_color1,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.web,
                color: Colors.teal,
              ),
              title: const Text('Website'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
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
                color: Colors.teal,
              ),
              title: const Text('AIIMS Portal'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
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
                color: Colors.teal,
              ),
              title: const Text('Location'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.teal,
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
      ),
    );
  }
}
