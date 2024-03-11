import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recyclify/Auth/auth.dart';
import 'package:recyclify/Constants/fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String address = "";

  Future<void> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance
        .collection("user")
        .doc(user!.email)
        .get()
        .then((DocumentSnapshot snap) {
      final data = snap.data() as Map<String, dynamic>;
      setState(() {
        address = data["address"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Auth(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          )
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
