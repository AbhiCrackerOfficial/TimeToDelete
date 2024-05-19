import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:timetodelete/data/theme_data.dart';
import 'package:timetodelete/pages/layout.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        splash: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? const Image(
                image: AssetImage('assets/images/logo-black.png'),
              )
            : const Image(
                image: AssetImage('assets/images/logo-white.png'),
              ),
        nextScreen: const Layout(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.black
                : Colors.white,
        animationDuration: const Duration(milliseconds: 1000),
        duration: 1800,
        splashIconSize: 200,
        centered: true,
      ),
    );
  }
}
