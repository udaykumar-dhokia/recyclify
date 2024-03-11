import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  bool success = false;

  Future<void> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      setState(() {
        success = true;
      });
      final ref = FirebaseFirestore.instance
          .collection("user")
          .doc(user!.email)
          .get()
          .then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          name = data["fullname"];
          email = data["email"];
        });
      });
      setState(() {
        success = false;
      });
    } catch (e) {
      setState(() {
        success = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return name.isEmpty
        ? const Center(
            child: SpinKitWaveSpinner(
              color: primaryColor,
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 30,
                        bottom: 10,
                      ),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CircleAvatar(
                                  backgroundColor: white,
                                  radius: 50,
                                  child: Center(
                                    child: Text(
                                      name.substring(0, 1),
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 50,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: font,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                      Text(
                                        email,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: font,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // appBar: AppBar(
            //   toolbarHeight: 100,
            //   title: Text(
            //     name,
            //     overflow: TextOverflow.fade,
            //     style: TextStyle(
            //       fontFamily: font,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 25,
            //     ),
            //   ),
            //   actions: [
            //     IconButton(
            //       icon: const Icon(Icons.settings),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
          );
  }
}
