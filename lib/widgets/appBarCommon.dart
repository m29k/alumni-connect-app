import 'package:flutter/material.dart';
import '../styles.dart';

class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  AppBarCommon({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 7,
            spreadRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: page_title_size,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
