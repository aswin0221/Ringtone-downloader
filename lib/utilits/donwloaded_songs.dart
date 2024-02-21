import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_downloder/utilits/playerstate.dart';
import 'package:ringtone_downloder/widget/PlayerForDownloads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/player.dart';

class DownloadedSongs extends StatefulWidget {
  const DownloadedSongs({super.key});

  @override
  State<DownloadedSongs> createState() => _DownloadedSongsState();
}

class _DownloadedSongsState extends State<DownloadedSongs> {
  String? user;

  getuser() async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    setState(() {
      user = preff.getString("UserId")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    if (user == "") {
      return Text("no downloads");
    } else {
      return Consumer<PlayerStates>(
        builder: (context, playermodel, child) => StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user)
                .collection('downloads')
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length == 0) {
                  return NoDownloads();
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return PlayerForDownloads(ds: ds);
                      });
                }
              } else {
                return Text("hello");
              }
            }),
      );
    }
  }

  Widget NoDownloads() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/empty.svg",
          width: MediaQuery.of(context).size.width * 0.6,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "No downloads!",
          style: TextStyle(
              color: Colors.white70,
              fontSize: MediaQuery.of(context).size.width * 0.06),
        )
      ],
    );
  }
}
