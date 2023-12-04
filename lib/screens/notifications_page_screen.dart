import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPageScreen extends StatefulWidget {
  const NotificationsPageScreen({super.key});

  @override
  State<NotificationsPageScreen> createState() => _NotificationsPageScreenState();
}

class _NotificationsPageScreenState extends State<NotificationsPageScreen> {
  //late Timestamp userLastLogin; // Assume this is set when the user logs in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: Center(
          child: Text('notify'),
        )
    );
  }

}