import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_flutter/screens/favorite_screen.dart';
import 'package:news_flutter/screens/news_screen.dart';
import 'package:news_flutter/screens/profile_screen.dart';

import '../api/API.dart';
import '../models/api_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _screens = [const NewsScreen(), const FavoriteScreen(), const ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_index),
      ),
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) {
          setState(() {
            _index = val;
          });
        },
        backgroundColor: Colors.grey,
        borderRadius: 40,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        itemBorderRadius: 40,
        // selectedBackgroundColor: Colors.white,
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home',),
          FloatingNavbarItem(icon: Icons.favorite, title: 'Favorite',),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
        ],
      ),
    );
  }
}
