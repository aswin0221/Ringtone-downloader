import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ringtone_downloder/model/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerStates extends ChangeNotifier {
  PlayerStates() {
    player.onDurationChanged.listen((Duration d) {
      duration = d;
      notifyListeners();
    });
    player.onPositionChanged.listen((Duration p) {
      position = p;
      notifyListeners();
    });
    player.onPlayerComplete.listen((_) {
      position = duration;
      notifyListeners();
    });
    fetchIsPlayingData();
    getsongs();
    notifyListeners();
  }

  final AudioPlayer player = AudioPlayer();
  String currentplayer = "";

  Map<String, bool> isPlayingMap = {};

  List<Songs> songs = Songs.allSongs();

  //fetching all songsS
  getsongs() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('ringtones').get();
    List<Songs> localSong = [];
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
        in querySnapshot.docs) {
      localSong.add(Songs(
          categoryName: documentSnapshot['categoryName'],
          downloadUrl: documentSnapshot['downloadUrl'],
          isPlaying: false,
          name: documentSnapshot['name'],
          uniqueId: documentSnapshot['uniqueId']));
    }
    songs = localSong;
    notifyListeners();
  }

  // Future<void> fetchIsPlayingData() async {
  //   for (Songs a in songs) {
  //     isPlayingMap[a.uniqueId] = false;
  //   }
  // }

  Future<void> fetchIsPlayingData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('ringtones').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        String uniqueId = documentSnapshot.id;
        bool isPlaying = false;

        // Populate the map
        isPlayingMap[uniqueId] = isPlaying;
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    notifyListeners();
  }

  Duration duration = const Duration();
  Duration position = const Duration();

  Future<void> playPause(String uniqueId, String downloadUrl) async {
    if (currentplayer.isNotEmpty) {
      await player.stop();
      position = Duration.zero;
      notifyListeners();
      // Songs? currentSong = songs.firstWhere(
      //   (song) => song.uniqueId == currentplayer,
      // );
      // currentSong.isPlaying = false;
      isPlayingMap[currentplayer] = false;
    }
    if (currentplayer != uniqueId) {
      currentplayer = uniqueId;
      // Songs? currentSong = songs.firstWhere(
      //   (song) => song.uniqueId == currentplayer,
      // );
      // currentSong.isPlaying = true;
      isPlayingMap[currentplayer] = true;
      player.play(UrlSource(downloadUrl));
      notifyListeners();
    } else {
      // Songs? currentSong = songs.firstWhere(
      //   (song) => song.uniqueId == currentplayer,
      // );
      // currentSong.isPlaying = false;
      isPlayingMap[currentplayer] = false;
      currentplayer = "";
      player.stop();
      await player.audioCache.clearAll();
      position = Duration.zero;
      notifyListeners();
    }
  }

  Future<void> playerseek(double value) async {
    await player.seek(Duration(seconds: value.toInt()));
    notifyListeners();
  }

  Future<void> stopPlay() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? name = pref.getString("UserId");
    if (currentplayer.isNotEmpty) {
      await player.stop();
      await player.audioCache.clearAll();
      position = Duration.zero;
      isPlayingMap[currentplayer] = false;
      currentplayer = "";
    }
  }
}
