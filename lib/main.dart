import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recyclify/Auth/signup.dart';
import 'package:recyclify/Constants/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Made with ",
              style: TextStyle(fontFamily: "Sans Serif", fontSize: 15),
            ),
            Icon(
              Icons.favorite,
              color: primaryColor,
            ),
            Text(
              " in India.",
              style: TextStyle(fontFamily: "Sans Serif", fontSize: 15),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "recyclify.",
          style: TextStyle(
            fontFamily: "Sans Serif",
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}
