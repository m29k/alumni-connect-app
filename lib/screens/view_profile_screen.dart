import 'package:alumni_connect_app/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';

//view profile screen -- to view profile of user
class ViewProfileScreen extends StatelessWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Row(
        children: [
          const Spacer(),
          IconButton(
            // onPressed: () => FocusScope.of(context).unfocus(),
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.cancel_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const Spacer(),
        ],
      ),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user.name,
              style: TextStyle(
                  fontSize: heading_text_size, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // for adding some space
            SizedBox(width: mq.width, height: mq.height * .03),

            //user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .1),
              child: CachedNetworkImage(
                width: mq.height * .2,
                height: mq.height * .2,
                fit: BoxFit.cover,
                imageUrl: user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),

            // for adding some space
            SizedBox(height: mq.height * .03),

            // user email label
            Text(user.email,
                style: const TextStyle(color: Colors.black87, fontSize: 16)),

            // for adding some space
            SizedBox(height: mq.height * .02),

            //user about
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ],
            ),
            Text(
              user.about,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
            SizedBox(height: mq.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Joined On: ',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                Text(
                  MyDateUtil.getLastMessageTime(
                      context: context, time: user.createdAt, showYear: true),
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
