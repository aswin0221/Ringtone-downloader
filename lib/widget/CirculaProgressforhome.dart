import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../utilits/playerstate.dart';

class CircularForHome extends StatefulWidget {
  const CircularForHome({super.key});

  @override
  State<CircularForHome> createState() => _CircularForHomeState();
}

class _CircularForHomeState extends State<CircularForHome> {
  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showProgress
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : NoInternet();
  }

  Widget NoInternet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/no-connection.svg",
            width: MediaQuery.of(context).size.width * 0.5,
          ),
          Text(
            "Oops! Check your",
            style: TextStyle(
                color: Colors.white70,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
          Text(
            "internet connection",
            style: TextStyle(color: Colors.deepOrange),
          )
        ],
      ),
    );
  }
}
