import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_downloder/auth/pages/loginPage.dart';
import 'package:ringtone_downloder/auth/pages/signupPage.dart';
import 'package:ringtone_downloder/utilits/playerstate.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/songs.dart';

class PlayerForDownloads extends StatefulWidget {
  DocumentSnapshot? ds;
  PlayerForDownloads({required this.ds});
  @override
  State<PlayerForDownloads> createState() => _PlayerForDownloadsState();
}

class _PlayerForDownloadsState extends State<PlayerForDownloads> {
  delete() async {
    SharedPreferences preff = await SharedPreferences.getInstance();
    String user = await preff.getString("UserId")!;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user)
          .collection("downloads")
          .doc(widget.ds!['uniqueId'])
          .delete();
    } on FirebaseException catch (e) {
      print("errorrrrr $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerStates>(
      builder: (context, playerModel, child) => Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildPlayButton(),
                          SizedBox(
                            width: 10,
                          ),
                          _buildSongDetails(),
                        ],
                      ),
                      _buildActionButtons(),
                    ],
                  ),
                  if (playerModel.isPlayingMap[widget.ds!["uniqueId"]] == true)
                    Slider(
                      min: 0,
                      max: playerModel.duration.inSeconds.toDouble(),
                      value: playerModel.position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        await playerModel.playerseek(value);
                        setState(() {});
                      },
                      activeColor: Colors.blue,
                      inactiveColor: Colors.white,
                      thumbColor: Colors.blue,
                    )
                ],
              ),
              SizedBox(
                height: 0,
              ),
              const Divider(
                height: 5,
                color: Colors.white12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Consumer<PlayerStates>(
      builder: (context, playerModel, child) => Row(
        children: [
          GestureDetector(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: playerModel.isPlayingMap[widget.ds!["uniqueId"]] == true
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            ),
            onTap: () async {
              playerModel.playPause(
                  widget.ds!['uniqueId'], widget.ds!['downloadUrl']);
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _buildSongDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          child: Text(
            widget.ds!['name'],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          widget.ds!['categoryName'],
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              await delete();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            )),
        TextButton(
          onPressed: () {
            try {
              RingtoneSet.setRingtoneFromNetwork(widget.ds!['downloadUrl'])
                  .then((value) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Ringtone Set Sussesfully!"),
                        elevation: 4,
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      )));
            } catch (e) {
              print(e);
            }
          },
          child: Text(
            "Set Ringtone",
            style: TextStyle(color: Colors.deepOrange.shade300),
          ),
        ),
      ],
    );
  }
}
