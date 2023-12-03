import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main_screen.dart';
import '../../styles.dart';
import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';
import '../../widgets/frostedGlassBox.dart';

//login screen -- implements google sign in or sign up feature for app
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  // handles google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const MainScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const MainScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      print(
          '-----------------------------------------------------------------------');
      print('error = $e');
      Dialogs.showSnackbar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  //sign out function
  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      //body
      body: Stack(children: [
        //app logo
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        TitleLogoContent(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            children: <Widget>[
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Color.fromRGBO(241, 200, 76, 1),
                  backgroundColor: background_color3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(42),
                  ),
                ),
                icon: Image.asset('assets/images/google.png',
                    height: mq.height * .03),
                label: Container(
                  padding: EdgeInsets.all(19),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 12,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class TitleLogoContent extends StatelessWidget {
  const TitleLogoContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: const BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Colors.lightBlue,
      //       Colors.white,
      //       Colors.white,
      //       // Colors.teal,
      //       Colors.red
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      // ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: FrostedGlassBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Get Started with IIIT Dharwad Alumni Connect!',
                style: const TextStyle(
                  // color: Colors.white,
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  fontFamily: 'Montserrat',
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(0),
                child: Image.asset('assets/images/icon.png'),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              Text(
                'Join a vibrant community of IIIT Dharwad alumni. Discover and network with former students, explore their achievements, and engage in insightful conversations.',
                style: TextStyle(
                  // color: Colors.white,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
