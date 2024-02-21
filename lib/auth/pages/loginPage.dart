import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ringtone_downloder/auth/pages/signupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navbar/navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool buttonclicked = false;

  login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        setState(() {
          buttonclicked = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("UserId", FirebaseAuth.instance.currentUser!.uid);
        final document = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("username")
            .doc("username")
            .get();
        await pref.setString("username", "${document['username']}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login Successfully"),
          elevation: 4,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ));
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: NavBar(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          buttonclicked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code.toString()),
          elevation: 4,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill all the fields"),
        elevation: 4,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      buttonclicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff051c2c),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: NavBar(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ],
              ),
              Text(
                "Login to Download",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Text(
                "Unlimited Ringtones",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SvgPicture.asset(
                "assets/images/login.svg",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusColor: Colors.white,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.email_outlined)),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusColor: Colors.white,
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.password_outlined)),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              buttonclicked
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () async {
                            await login(email.text.toString(),
                                password.text.toString());
                            email.clear();
                            password.clear();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.black87),
                          ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't Have an Account ? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Create New",
                        style: TextStyle(color: Colors.blue.shade200),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
