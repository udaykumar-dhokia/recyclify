import 'package:flutter/material.dart';
import 'package:recyclify/Constants/colors.dart';
import 'package:recyclify/Pages/homepage.dart';
import 'package:recyclify/Pages/orders.dart';
import 'package:recyclify/Pages/profile.dart';
import 'package:recyclify/Pages/recycle.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: primaryColor,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: white,
            ),
            icon: Icon(Icons.home),
            label: 'Home',
            tooltip: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.recycling_sharp,
              color: white,
            ),
            icon: Icon(Icons.recycling_sharp),
            label: 'recyclify',
            tooltip: "recyclify",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.shopping_bag,
              color: white,
            ),
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'Orders',
            tooltip: "Orders",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: white,
            ),
            icon: Icon(Icons.person),
            label: 'Profile',
            tooltip: "Profile",
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        const Homepage(),

        /// Recycle page
        const Recycle(),

        /// Orders page
        const Orders(),

        /// Profile page
        const Profile()
      ][currentPageIndex],
    );
  }
}
