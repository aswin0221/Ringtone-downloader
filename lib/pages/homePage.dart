import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_downloder/auth/pages/signupPage.dart';
import 'package:ringtone_downloder/utilits/allsongs.dart';
import 'package:ringtone_downloder/utilits/songs_with_category.dart';
import 'package:ringtone_downloder/widget/CirculaProgressforhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilits/playerstate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";
  String greetings = "";
  String name = "";
  String? Uid;

  Future<String> getusername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Uid = pref.getString("UserId");
    // final docsnapshots = await FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(Uid)
    //     .collection("username")
    //     .doc("username")
    //     .get();
    if (pref.getString("username") != null) {
      final username = pref.getString("username");
      return username!;
    } else {
      return '';
    }
  }

  Future<void> initUserData() async {
    try {
      String fetchedUsername = await getusername();
      setState(() {
        username = fetchedUsername;
      });
    } catch (error) {
      // Handle any potential errors
      print("Error fetching username: $error");
    }
  }

  //Greetings by current Time
  void greetBasedOnTime() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      setState(() {
        greetings = "Good morning!";
      });
    } else if (hour >= 12 && hour < 17) {
      setState(() {
        greetings = "Good afternoon!";
      });
    } else if (hour >= 17 && hour < 21) {
      setState(() {
        greetings = "Good evening!";
      });
    } else {
      setState(() {
        greetings = "Good night!";
      });
    }
  }

  bool internet = false;

  //Checking for internet

  void checkinternet() async {
    final result = await InternetAddress.lookup("google.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      setState(() {
        internet = true;
      });
    }
  }

  login() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            child: SignupPage(), type: PageTransitionType.rightToLeft));
  }

  logout() async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    setState(() {
      Uid = null;
    });
    preff.remove("UserId").then((value) => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
              'Logout Sucssfully',
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    greetBasedOnTime();
    checkinternet();
    initUserData();
    Consumer<PlayerStates>(
        builder: (context, playermodel, child) => playermodel.getsongs());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerStates>(
        builder: (context, playerModel, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff051c2c),
              toolbarHeight: 100,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Uid != null)
                    Row(
                      children: [
                        Text(
                          "Welcome ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          username ?? "",
                          style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        )
                      ],
                    ),
                  Text(
                    greetings,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              actions: [
                if (Uid == null)
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                        onPressed: () async {
                          print("Aswin its done $Uid");
                          login();
                          await playerModel.stopPlay();
                        },
                        child: Text(
                          "login",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        )),
                  ),
                if (Uid != null)
                  Container(
                    margin: EdgeInsets.only(right: 15),
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.red.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                        onPressed: () async {
                          logout();
                          playerModel.stopPlay();
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        )),
                  ),
              ],
            ),
            backgroundColor: Color(0xff051c2c),
            body: internet ? HomePageContent() : CircularForHome()));
  }

  Widget HomePageContent() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Newly Added",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(child: Center(child: AllSongs())),
        ],
      ),
    );
  }
}
