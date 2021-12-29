// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:music_player/controller/all%20songs/list_all_songs.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';

import 'package:get/get.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenAllSonges extends StatefulWidget {
  ScreenAllSonges({Key? key}) : super(key: key);

  @override
  State<ScreenAllSonges> createState() => _ScreenAllSongesState();
}

class _ScreenAllSongesState extends State<ScreenAllSonges> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  final allSongsController = AllSongsController();
  final box = Boxes.getInstance();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  List<Audio> songList = [];
  var isLording = ValueNotifier(true);
  @override
  void initState() {
    isLording.value = true;
    fetchSongs();
    super.initState();
    isLording.value = false;
  }

  fetchSongs() async {
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await onAudioQuery.permissionsRequest();
        await allSongsController.fetchDatas();
      }
    }
  }

  // late var audioList = ValueNotifier(allSongsController.fetchSongsList.value);

  @override
  Widget build(BuildContext context) {
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
              valueListenable: box.listenable(),
              builder: (BuildContext context, Box<AllSongsModel> newList,
                  Widget? _) {
                if (isLording.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.separated(
                    itemBuilder: (context, intex) {
                      final songList = newList.values.toList();
                      return showBanner(context, songList, intex);
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
            onPressed: () => dilogBox(),
            icon: Icon(
              Icons.more_vert_outlined,
              color: ReuseWidgets.colorInBody,
            )),
        onTap: () {
          for (var item in newList) {
            songList.add(
              Audio.file(
                item.uri.toString(),
                metas: Metas(
                  title: item.title,
                  artist: item.artist,
                  id: item.id.toString(),
                ),
              ),
            );
          }
          // images(newList, intex);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenPlayingNow(
                    playlist: songList,
                    intex: intex,
                  )));
        });
  }

//show dilog in home page.

  dilogBox() {
    return Get.defaultDialog(
        backgroundColor: Colors.black,
        title: "",
        content: Column(
          children: [
            TextButton.icon(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  'Add to Favorites',
                  style: TextStyle(color: Colors.white),
                )),
            divider,
            TextButton.icon(
                icon: Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                onPressed: () {},
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

  images(List<AllSongsModel> newList, int intex) async {
    final images =
        await onAudioQuery.queryArtwork(newList[intex].id, ArtworkType.AUDIO);
    print(images);
  }
}
