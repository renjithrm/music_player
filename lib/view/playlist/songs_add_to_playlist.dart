// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';

class SongsAddToPlaylist extends StatefulWidget {
  int index;
  SongsAddToPlaylist({Key? key, required this.index}) : super(key: key);

  @override
  _SongsAddToPlaylistState createState() => _SongsAddToPlaylistState();
}

class _SongsAddToPlaylistState extends State<SongsAddToPlaylist> {
  final div = const SizedBox(
    height: 10,
  );
  final playlistControler = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _box = Boxes.getInstance();
  final playlist = ValueNotifier([]);
  List<AllSongsModel> allSongslist = [];
  List<AllSongsModel> playList = [];
  @override
  Widget build(BuildContext context) {
    List allList = _box.get("allSongs");
    allSongslist = allList.cast<AllSongsModel>();
    final allKeys = _box.keys.toList();
    allKeys.remove("fav");
    allKeys.remove("allSongs");
    playlist.value = allKeys;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ReuseWidgets.scaffoldBackground, Colors.red]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Icon(
                      Icons.playlist_add,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                title: const Text(
                  "Create Playlist",
                  style: TextStyle(color: ReuseWidgets.colorInBody),
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (ctx) => showDilogBanner(
                          ctx,
                        )),
              ),
              div,
              ValueListenableBuilder(
                  valueListenable: playlist,
                  builder:
                      (BuildContext context, List<dynamic> newPlaylist, _) {
                    return Expanded(
                        child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.purple),
                            child: Center(
                              child: Icon(
                                Icons.library_music_outlined,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ),
                          title: Text(
                            newPlaylist[index],
                            style: TextStyle(color: ReuseWidgets.colorInBody),
                          ),
                          onTap: () async {
                            List onePlaylist = _box.get(newPlaylist[index]);

                            if (onePlaylist
                                .where((element) =>
                                    element.id.toString() ==
                                    allSongslist[widget.index].id.toString())
                                .isEmpty) {
                              onePlaylist.add(allSongslist[widget.index]);
                              await _box.put(
                                  playlist.value[index], onePlaylist);
                              Get.back();
                              await snackBar(allSongslist[widget.index].title,
                                  "Song add to playlist ${newPlaylist[index]}");
                            } else {
                              Get.back();
                              snackBar(allSongslist[widget.index].title,
                                  "Song alredy exists");
                            }
                          },
                        );
                      },
                      itemCount: newPlaylist.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }

  showDilogBanner(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Dialog(
        child: Container(
          color: ReuseWidgets.scaffoldBackground,
          width: 300,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Create Playlist",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ReuseWidgets.colorInBody),
                ),
                div,

                // formfiel =====================

                Form(
                  key: formKey,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: ReuseWidgets.scaffoldBackground,
                        width: 2,
                      )),
                    ),
                    child: TextFormField(
                      controller: playlistControler,
                      style: TextStyle(color: ReuseWidgets.colorInBody),
                      decoration: InputDecoration(
                        suffix: IconButton(
                          onPressed: () => playlistControler.clear(),
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                        fillColor: Colors.blue,
                        hintText: 'Playlist Name...',
                        hintStyle: TextStyle(color: ReuseWidgets.colorInBody),
                      ),
                      validator: (value) {
                        List keys = _box.keys.toList();
                        if (value!.isEmpty) {
                          return 'Requried*';
                        }
                        if (keys
                            .where((element) => element == value)
                            .isNotEmpty) {
                          return "This name alredy exits";
                        }
                      },
                    ),
                  ),
                ),

                div,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          playlistControler.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String playListName = playlistControler.text;
                          _box.put(playListName, playList);
                          playlistControler.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Create',
                          style: TextStyle(color: Colors.red)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  snackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ReuseWidgets.colorInBody, duration: Duration(seconds: 2));
  }
}
