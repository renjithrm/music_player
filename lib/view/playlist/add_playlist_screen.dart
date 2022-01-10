// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/audio_controller.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenAddPlaylist extends StatefulWidget {
  String titlePlaList;
  ScreenAddPlaylist({Key? key, required this.titlePlaList}) : super(key: key);

  @override
  State<ScreenAddPlaylist> createState() => _ScreenAddPlaylistState();
}

class _ScreenAddPlaylistState extends State<ScreenAddPlaylist> {
  final _box = Boxes.getInstance();
  final _audioController = AudioController();
  ValueNotifier<List<AllSongsModel>> allSongs =
      ValueNotifier(<AllSongsModel>[]);

  final list = ValueNotifier([]);
  List<Audio> songList = [];
  @override
  Widget build(BuildContext context) {
    List allList = _box.get("allSongs");
    allSongs.value = allList.cast<AllSongsModel>();

    list.value = _box.get(widget.titlePlaList);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titlePlaList.toUpperCase()),
        backgroundColor: ReuseWidgets.scaffoldBackground,
        elevation: 0,
      ),
      backgroundColor: ReuseWidgets.scaffoldBackground,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                  onPressed: () async {
                    return await Get.bottomSheet(
                      bottomSheet(context),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Add songs',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )),
              ValueListenableBuilder(
                  valueListenable: list,
                  builder: (BuildContext context, List newPlaylistSongs, _) {
                    List newPlaylist = newPlaylistSongs.toList();
                    return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async {
                                  songList = _audioController
                                      .converterToAudio(newPlaylist);
                                  await _audioController.openToPlayingScreen(
                                      songList, index);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenPlayingNow()),
                                  );
                                },
                                leading: Hero(
                                  tag: index,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: QueryArtworkWidget(
                                        // id: newPlaylistSongs[index].id,
                                        id: newPlaylist[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: Image(
                                          image: AssetImage(
                                              "assets/heroimage.jpg"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  //  newPlaylistSongs[index].title,
                                  newPlaylist[index].title,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: ReuseWidgets.colorInBody),
                                ),
                                subtitle: Text(
                                  // newPlaylistSongs[index].artist.+
                                  // toString(),
                                  newPlaylist[index].artist,
                                  style: TextStyle(
                                      color: ReuseWidgets.colorInBody),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: "",
                                        content: Container(
                                          child: Center(
                                            child: TextButton(
                                                onPressed: () async {
                                                  list.value.remove(
                                                      list.value[index]);
                                                  await _box.put(
                                                      widget.titlePlaList,
                                                      list.value);
                                                  list.notifyListeners();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Delect from playlist',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ),
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: ReuseWidgets.colorInBody,
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                            itemCount: newPlaylistSongs.length));
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          colors: [
            ReuseWidgets.scaffoldBackground,
            Colors.purple,
          ],
        ),
      ),
      child: ValueListenableBuilder(
          valueListenable: allSongs,
          builder: (BuildContext context, List allSongsList, _) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showBanner(context, allSongsList, index),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemCount: allSongsList.length);
          }),
    );
  }

  Widget showBanner(BuildContext context, List newList, int intex) {
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
      trailing: ValueListenableBuilder(
          valueListenable: list,
          builder: (BuildContext context, List playlistSongs, _) {
            // list.value = _box.get(widget.titlePlaList);

            return list.value
                    .where((element) => element.id == allSongs.value[intex].id)
                    .isEmpty
                ? IconButton(
                    onPressed: () async {
                      list.value.add(newList[intex]);
                      await _box.put(widget.titlePlaList, list.value);
                      list.notifyListeners();
                      // list.value = _box.get(widget.titlePlaList);
                    },
                    icon: Icon(
                      Icons.add,
                      color: ReuseWidgets.colorInBody,
                    ))
                : IconButton(
                    onPressed: () async {
                      list.value.removeWhere((element) =>
                          element.id.toString() ==
                          allSongs.value[intex].id.toString());
                      await _box.put(widget.titlePlaList, list.value);
                      list.notifyListeners();
                    },
                    icon: Icon(
                      Icons.remove,
                      color: ReuseWidgets.colorInBody,
                    ));
          }),
    );
  }
}
