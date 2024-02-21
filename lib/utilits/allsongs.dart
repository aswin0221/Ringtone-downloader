import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_downloder/model/songs.dart';
import 'package:ringtone_downloder/utilits/playerstate.dart';
import '../widget/player.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({super.key});

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerStates>(
        builder: (context, playermodel, child) => ListView.builder(
            itemCount: playermodel.songs.length,
            itemBuilder: (context, index) {
              Songs song = playermodel.songs[index];
              return Player(
                song: song,
              );
            }));
  }
}
