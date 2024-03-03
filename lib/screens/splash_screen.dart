import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimation = false;

  @override
  void initState() {
    Timer(
      const Duration(seconds: 1),
      () {
        setState(() {
          isAnimation = true;
        });
      },
    );

    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacementNamed(
          context,
          '/on-board',
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "H",
              style: GoogleFonts.ptSerif(
                color: AppColors.secondaryText,
                fontSize: 70,
              ),
            ),
          ),
          Center(
            child: Text(
              "Homies".toUpperCase(),
              style: TextStyle(
                color: AppColors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: isAnimation ? 200 : 0,
            height: isAnimation ? 70 : 0,
            child: Lottie.asset(
              "assets/splash-loading.json",
            ),
          )
        ],
      ),
    );
  }
}
