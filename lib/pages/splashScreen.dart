import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ringtone_downloder/navbar/navbar.dart';
import 'package:ringtone_downloder/pages/storyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../model/songs.dart';
import '../utilits/playerstate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getuser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("username");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/images/spash.json"),
          ],
        ),
      ),
    );
  }
}
