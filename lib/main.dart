import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homies/screens/splash_screen.dart';
import 'package:homies/services/route_generator_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      home: SplashScreen(),
    );
  }
}
