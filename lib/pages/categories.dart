import 'package:flutter/material.dart';
import 'package:ringtone_downloder/widget/categories_button.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff051c2c),
          title: Text(
            "Categories",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        backgroundColor: Color(0xff051c2c),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoriesButton(
                  categoryName: "love",
                  color: Colors.deepOrangeAccent,
                ),
                CategoriesButton(
                  categoryName: "sad",
                  color: Colors.deepOrange.shade300,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoriesButton(
                  categoryName: "jazz",
                  color: Colors.teal,
                ),
                CategoriesButton(
                  categoryName: "funny",
                  color: Colors.teal.shade300,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoriesButton(
                  categoryName: "family",
                  color: Colors.blue,
                ),
                CategoriesButton(
                  categoryName: "friendship",
                  color: Colors.blue.shade300,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoriesButton(
                  categoryName: "action",
                  color: Colors.purple,
                ),
                CategoriesButton(
                  categoryName: "alarm",
                  color: Colors.purpleAccent,
                ),
              ],
            ),
          ],
        ));
  }
}
