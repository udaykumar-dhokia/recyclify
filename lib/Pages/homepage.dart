import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recyclify/Auth/auth.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';
import 'package:recyclify/Extras/variables.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> userData = [];
  String address = "";
  bool _functionCalled = false;
  String greeting = "";
  String selected = "paper";

  void greet() {
    var hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      setState(() {
        greeting = "Good morning";
      });
    } else if (hour >= 12 && hour < 17) {
      setState(() {
        greeting = "Good afternoon";
      });
    } else {
      setState(() {
        greeting = "Good evening";
      });
    }
  }

  getLocation() async {
    if (!_functionCalled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        LocationPermission ask = await Geolocator.requestPermission();
        while (ask != LocationPermission.always ||
            ask != LocationPermission.whileInUse) {
          ask = await Geolocator.requestPermission();
        }
      } else {
        Position currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        placemarkFromCoordinates(
                currentPosition.latitude, currentPosition.longitude)
            .then((place) async {
          if (place.isNotEmpty) {
            log(place.toString());
            setState(
              () {
                curr_address =
                    "${place[0].street}, ${place[0].locality}, ${place[0].administrativeArea}, ${place[0].country}, ${place[0].postalCode}";
                address =
                    "${place[0].street}, ${place[0].locality}, ${place[0].administrativeArea}, ${place[0].country}, ${place[0].postalCode}";
              },
            );
          }
        });
      }
      setState(() {
        _functionCalled = true;
      });
    }
  }

  Future<void> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance
        .collection("user")
        .doc(user!.email)
        .get()
        .then((DocumentSnapshot snap) {
      final data = snap.data() as Map<String, dynamic>;
      setState(() {
        userData.add(data["fullname"]);
        userData.add(data["address"]);
        darkMode = data["darkTheme"];
      });
    });

    log(userData[0]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getLocation();
    greet();
  }

  @override
  Widget build(BuildContext context) {
    return userData.isEmpty
        ? Scaffold(
            backgroundColor: darkMode? Colors.black87 : white,
            body: const Center(
              child: SpinKitWaveSpinner(
                color: primaryColor,
                waveColor: primaryColor,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: darkMode? Colors.black87 : white,
            appBar: AppBar(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              toolbarHeight: 100,
              title: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Current Location',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: white,
                              fontFamily: font,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: address.isEmpty
                            ? Text(
                                "⚲ No location selected",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontFamily: font,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              )
                            : Tooltip(
                                message: curr_address,
                                child: Text(
                                  "⚲ ${address}",
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontFamily: font,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035),
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
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
                    color: white,
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, top: 30, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${greeting},",
                            style: TextStyle(
                                fontFamily: font,
                                color: darkMode? Colors.white54 : Colors.black54,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          Text(userData[0],
                              style: TextStyle(
                                fontFamily: font,
                                color: darkMode? white : Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.07,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 30),
                      // height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkMode? Colors.black38 : primaryLightColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "what do you want to recyclify.",
                            style: TextStyle(
                                color: darkMode? Colors.white54 : Colors.black54,
                                fontFamily: font,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 50,
                                            child: Opacity(
                                              opacity:
                                                  selected == "paper" ? 1 : 0.5,
                                              child: const Image(
                                                image: NetworkImage(
                                                  "https://github.com/udaykumar-dhokia/recyclify/blob/main/lib/Assets/Icons/bin.png?raw=true"),
                                                    // "https://img.freepik.com/premium-vector/newspaper-news-cartoon-vector-illustration-weekly-daily-newspaper-with-articles-flat-icon-outline_385450-1511.jpg"),
                                                fit: BoxFit.fill,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected = "paper";
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 50,
                                            child: Opacity(
                                                opacity: selected == "plastic"
                                                    ? 1
                                                    : 0.5,
                                                child: const Image(
                                                  image: NetworkImage(
                                                    "https://github.com/udaykumar-dhokia/recyclify/blob/main/lib/Assets/Icons/water-bottle.png?raw=true"),
                                                      // "https://img.freepik.com/free-vector/plastic-pollution-concept-illustration_114360-14999.jpg?size=338&ext=jpg&ga=GA1.1.735520172.1710460800&semt=ais"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selected = "plastic";
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
