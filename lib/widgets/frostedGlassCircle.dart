import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedGlassCircle extends StatelessWidget {
  final double diameter;
  final Widget child;

  const FrostedGlassCircle(
      {super.key, required this.diameter, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(diameter * 0.5),
      child: Container(
        width: diameter,
        height: diameter,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 7.0,
                sigmaY: 7.0,
              ),
              child: Container(
                  width: diameter, height: diameter, child: Text(" ")),
            ),
            // Opacity(
            //     opacity: 0.15,
            //     child: Image.asset(
            //       "assets/images/noise.png",
            //       fit: BoxFit.cover,
            //       width: width,
            //       height: height,
            //     )),
            Container(
              decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.black.withOpacity(0.25),
                  //       blurRadius: 30,
                  //       offset: Offset(2, 2))
                  // ],
                  borderRadius: BorderRadius.circular(diameter * 0.5),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1.0),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                        // Colors.black.withOpacity(0.5),
                        // Colors.black.withOpacity(0.1),
                      ],
                      stops: [
                        0.0,
                        1.0,
                      ])),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
