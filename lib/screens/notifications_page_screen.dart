import 'package:alumni_connect_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notification {
  final String? imageUrl;
  final String title;
  final DateTime dateTime;

  Notification({
    this.imageUrl,
    required this.title,
    required this.dateTime,
  });
}

class NotificationsPageScreen extends StatefulWidget {
  const NotificationsPageScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsPageScreen> createState() =>
      _NotificationsPageScreenState();
}

class _NotificationsPageScreenState extends State<NotificationsPageScreen> {
  List<Notification> notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.appBarColor,
          title: const Center(child: Text('Notifications')),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (notifications.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.appBarColor,
          title: const Center(child: Text('Notifications')),
        ),
        body: const Center(
          child: Text('No notifications'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalVariables.appBarColor,
          title: const Center(child: Text('Notifications')),
        ),
        body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(notifications[index]);
          },
        ),
      );
    }
  }

  Widget _buildNotificationCard(Notification notification) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: notification.imageUrl != null
              ? NetworkImage(notification.imageUrl!)
              : const AssetImage('assets/images/userImageIcon.png')
                  as ImageProvider,
        ),
        title: Text(notification.title),
        subtitle: Text(
          'Posted on ${_formatDateTime(notification.dateTime)}',
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  Future<void> fetchNotifications() async {
    setState(() {
      _isLoading = true;
    });
    List<Notification> fetchedNotifications = [];

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? lastCloseTime = pref.getString('appCloseTime');

    //print('last time ${_formatDateTime(_parseAndFormatDate(lastCloseTime))}');

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    QuerySnapshot userSnapshot =
        await users.where('created_at', isGreaterThan: lastCloseTime).get();
    for (var userDoc in userSnapshot.docs) {
      fetchedNotifications.add(Notification(
        imageUrl: userDoc['image'],
        title: userDoc['name'],
        dateTime: _parseAndFormatDate(userDoc['created_at']),
      ));
    }

    int lastCloseTimeMillis = int.parse(lastCloseTime!); // Convert to int

    DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(lastCloseTimeMillis);

    String formattedpsotedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(datetime);

    QuerySnapshot postSnapshot = await posts
        .where('postedDate', isGreaterThan: formattedpsotedDate.toString())
        .get();
    for (var postDoc in postSnapshot.docs) {
      // print(_formatDateTime(_parseAndFormatDate(postDoc['postedDate'])));
      // print('last time ${_formatDateTime(_parseAndFormatDate(lastCloseTime))}');
      fetchedNotifications.add(Notification(
        imageUrl: postDoc['imageUrl'],
        title: postDoc['title'],
        dateTime: _parseAndFormatDate(postDoc['postedDate']),
      ));
    }

    fetchedNotifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    setState(() {
      notifications = fetchedNotifications;
      _isLoading = false;
    });
  }

  DateTime _parseAndFormatDate(dynamic dateValue) {
    if (dateValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    } else if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        return DateTime.fromMillisecondsSinceEpoch(int.parse(dateValue));
      }
    } else {
      throw Exception('Invalid date format: $dateValue');
    }
  }
}
