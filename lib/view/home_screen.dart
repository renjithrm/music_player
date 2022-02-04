// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/all%20songs/list_all_songs.dart';
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
    Icon(
      Icons.library_music,
    ),
    Icon(
      Icons.settings,
    ),
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
      body: GetX<AllSongsController>(
        init: AllSongsController(),
        builder: (_screenController) {
          return Stack(
            children: <Widget>[
              screens[_screenController.index.value],
              if (!isKeysbord)
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  child: BottomPlay(),
                )
            ],
          );
        },
      ),
      bottomNavigationBar: GetX<AllSongsController>(
        init: AllSongsController(),
        builder: (_bottomController) {
          return Theme(
            data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                    color: buttonColors[_bottomController.index.value])),
            child: CurvedNavigationBar(
              items: items,
              index: _bottomController.index.value,
              backgroundColor: Colors.transparent,
              color: buttonbgColors[_bottomController.index.value],
              buttonBackgroundColor:
                  buttonbgColors[_bottomController.index.value],
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              height: 60,
              onTap: (value) {
                _bottomController.index.value = value;
              },
            ),
          );
        },
      ),
    );
  }
}
