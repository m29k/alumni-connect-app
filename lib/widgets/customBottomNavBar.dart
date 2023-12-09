import 'dart:math';

import 'package:alumni_connect_app/screens/home_page_screen.dart';
import 'package:alumni_connect_app/screens/members_page_screen.dart';
import 'package:alumni_connect_app/screens/messages_page_screen.dart';
import 'package:alumni_connect_app/screens/more_page_screen.dart';
import 'package:alumni_connect_app/screens/notifications_page_screen.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../styles.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   int selectedIndex;
//   void Function(int)? onItemTapped;
//   CustomBottomNavBar({
//     required this.onItemTapped,
//     required this.selectedIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         // horizontal: 5,
//         vertical: 5,
//       ),
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         // color: Colors.lightBlue[100],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: accent_color1.withOpacity(0.2), width: 2),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 20,
//             spreadRadius: 0,
//             offset: Offset(0, 20),
//             color: Colors.black.withOpacity(0.5),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         unselectedFontSize: 0,
//         selectedFontSize: 0,
//         // backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//         // backgroundColor: Colors.red,
//         elevation: 0,
//         currentIndex: selectedIndex,
//         // selectedItemColor: Colors.blue,
//         // unselectedItemColor: Colors.grey,
//         onTap: onItemTapped,
//         items: [
//           BottomNavigationBarItem(
//             backgroundColor: Colors.transparent,
//             activeIcon: ActiveIcon(
//               iconData: Icons.home,
//               title: 'Home',
//             ),
//             icon: InactiveIcon(
//               iconData: Icons.home,
//               title: 'Home',
//             ),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Colors.transparent,
//             activeIcon: ActiveIcon(
//               iconData: Icons.people,
//               title: 'Members',
//             ),
//             icon: InactiveIcon(
//               iconData: Icons.people,
//               title: 'Members',
//             ),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Colors.transparent,
//             activeIcon: ActiveIcon(
//               iconData: Icons.message,
//               title: 'Messages',
//             ),
//             icon: InactiveIcon(
//               iconData: Icons.message,
//               title: 'Messages',
//             ),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Colors.transparent,
//             activeIcon: ActiveIcon(
//               iconData: Icons.notifications,
//               title: 'Notifications',
//             ),
//             icon: InactiveIcon(
//               iconData: Icons.notifications,
//               title: 'Notifications',
//             ),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Colors.transparent,
//             activeIcon: ActiveIcon(
//               iconData: Icons.menu,
//               title: 'More',
//             ),
//             icon: InactiveIcon(
//               iconData: Icons.menu,
//               title: 'More',
//             ),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class InactiveIcon extends StatelessWidget {
//   IconData iconData;
//   String title;
//   InactiveIcon({required this.iconData, required this.title});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(0),
//       decoration: const BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//             color: Colors.grey,
//             size: 20,
//           ),
//           Text(
//             title,
//             style: TextStyle(fontSize: small_text_size),
//           ),
//         ],
//       ),

//     );
//   }
// }

// class ActiveIcon extends StatelessWidget {
//   IconData iconData;
//   String title;
//   ActiveIcon({required this.iconData, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(
//         minWidth: 50.0,
//         maxWidth: double.infinity,
//       ),
//       margin: EdgeInsets.zero,
//       height: 50,
//       // width: 50,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: accent_color1.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             iconData,
//             color: accent_color1,
//             size: 20,
//           ),
//           Text(
//             title,
//             style: TextStyle(fontSize: small_text_size),
//           ),
//         ],
//       ),

//     );
//   }
// }

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 5;

  final List<Widget> bottomBarPages = [
    const HomePageScreen(),
    const MembersPageScreen(),
    const MessagesPageScreen(),
    const NotificationsPageScreen(),
    const MorePageScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: bottomBarPages,
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: GlobalVariables.mainColor,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: GlobalVariables.mainColor,
                  ),
                  activeItem: Icon(Icons.home_filled, color: Colors.white),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.people,
                    color: GlobalVariables.mainColor,
                  ),
                  activeItem: Icon(Icons.people, color: Colors.white),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.message,
                    color: GlobalVariables.mainColor,
                  ),
                  activeItem: Icon(Icons.message, color: Colors.white),
                  itemLabel: 'Page 3',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.notifications,
                    color: GlobalVariables.mainColor,
                  ),
                  activeItem: Icon(Icons.notifications, color: Colors.white),
                  itemLabel: 'Page 4',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.menu,
                    color: GlobalVariables.mainColor,
                  ),
                  activeItem: Icon(Icons.menu, color: Colors.white),
                  itemLabel: 'Page 5',
                ),
              ],
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}
