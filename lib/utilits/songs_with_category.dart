import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_downloder/utilits/playerstate.dart';
import '../model/songs.dart';
import '../widget/player.dart';

class SongsWithCategory extends StatefulWidget {
  String categoryname;
  SongsWithCategory({super.key, required this.categoryname});

  @override
  State<SongsWithCategory> createState() => _SongsWithCategoryState();
}

class _SongsWithCategoryState extends State<SongsWithCategory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerStates>(
      builder: (context, playermodel, child) {
        // Specify the category name you want to filter
        String categoryNameToFilter =
            widget.categoryname; // Replace with the desired category name

        // Filter songs based on the category name
        List<Songs> filteredSongs = playermodel.songs
            .where((song) => song.categoryName == categoryNameToFilter)
            .toList();

        return ListView.builder(
          itemCount: filteredSongs.length,
          itemBuilder: (context, index) {
            Songs song = filteredSongs[index];
            return Player(
              song: song,
            );
          },
        );
      },
    );
  }
}
