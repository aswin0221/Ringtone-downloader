import 'package:flutter/material.dart';
import 'package:ringtone_downloder/utilits/songs_with_category.dart';

class CategoryWiseSongs extends StatefulWidget {
  String CategoryName;

  CategoryWiseSongs({super.key, required this.CategoryName});

  @override
  State<CategoryWiseSongs> createState() => _CategoryWiseSongsState();
}

class _CategoryWiseSongsState extends State<CategoryWiseSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "${widget.CategoryName} Ringtones",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xff051c2c),
        ),
        backgroundColor: Color(0xff051c2c),
        body: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, top: 10),
          child: Center(
              child: SongsWithCategory(categoryname: widget.CategoryName)),
        ));
  }
}
