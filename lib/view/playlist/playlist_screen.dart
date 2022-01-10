// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playlist/add_playlist_screen.dart';

class ScreenPlaylist extends StatefulWidget {
  ScreenPlaylist({Key? key}) : super(key: key);

  @override
  State<ScreenPlaylist> createState() => _ScreenPlaylistState();
}

class _ScreenPlaylistState extends State<ScreenPlaylist> {
  final div = const SizedBox(
    height: 10,
  );
  final playlistControler = TextEditingController();
  final _box = Boxes.getInstance();
  // String playlistValue = "";
  List<AllSongsModel> playList = [];
  // ValueNotifier<List<DataBase>> playList = ValueNotifier([]);

  final formKey = GlobalKey<FormState>();
  List allPlaylist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Playlist",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ReuseWidgets.scaffoldBackground, Colors.red])),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ReuseWidgets.scaffoldBackground, Colors.red])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
              //=========================================================
              ValueListenableBuilder(
                  valueListenable: _box.listenable(),
                  builder: (BuildContext context, Box newPlayList, _) {
                    final allKeys = _box.keys.toList();
                    allKeys.remove("allSongs");
                    allKeys.remove("fav");
                    allPlaylist = allKeys.toList();
                    return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, intex) {
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
                                  allPlaylist[intex],
                                  style: TextStyle(
                                      color: ReuseWidgets.colorInBody),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    await Get.defaultDialog(
                                        backgroundColor: Colors.black,
                                        title: "",
                                        content: Container(
                                          child: Center(
                                            child: TextButton(
                                                onPressed: () async {
                                                  await conformMessage(intex);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Delect Playlist',
                                                  style: TextStyle(
                                                      color: ReuseWidgets
                                                          .colorInBody),
                                                )),
                                          ),
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: ReuseWidgets.colorInBody,
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenAddPlaylist(
                                                titlePlaList:
                                                    allPlaylist[intex],
                                              )));
                                });
                          },
                          separatorBuilder: (context, intex) => SizedBox(
                                height: 10,
                              ),
                          itemCount: allPlaylist.length),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

//=======================================================================

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

  conformMessage(int index) async {
    return await Get.defaultDialog(
        title: "",
        content: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 105, 202, 247),
              child: Center(
                child: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 78, 77, 77),
                  size: 50,
                ),
              ),
              radius: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure to delect ?",
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            Text("'${allPlaylist[index]}'"),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
          SizedBox(width: 10),
          IconButton(
              onPressed: () async {
                await _box.delete(allPlaylist[index]);
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.done,
                color: Colors.green,
              ))
        ]);
  }
}
