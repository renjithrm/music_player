// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:music_player/controller/all%20songs/list_all_songs.dart';
import 'package:music_player/controller/audio_controller.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';

import 'package:get/get.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:music_player/view/playlist/songs_add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenAllSonges extends StatefulWidget {
  ScreenAllSonges({Key? key}) : super(key: key);

  @override
  State<ScreenAllSonges> createState() => _ScreenAllSongesState();
}

class _ScreenAllSongesState extends State<ScreenAllSonges> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final allSongsController = AllSongsController();
  final _audioController = AudioController();
  final box = Boxes.getInstance();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  List<Audio> songList = [];
  final allSongs = ValueNotifier(<AllSongsModel>[]);
  final favorites = ValueNotifier([]);
  var isLording = ValueNotifier(true);
  // @override
  // void initState() {
  //   fetchSongs();
  //   super.initState();
  // }

  // fetchSongs() async {
  //   isLording.value = false;
  //   List _keys = box.keys.toList();
  //   if (!kIsWeb) {
  //     bool permissionStatus = await onAudioQuery.permissionsStatus();
  //     if (!permissionStatus) {
  //       await onAudioQuery.permissionsRequest();
  //       await allSongsController.fetchDatas();
  //     } else {
  //       if (_keys.where((element) => element == "allSongs").isNotEmpty) {
  //         List list = box.get("allSongs");
  //         allSongs.value = list.cast<AllSongsModel>();
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    isLording.value = false;
    List _keys = box.keys.toList();
    if (_keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = box.get("allSongs");
      allSongs.value = list.cast<AllSongsModel>();
    }
    if (_keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = box.get("fav");
    }
    // allSongs.value = box.get("allSongs");
    return Scaffold(
      appBar: AppBar(
        title: ReuseWidgets.title,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ReuseWidgets.scaffoldBackground,
                Colors.purple,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ReuseWidgets.scaffoldBackground,
              Colors.purple,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
              valueListenable: allSongs,
              builder: (BuildContext context, List<AllSongsModel> newList,
                  Widget? _) {
                if (isLording.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.separated(
                    itemBuilder: (context, intex) {
                      return showBanner(context, newList, intex);
                    },
                    itemCount: newList.length,
                    separatorBuilder: (ctx, intex) => SizedBox(height: 10),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget divider = Divider(
    color: Colors.black,
  );

  Widget showBanner(
      BuildContext context, List<AllSongsModel> newList, int intex) {
    return ListTile(
        leading: Hero(
          tag: intex,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: QueryArtworkWidget(
                id: newList[intex].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Image(
                  image: AssetImage("assets/heroimage.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          newList[intex].title,
          maxLines: 1,
          style: TextStyle(color: ReuseWidgets.colorInBody),
        ),
        subtitle: Text(
          newList[intex].artist.toString(),
          style: TextStyle(color: ReuseWidgets.colorInBody),
        ),
        trailing: IconButton(
            onPressed: () => dilogBox(intex, newList),
            icon: Icon(
              Icons.more_vert_outlined,
              color: ReuseWidgets.colorInBody,
            )),
        onTap: () async {
          try {
            songList = await _audioController.converterToAudio(newList);
            await _audioController.openToPlayingScreen(songList, intex);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ScreenPlayingNow()),
            );
          } catch (err) {
            await Get.defaultDialog(
                titleStyle: TextStyle(color: ReuseWidgets.colorInBody),
                backgroundColor: Colors.black,
                content: Container(
                  child: Text(
                    "Audio not found",
                    style: TextStyle(color: ReuseWidgets.colorInBody),
                  ),
                ),
                cancel: TextButton(
                    onPressed: () => Get.back<ScreenAllSonges>(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: ReuseWidgets.colorInBody),
                    )));
          }
        });
  }

//show dilog in home page.

  dilogBox(int index, List<AllSongsModel> newList) {
    return Get.defaultDialog(
        backgroundColor: Colors.black,
        title: "",
        content: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: favorites,
                builder: (BuildContext context, List<dynamic> newHive, _) {
                  return favorites.value
                          .where((element) =>
                              element.id.toString() ==
                              newList[index].id.toString())
                          .isEmpty
                      ? TextButton.icon(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            favorites.value.add(newList[index]);
                            await box.put("fav", favorites.value);
                            favorites.notifyListeners();
                            Get.back();
                            await snackBar(
                                newList[index].title, "song add to favorites");
                          },
                          label: Text(
                            'Add to Favorites',
                            style: TextStyle(color: Colors.white),
                          ))
                      : TextButton.icon(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            favorites.value.removeWhere((element) =>
                                element.id.toString() ==
                                newList[index].id.toString());
                            await box.put("fav", favorites.value);
                            favorites.notifyListeners();
                            Get.back();
                            await snackBar(newList[index].title,
                                "song remove from favorites");
                            // Navigator.of(context).pop();
                          },
                          label: Text(
                            'Remove from Favorites',
                            style: TextStyle(color: Colors.white),
                          ));
                }),
            divider,
            TextButton.icon(
                icon: Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  Get.bottomSheet(SongsAddToPlaylist(index: index));
                },
                label: Text(
                  'Add to Playlist',
                  style: TextStyle(color: Colors.white),
                )),
            divider,
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ));
  }

  snackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ReuseWidgets.colorInBody, duration: Duration(seconds: 2));
  }
}
