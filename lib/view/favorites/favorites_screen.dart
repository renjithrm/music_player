// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/audio_controller.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavorites extends StatelessWidget {
  ScreenFavorites({Key? key}) : super(key: key);
  final _box = Boxes.getInstance();
  final favorites = ValueNotifier([]);
  final _audioController = AudioController();
  List<Audio> songList = [];
  @override
  Widget build(BuildContext context) {
    List _keys = _box.keys.toList();
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = _box.get("fav");
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, ReuseWidgets.scaffoldBackground])),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, ReuseWidgets.scaffoldBackground])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: favorites.value.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                    valueListenable: favorites,
                    builder:
                        (BuildContext context, List<dynamic> newFavorites, _) {
                      return ListView.separated(
                        itemBuilder: (context, intex) =>
                            showBanner(context, newFavorites, intex),
                        itemCount: newFavorites.length,
                        separatorBuilder: (ctx, intex) => SizedBox(
                          height: 10,
                        ),
                      );
                    }),
              )
            : ValueListenableBuilder(
                valueListenable: favorites,
                builder: (BuildContext context, List<dynamic> list, _) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "NO Favorites Songs added",
                          style: TextStyle(
                              color: ReuseWidgets.colorInBody, fontSize: 30),
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }

  Widget divider = Divider(
    color: Colors.black,
  );

  Widget showBanner(
      BuildContext context, List<dynamic> newFavorites, int index) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: QueryArtworkWidget(
            artworkFit: BoxFit.cover,
            id: favorites.value[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: ClipRRect(
              child: Image(
                image: AssetImage("assets/heroimage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        newFavorites[index].title,
        style: TextStyle(color: ReuseWidgets.colorInBody),
      ),
      trailing: IconButton(
        onPressed: () => showDilogBox(context, newFavorites, index),
        icon: Icon(
          Icons.more_vert,
          color: ReuseWidgets.colorInBody,
        ),
      ),
      onTap: () async {
        songList = _audioController.converterToAudio(newFavorites);
        await _audioController.openToPlayingScreen(songList, index);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ScreenPlayingNow()),
        );
      },
    );
  }

  showDilogBox(BuildContext context, List<dynamic> newFavorites, int index) {
    return Get.defaultDialog(
        backgroundColor: Colors.black,
        title: "",
        content: Column(
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  favorites.value.removeWhere((element) =>
                      element.id.toString() ==
                      newFavorites[index].id.toString());
                  await _box.put("fav", favorites.value);
                  favorites.notifyListeners();
                  Navigator.of(context).pop();

                  await snackBar(
                      newFavorites[index].title, "song remove from favorites");
                },
                child: Text(
                  "Remove from Favorites",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ));
  }

  snackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ReuseWidgets.colorInBody, duration: Duration(seconds: 1));
  }
}
