import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ringtone_downloder/auth/pages/loginPage.dart';
import 'package:ringtone_downloder/navbar/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  bool buttonclicked = false;

  Signup(String email, String password, String username) async {
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      try {
        setState(() {
          buttonclicked = true;
        });
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => setState(() {
                  buttonclicked = true;
                }));
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("UserId", FirebaseAuth.instance.currentUser!.uid);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("username")
            .doc("username")
            .set({"username": username});
        await pref.setString("username", username);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Registed Successfully"),
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
          margin: EdgeInsets.only(top: 50),
          width: MediaQuery.of(context).size.width,
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
                            ));
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ],
              ),
              Text(
                "Sighup to Download",
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
                "assets/images/sign-up.svg",
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusColor: Colors.white,
                      hintText: "Username",
                      hintStyle: TextStyle(color: Colors.white54),
                      prefixIcon: Icon(Icons.person)),
                  style: TextStyle(color: Colors.white),
                ),
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
                            await Signup(
                                email.text.toString(),
                                password.text.toString(),
                                username.text.toString());
                            email.clear();
                            password.clear();
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(color: Colors.black87),
                          ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Aldredy Have an Account ? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Login Here",
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
