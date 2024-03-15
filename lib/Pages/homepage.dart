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

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> userData = [];
  String address = "";

  getLocation() async {
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
              address =
                  "${place[0].street}, ${place[0].locality}, ${place[0].administrativeArea}, ${place[0].country}, ${place[0].postalCode}";
            },
          );
        }
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
  }

  @override
  Widget build(BuildContext context) {
    return userData.isEmpty
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitWaveSpinner(
                color: primaryColor,
                waveColor: primaryColor,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              backgroundColor: white,
              toolbarHeight: 100,
              title: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userData[0],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
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
                                  fontFamily: font,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              )
                            : Tooltip(
                                message: address,
                                child: Text(
                                  "⚲ ${address}",
                                  style: TextStyle(
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
                  ),
                )
              ],
            ),
            body: const SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(),
              ),
            ),
          );
  }
}
