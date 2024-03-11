import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recyclify/Auth/login.dart';
import 'package:recyclify/Bottombar/bottombar.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';
import 'package:toastification/toastification.dart';
import '../Components/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _locationMessage = '';
  bool isObscure = true;
  double long = 0.0;
  double lat = 0.0;
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool success = false;

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Denied");
      LocationPermission ask = await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      placemarkFromCoordinates(
              currentPosition.latitude, currentPosition.longitude)
          .then((place) {
        if (place.isNotEmpty) {
          setState(() {
            long = currentPosition.longitude;
            lat = currentPosition.latitude;
          });
          log(place[0].toString());
          setState(() {
            _locationMessage =
                "${place[0].street}, ${place[0].locality}, ${place[0].administrativeArea}, ${place[0].country}";
          });
        }
      });
    }
  }

  Future<void> signup(
      String email, String password, Map<String, dynamic> data) async {
    try {
      setState(() {
        success = true;
      });
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        success = false;
      });
      User? user = FirebaseAuth.instance.currentUser;
      log(user!.email.toString());
      final db = FirebaseFirestore.instance.collection("user");
      await db.doc(user.email).set(data);
      toast(
        context,
        ToastificationType.success,
        "Success!",
        "Welcome to the recyclify.",
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Bottombar(),
        ),
      );
    } catch (e) {
      toast(
        context,
        ToastificationType.error,
        "Oops!",
        "Something went wrong...",
      );
      setState(() {
        success = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return success
        ? const Scaffold(
            body: Center(
              child: SpinKitWaveSpinner(
                color: primaryColor,
                size: 50,
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "recyclify.",
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        "signup",
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        cursorColor: primaryColor,
                        controller: _username,
                        decoration: InputDecoration(
                          label: const Text("Name"),
                          labelStyle: TextStyle(
                              fontFamily: font, color: Colors.grey.shade800),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: primaryColor,
                        controller: _email,
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          labelStyle: TextStyle(
                              fontFamily: font, color: Colors.grey.shade800),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        cursorColor: primaryColor,
                        controller: _password,
                        obscureText: false,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  isObscure = !isObscure;
                                },
                              );
                            },
                            child: isObscure
                                ? const Icon(
                                    Icons.visibility,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                  ),
                          ),
                          label: const Text("Password"),
                          labelStyle: TextStyle(
                              fontFamily: font, color: Colors.grey.shade800),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: primaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (_username.text.isEmpty ||
                              _email.text.isEmpty ||
                              _password.text.isEmpty) {
                            toast(
                              context,
                              ToastificationType.error,
                              "Error",
                              "Please fill out the details!",
                            );
                          } else {
                            Map<String, dynamic> data = {
                              "email": _email.text.toString(),
                              "fullname": _username.text.toString(),
                              "password": _password.text.toString(),
                              "address": _locationMessage,
                              "long": long,
                              "lat": lat
                            };
                            signup(_email.text, _password.text, data);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Stack(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Or",
                              style: TextStyle(
                                  fontFamily: font,
                                  fontSize: 15,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ]),
                      const SizedBox(height: 40),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.google,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Sigup with Google",
                                style: TextStyle(
                                  fontFamily: font,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already a member? ",
                            style: TextStyle(fontFamily: font),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: Container(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: font,
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
