// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:music_player/view/all_songs/all_songs.dart';
import 'package:music_player/view/bottom_play/bottom_play.dart';
import 'package:music_player/view/favorites/favorites_screen.dart';
import 'package:music_player/view/playlist/playlist_screen.dart';
import 'package:music_player/view/search/screen_search.dart';
import 'package:music_player/view/settings/screen_settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = <Widget>[
    Icon(
      Icons.favorite,
    ),
    Icon(
      Icons.search,
    ),
    Icon(
      Icons.home,
    ),
    Icon(Icons.library_music),
    Icon(Icons.settings),
  ];

  final screens = [
    ScreenFavorites(),
    ScreenScearch(),
    ScreenAllSonges(),
    ScreenPlaylist(),
    ScreenSettings()
  ];
  final buttonbgColors = [
    Colors.black,
    Colors.grey,
    Colors.purple,
    Colors.black,
    Colors.grey,
  ];
  int intex = 2;
  final buttonColors = [
    Colors.red,
    Colors.black,
    Colors.black,
    Colors.red,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    final isKeysbord = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          screens[intex],
          if (!isKeysbord)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: BottomPlay(),
            )
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: buttonColors[intex])),
        child: CurvedNavigationBar(
          items: items,
          index: intex,
          backgroundColor: Colors.transparent,
          color: buttonbgColors[intex],
          buttonBackgroundColor: buttonbgColors[intex],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          height: 60,
          onTap: (value) => setState(() => intex = value),
        ),
      ),
    );
  }
}
