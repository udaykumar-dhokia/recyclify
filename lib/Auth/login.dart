import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recyclify/Auth/signup.dart';
import 'package:recyclify/Bottombar/bottombar.dart';
import 'package:recyclify/Components/toast.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';
import 'package:toastification/toastification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isObscure = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool success = false;

  Future<void> Login(
      String _email, String _password, Map<String, dynamic> data) async {
    try {
      setState(() {
        success = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Bottombar(),
        ),
      );
      setState(() {
        success = false;
      });
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
  Widget build(BuildContext context) {
    return success
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitWaveSpinner(
                color: primaryColor,
                waveColor: primaryColor,
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
                        "login",
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 50),
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
                        obscureText: isObscure,
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
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            toast(
                              context,
                              ToastificationType.error,
                              "Error",
                              "Please fill out the details!",
                            );
                          } else {
                            Map<String, dynamic> data = {
                              "email": _email.text.toString(),
                              "password": _password.text.toString(),
                            };
                            Login(_email.text, _password.text, data);
                          }
                          // }
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
                              "Login",
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
                            // Container(
                            //   decoration: const BoxDecoration(
                            //     color: Colors.grey,
                            //   ),
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 1,
                            // ),
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
                      GestureDetector(
                        child: Container(
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
                                  "Login with Google",
                                  style: TextStyle(
                                    fontFamily: font,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member? ",
                            style: TextStyle(fontFamily: font),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUp(),
                                ),
                              );
                            },
                            child: Container(
                              child: Text(
                                "Sign up",
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
