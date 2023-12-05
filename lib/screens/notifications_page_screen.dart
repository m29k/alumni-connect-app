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
    // Call the fetchNotifications function when the widget is initialized


    fetchNotifications();

  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (notifications.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Center(
          child: Text('No notifications'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
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
      margin: EdgeInsets.all(8.0),
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

    // Retrieve new users
    QuerySnapshot userSnapshot =
        await users.where('created_at', isGreaterThan: lastCloseTime).get();
    for (var userDoc in userSnapshot.docs) {
      fetchedNotifications.add(Notification(
        imageUrl: userDoc['image'],
        title: userDoc['name'],
        dateTime: _parseAndFormatDate(userDoc['created_at']),
      ));
    }

    // Retrieve new posts

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

    // Sort the notifications by timestamp in descending order
    fetchedNotifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    // Update the UI with fetched notifications

    setState(() {
      notifications = fetchedNotifications;
      _isLoading = false;
    });
  }

  DateTime _parseAndFormatDate(dynamic dateValue) {
    if (dateValue is int) {
      // Assuming it's a timestamp in milliseconds (e.g., appCloseTime)
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    } else if (dateValue is String) {
      try {
        // Try parsing as DateTime format (e.g., postedDate)
        return DateTime.parse(dateValue);
      } catch (e) {
        // Handle parsing error, assuming it's a different date format
        // Implement your custom parsing logic here based on the actual format
        // For now, assuming the format is DateTime.now().millisecondsSinceEpoch.toString()
        return DateTime.fromMillisecondsSinceEpoch(int.parse(dateValue));
      }
    } else {
      // Handle other cases or throw an error if needed
      throw Exception('Invalid date format: $dateValue');
    }
  }
}
