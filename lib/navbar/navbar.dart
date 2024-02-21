import 'package:flutter/material.dart';
import 'package:ringtone_downloder/pages/categories.dart';
import 'package:ringtone_downloder/pages/downloadedHistrory.dart';
import 'package:ringtone_downloder/pages/homePage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentindex = 0;
  List body = const [HomePage(), CategoriesPage(), DownloadedHistory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[_currentindex],
      bottomNavigationBar: Container(
        height: 70,
        color: Color(0xff051c2c),
        // Colors.red,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0.0,
            selectedIconTheme: IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.white30),
            showUnselectedLabels: false,
            showSelectedLabels: false,
            backgroundColor: Color(0xff1B1212),
            currentIndex: _currentindex,
            onTap: (index) {
              setState(() {
                _currentindex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(
                    Icons.home_filled,
                  )),
              BottomNavigationBarItem(
                  label: "categories",
                  icon: Icon(
                    Icons.category,
                  )),
              BottomNavigationBarItem(
                  label: "downloads",
                  icon: Icon(
                    Icons.download_sharp,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
