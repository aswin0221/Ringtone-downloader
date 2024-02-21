import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ringtone_downloder/utilits/donwloaded_songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedHistory extends StatefulWidget {
  const DownloadedHistory({super.key});

  @override
  State<DownloadedHistory> createState() => _DownloadedHistoryState();
}

class _DownloadedHistoryState extends State<DownloadedHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff051c2c),
        title: Text(
          "Downloads",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xff051c2c),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 10, top: 10),
        child: Center(child: DownloadedSongs()),
      ),
    );
  }
}
