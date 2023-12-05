import 'dart:developer';

import 'package:alumni_connect_app/screens/onboarding_screen.dart';
import 'package:alumni_connect_app/widgets/frostedGlassCircle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../api/apis.dart';
import 'auth/login_screen.dart';
import './main_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutSine);

    Future.delayed(const Duration(seconds: 3), () {
      //exit full-screen
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     systemNavigationBarColor: Colors.white,
      //     statusBarColor: Colors.white));

      if (APIs.auth.currentUser != null) {
        log('\nUser: ${APIs.auth.currentUser}');
        //navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        //navigate to login screen
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    });
  }

  Future<void> _saveAppCloseTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('appCloseTime', DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    _saveAppCloseTime();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            // decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.72)),
            decoration: BoxDecoration(color: Colors.black45),
            // decoration: BoxDecoration(color: Colors.white30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              // child: Container(
              //   // width: MediaQuery.of(context).size.width,
              //   // height: MediaQuery.of(context).size.width,
              //   width: 300,
              //   height: 300,
              //   decoration: BoxDecoration(
              //     color: Colors.black54,
              //     // color: Colors.white54,
              //     // borderRadius: BorderRadius.circular(
              //     //     MediaQuery.of(context).size.width * 0.5),
              //     borderRadius: BorderRadius.circular(150),
              //   ),
              //   child: Center(
              // child: Image.asset(
              //   'assets/images/icon.png',
              //   width: 200,
              //   height: 200,
              //   fit: BoxFit.cover,
              // ),
              //   ),
              // ),
              child: FrostedGlassCircle(
                diameter: 300,
                child: Center(
                  child: Image.asset(
                    'assets/images/icon.png',
                    height: 250,
                    width: 250,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
