import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ringtone_downloder/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0xff051c2c)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/storypic.svg",
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Text(
                      "Welcome to EasyRings",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                          fontFamily: "Playfair"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Center(
                    child: Text(
                      "Your Personal Ringtone Hub!",
                      style: TextStyle(
                          // color: Color(0xffFF7F7F),
                          color: Colors.deepOrangeAccent,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color: Color(0xffFF474D),
                      color: Colors.deepOrangeAccent),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NavBar(),
                          ));
                    },
                    child: Text(
                      "Get Start",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
