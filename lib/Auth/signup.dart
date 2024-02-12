import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                _textField("Username"),
                const SizedBox(height: 20),
                _textField("Email"),
                const SizedBox(height: 20),
                _textField("Password"),
                const SizedBox(height: 20),
                Container(
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
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or",
                      style: TextStyle(
                          fontFamily: font, fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
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
                    Container(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: font,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
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

  TextFormField _textField(String name) {
    return TextFormField(
      obscureText: name == "Password" ? isObscure : false,
      decoration: InputDecoration(
        suffixIcon: name == "Password"
            ? GestureDetector(
                onTap: () {
                  setState(
                    () {
                      isObscure = !isObscure;
                    },
                  );
                },
                child: !isObscure
                    ? const Icon(
                        Icons.visibility,
                      )
                    : const Icon(
                        Icons.visibility_off,
                      ),
              )
            : null,
        label: Text(name),
        labelStyle: TextStyle(fontFamily: font, color: Colors.grey.shade800),
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
    );
  }
}
