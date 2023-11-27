import 'package:flutter/material.dart';
import '../styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  int selectedIndex;
  void Function(int)? onItemTapped;
  CustomBottomNavBar({
    required this.onItemTapped,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        // horizontal: 5,
        vertical: 5,
      ),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        // color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent_color1.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 20),
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        // backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        // backgroundColor: Colors.red,
        elevation: 0,
        currentIndex: selectedIndex,
        // selectedItemColor: Colors.blue,
        // unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: ActiveIcon(
              iconData: Icons.home,
              title: 'Home',
            ),
            icon: InactiveIcon(
              iconData: Icons.home,
              title: 'Home',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: ActiveIcon(
              iconData: Icons.people,
              title: 'Members',
            ),
            icon: InactiveIcon(
              iconData: Icons.people,
              title: 'Members',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: ActiveIcon(
              iconData: Icons.message,
              title: 'Messages',
            ),
            icon: InactiveIcon(
              iconData: Icons.message,
              title: 'Messages',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: ActiveIcon(
              iconData: Icons.notifications,
              title: 'Notifications',
            ),
            icon: InactiveIcon(
              iconData: Icons.notifications,
              title: 'Notifications',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.transparent,
            activeIcon: ActiveIcon(
              iconData: Icons.menu,
              title: 'More',
            ),
            icon: InactiveIcon(
              iconData: Icons.menu,
              title: 'More',
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

class InactiveIcon extends StatelessWidget {
  IconData iconData;
  String title;
  InactiveIcon({required this.iconData, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.grey,
            size: 20,
          ),
          Text(
            title,
            style: TextStyle(fontSize: small_text_size),
          ),
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Icon(
      //       iconData,
      //       color: Color.fromRGBO(66, 143, 212, 1),
      //       size: 20,
      //     ),
      //     const SizedBox(width: 7),
      //     Text(
      //       title,
      //       style: const TextStyle(
      //         color: Color.fromRGBO(66, 143, 212, 1),
      //         fontSize: 12,
      //         fontFamily: 'Montserrat',
      //         // fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ActiveIcon extends StatelessWidget {
  IconData iconData;
  String title;
  ActiveIcon({required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 50.0,
        maxWidth: double.infinity,
      ),
      margin: EdgeInsets.zero,
      height: 50,
      // width: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: accent_color1.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: accent_color1,
            size: 20,
          ),
          Text(
            title,
            style: TextStyle(fontSize: small_text_size),
          ),
        ],
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     const Spacer(),
      //     Icon(
      //       iconData,
      //       // color: Colors.white,
      //       color: Colors.blue,
      //       size: 30,
      //     ),
      //     const Spacer(),
      //     Container(
      //       width: 60,
      //       height: 4,
      //       decoration: BoxDecoration(
      //         color: Colors.blue,
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(5),
      //           topRight: Radius.circular(5),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Icon(
      //       iconData,
      //       color: Colors.white,
      //       size: 20,
      //     ),
      //     const SizedBox(width: 7),
      //     Text(
      //       title,
      //       style: const TextStyle(
      //         color: Colors.white,
      //         fontSize: 12,
      //         fontFamily: 'Montserrat',
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
