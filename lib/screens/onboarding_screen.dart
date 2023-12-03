import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:lottie/lottie.dart';

import '../screens/auth/login_screen.dart';
import '../styles.dart';
import '../widgets/frostedGlassBox.dart';

class OnboardingScreen extends StatefulWidget {
  static const String id = '/onboarding_screen';
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  double _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          PageView.builder(
            itemCount: onboard_data.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index.toDouble();
                // _pageIndex++;
              });
            },
            itemBuilder: (context, index) => OnboardSlide(
              title: onboard_data[index].title,
              description: onboard_data[index].description,
              imageLocation: onboard_data[index].imageLocation,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Color.fromRGBO(241, 200, 76, 1),
                    backgroundColor: background_color3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(19),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'PROCEED',
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
                    _pageIndex.toInt() == onboard_data.length - 1
                        ? Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()))
                        : _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DotsIndicator(
                  dotsCount: onboard_data.length,
                  position: _pageIndex,
                  decorator: DotsDecorator(activeColor: Colors.white),
                ),
                const SizedBox(
                  height: 43,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardDataModel {
  final String imageLocation;
  final String title;
  final String description;
  OnboardDataModel({
    required this.title,
    required this.description,
    required this.imageLocation,
  });
}

final List<OnboardDataModel> onboard_data = [
  OnboardDataModel(
    title: 'Explore IIITDWD Alumni Profiles',
    description:
        'Browse through a diverse pool of alumni profiles. Discover their career paths, experiences, and contributions. Connect and learn from their insights and expertise.',
    imageLocation: 'assets/images/onboarding1.json',
  ),
  OnboardDataModel(
    title: 'Engage in Conversations',
    description:
        'Initiate discussions, ask questions, and seek advice through our chat feature. Network with alumni, share experiences, and foster meaningful connections.',
    imageLocation: 'assets/images/onboarding2.json',
  ),
  OnboardDataModel(
    title: 'Stay Updated with Feeds',
    description:
        'Explore the latest happenings and events posted by alumni. Stay informed about gatherings, meetups, and activities. Engage with the vibrant community through the feed.',
    imageLocation: 'assets/images/onboarding3.json',
  ),
];

class OnboardSlide extends StatelessWidget {
  final String imageLocation;
  final String title;
  final String description;

  OnboardSlide({
    required this.imageLocation,
    required this.title,
    required this.description,
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
                title,
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
                child: Lottie.asset(imageLocation),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(),
              Text(
                description,
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
