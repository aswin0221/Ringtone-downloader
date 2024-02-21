import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ringtone_downloder/auth/pages/loginPage.dart';
import 'package:ringtone_downloder/auth/pages/signupPage.dart';
import 'package:ringtone_downloder/model/songs.dart';
import 'package:ringtone_downloder/utilits/playerstate.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ringtone_downloder/widget/circularProgress.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Player extends StatefulWidget {
  Songs song;
  Player({required this.song});
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final _flutterdownload = MediaDownload();

  download() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("UserId") == null) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: SignupPage(),
        ),
      );
    } else {
      await _flutterdownload.downloadMedia(
          context, widget.song!.downloadUrl, "", "${widget.song!.name}");
      String uniq = widget.song.uniqueId;
      FirebaseFirestore.instance
          .collection("users")
          .doc(pref.getString("UserId"))
          .collection("downloads")
          .doc(uniq)
          .set({
        "categoryName": widget.song.categoryName,
        "downloadUrl": widget.song.downloadUrl,
        "isPlaying": widget.song.isPlaying,
        "name": widget.song.name,
        "uniqueId": widget.song.uniqueId,
        "timestamp": FieldValue.serverTimestamp(),
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Downloaded Sucessfully!"),
                elevation: 4,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              )));
    }
  }

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
                            width: MediaQuery.of(context).size.width * 0.002,
                          ),
                          _buildSongDetails(),
                        ],
                      ),
                      _buildActionButtons(),
                    ],
                  ),
                  if (playerModel.isPlayingMap[widget.song.uniqueId] == true)
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
              margin: EdgeInsets.only(left: 1),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: playerModel.isPlayingMap[widget.song.uniqueId] == true
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
            ),
            onTap: () async {
              playerModel.playPause(
                widget.song.uniqueId,
                widget.song.downloadUrl,
              );
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
          width: MediaQuery.of(context).size.width * 0.52,
          child: Text(
            widget.song.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          widget.song.categoryName,
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Consumer<PlayerStates>(
        builder: (context, playerModel, child) => Column(
              children: [
                TextButton(
                  onPressed: () async {
                    download();
                    await playerModel.stopPlay();
                  },
                  child: const Text(
                    "Download",
                    style: TextStyle(color: Colors.green, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      RingtoneSet.setRingtoneFromNetwork(
                              widget.song.downloadUrl)
                          .then((value) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
            ));
  }
}
