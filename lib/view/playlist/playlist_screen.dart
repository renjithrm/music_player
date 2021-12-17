// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/controller/playlist_controller.dart';
import 'package:music_player/model/list_model.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/add_playlist/add_playlist_screen.dart';

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

  // String playlistValue = "";

  // ValueNotifier<List<DataBase>> playList = ValueNotifier([]);
  final playlistControllerAdd = PlaylistController();
  final formKey = GlobalKey<FormState>();
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
          child: SingleChildScrollView(
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
                      context: context, builder: (ctx) => showDilogBanner(ctx)),
                ),
                div,
                //=========================================================
                ValueListenableBuilder(
                    valueListenable: playlistControllerAdd.playlistName,
                    builder:
                        (BuildContext context, List<DataBase> newPlayList, _) {
                      return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, intex) {
                            final data = newPlayList[intex];
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
                                data.name.toString(),
                                style:
                                    TextStyle(color: ReuseWidgets.colorInBody),
                              ),
                              trailing: PopupMenuButton(
                                color: ReuseWidgets.popupColors,
                                itemBuilder: (ctx) => [
                                  PopupMenuItem(
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Text('Delect Playlist')))
                                ],
                                icon: Icon(
                                  Icons.more_vert,
                                  color: ReuseWidgets.colorInBody,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ScreenAddPlaylist(
                                            titlePlaList: data.name,
                                          ))),
                            );
                          },
                          separatorBuilder: (context, intex) => SizedBox(
                                height: 10,
                              ),
                          itemCount: newPlayList.length);
                    })
              ],
            ),
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
                        color: Colors.blue,
                        width: 2,
                      )),
                    ),
                    child: TextFormField(
                      controller: playlistControler,
                      style: TextStyle(color: ReuseWidgets.colorInBody),
                      // onChanged: (newPlaylistValue) {
                      //   setState(
                      //     () {
                      //       playlistValue = newPlaylistValue;
                      //     },
                      //   );
                      // },
                      decoration: InputDecoration(
                        suffix: IconButton(
                            onPressed: () => playlistControler.clear(),
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            )),
                        fillColor: Colors.blue,
                        hintText: 'Playlist Name...',
                        hintStyle: TextStyle(color: ReuseWidgets.colorInBody),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Requried*';
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
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          DataBase allData =
                              DataBase(name: playlistControler.text);
                          // playList.value.add(allData);
                          playlistControllerAdd.addPlaylist(allData);
                          // playList.notifyListeners();
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
}
