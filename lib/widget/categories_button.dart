import 'package:flutter/material.dart';
import 'package:ringtone_downloder/pages/categoryWiseSongs.dart';

class CategoriesButton extends StatefulWidget {
  String categoryName;
  Color color;

  CategoriesButton(
      {super.key, required this.color, required this.categoryName});

  @override
  State<CategoriesButton> createState() => _CategoriesButtonState();
}

class _CategoriesButtonState extends State<CategoriesButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * (0.12),
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          widget.categoryName,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        )),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryWiseSongs(CategoryName: widget.categoryName)));
      },
    );
  }
}
