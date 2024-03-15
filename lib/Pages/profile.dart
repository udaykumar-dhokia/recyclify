import 'dart:developer';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recyclify/Components/Bottombar/bottombar.dart';
import 'package:recyclify/Components/toast.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Constants/fonts.dart';
import 'package:recyclify/Extras/variables.dart';
import 'package:toastification/toastification.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String address = "";
  String mobile = "";
  String long = "";
  String lat = "";
  bool success = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission ask = await Geolocator.requestPermission();
      while (ask != LocationPermission.always) {
        ask = await Geolocator.requestPermission();
      }
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      placemarkFromCoordinates(
              currentPosition.latitude, currentPosition.longitude)
          .then((place) async {
        if (place.isNotEmpty) {
          setState(() {
            long = currentPosition.longitude.toString();
            lat = currentPosition.latitude.toString();
          });
          setState(
            () {
              address =
                  "${place[0].street}, ${place[0].locality}, ${place[0].administrativeArea}, ${place[0].country}";
            },
          );

          User? user = FirebaseAuth.instance.currentUser;
          try {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(user!.email)
                .update({'address': address, "long": long, "lat": lat});
            toast(context, ToastificationType.success, "Address selected",
                "Succussfully select the address");
          } catch (e) {
            toast(context, ToastificationType.error, "Oops!",
                "Something went wrong...");
          }
        }
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Bottombar()));
    }
  }

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
          address = data["address"];
          mobile = data["mobile"];
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

  Navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Profile()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    User? user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance
        .collection("user")
        .doc(user!.email)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      setState(() {
        name = data["fullname"];
        email = data["email"];
        address = data["address"];
        mobile = data["mobile"];
        darkMode = data["darkTheme"];
      });
    });

    _refreshController.refreshCompleted();
  }

  final _email = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return name.isEmpty
        ?  Scaffold(
            backgroundColor: darkMode? Colors.black87 : white,
            body: const Center(
              child: SpinKitWaveSpinner(
                color: primaryColor,
                waveColor: primaryColor,
              ),
            ),
          )
        : SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropMaterialHeader(
              backgroundColor: primaryColor,
            ),
            child: Scaffold(
              backgroundColor: darkMode? Colors.black87 : white,
              appBar: AppBar(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                surfaceTintColor: white,
                toolbarHeight: 100,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, color: white,),
                  ),
                ],
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: white,
                      fontFamily: font,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: white,
                                      radius: 50,
                                      child: ClipOval(
                                        child: Image(
                                          image: NetworkImage(
                                              "https://media.istockphoto.com/id/1389547625/vector/3d-user-icon-in-a-minimalistic-style-user-symbol-for-your-website-design-logo-app-ui.jpg?s=612x612&w=0&k=20&c=J4TGboWXhuQ7SKlRApvGg64d0KpXOhWyxhZr0rZpUvo="),
                                          fit: BoxFit.fill,
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
                                              color: white,
                                              fontFamily: font,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                            ),
                                          ),
                                          Text(
                                            email,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontFamily: font,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(
                                color: darkMode? white : black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                showFlexibleBottomSheet(
                                  context: context,
                                  builder: (BuildContext context,
                                      ScrollController scrollController,
                                      double bottomSheetOffset) {
                                    return _buildBottomSheet(
                                        context,
                                        scrollController,
                                        bottomSheetOffset,
                                        email,
                                        name,
                                        address,
                                        _email,
                                        _name,
                                        _address, () {
                                      getData();
                                    });
                                  },
                                  minHeight: 0,
                                  initHeight: 0.6,
                                  maxHeight: 1,
                                  isSafeArea: true,
                                );
                                getData();
                              },
                              icon:  Icon(Icons.edit_note_sharp,  color: darkMode? white : black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _details(context, name, Icons.person),
                        const SizedBox(
                          height: 10,
                        ),
                        _details(context, email, Icons.email),
                        const SizedBox(
                          height: 10,
                        ),
                        _details(context, mobile, Icons.phone),
                        const SizedBox(
                          height: 10,
                        ),
                        _details(context, address, Icons.location_on),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Container _details(BuildContext context, String title, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 0.2, color: darkMode? white : black),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: darkMode? white : black,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: font,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBottomSheet(
  BuildContext context,
  ScrollController scrollController,
  double bottomSheetOffset,
  String email,
  String name,
  String address,
  TextEditingController _email,
  TextEditingController _name,
  TextEditingController _address,
  Function onSheetClosed,
) {
  return Material(
    child: Scaffold(
      backgroundColor: white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 25),
        child: ListView(
          controller: scrollController,
          children: [
            Text(
              "Edit details",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  fontFamily: font,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                hintText: name,
                prefixIcon: const Icon(Icons.person, color: primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _address,
              decoration: InputDecoration(
                hintText: address,
                prefixIcon: const Icon(Icons.location_on, color: primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (_email.text.isEmpty &&
                    _name.text.isEmpty &&
                    _address.text.isEmpty) {
                  toast(context, ToastificationType.error, "Error!",
                      "Please update your details...");
                } else {
                  User? user = FirebaseAuth.instance.currentUser;
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(user!.email)
                      .update({
                    'fullname': _name.text.isNotEmpty ? _name.text : name,
                    'address':
                        _address.text.isNotEmpty ? _address.text : address,
                  });
                  toast(context, ToastificationType.success, "Details updated",
                      "Succussfully updated your new details");
                  onSheetClosed();
                  Navigator.pop(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontFamily: font,
                          color: white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontFamily: font,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
