// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:music_player/controller/all%20songs/list_all_songs.dart';
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
  @override
  void initState() {
    fetchSongs();

    super.initState();
  }

  fetchSongs() async {
    await allSongsController.premissionStatus();
    await allSongsController.fetchDatas();
    // print(allSongsController.fetchSongsList);
  }

  List<Audio> songList = [];
  // var audioList = ValueNotifier([
  //   Audio("assets/Alan_Walker_Alone.mp3",
  //       metas: Metas(
  //           title: "Alan_Walker_Alone",
  //           artist: "Alan_Walker",
  //           image: MetasImage(
  //               path: "assets/song_image_1.jpg", type: ImageType.asset))),
  //   Audio("assets/Alan-Walker-Faded.mp3",
  //       metas: Metas(
  //           title: "Alan-Walker-Faded",
  //           artist: "Alan_Walker",
  //           image: MetasImage(
  //               path: "assets/song_image_2.jpg", type: ImageType.asset))),
  //   Audio("assets/Alan_Walker_feat_Au_Ra_feat_Tomine_Harket_Darkside.mp3",
  //       metas: Metas(
  //           title: "Alan_Walker_feat_Au_Ra_feat",
  //           artist: "Alan_Walker",
  //           image:
  //               MetasImage(path: "assets/song_3.jpg", type: ImageType.asset))),
  //   Audio(
  //       "assets/Alan_Walker_feat_Sabrina_Carpenter_feat_Farruko_On_My_Way.mp3",
  //       metas: Metas(
  //         title: "Alan_Walker_feat_Sabrina_Carpenter",
  //         artist: "Alan_Walker",
  //         image:
  //             MetasImage(path: "assets/song_4.jpg", type: ImageType.asset), //
  //       )),
  //   Audio("assets/K391_feat_Alan_Walker_feat_Ahrix_End_of_Time.mp3",
  //       metas: Metas(
  //         title: "K391_feat_Alan_Walker",
  //         artist: "Alan_Walker",
  //         image: MetasImage(path: "assets/song_5.jpg", type: ImageType.asset),
  //       ))
  // ]);
  // late var audioList = ValueNotifier(allSongsController.fetchSongsList.value);
  late List<SongModel> value;
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
          child:
              // GetBuilder<AllSongsController>(
              //     init: AllSongsController(),
              //     builder: (controller) {
              //       return ListView.separated(
              //         itemBuilder: (context, intex) {
              //           value = controller.fetchSongsList.cast<SongModel>();
              //           return showBanner(
              //               context,
              //               controller.fetchSongsList.value.cast<SongModel>(),
              //               intex);
              //         },
              //         itemCount: controller.fetchSongsList.length,
              //         separatorBuilder: (ctx, intex) => SizedBox(height: 10),
              //       );
              //     }),
              ValueListenableBuilder(
                  valueListenable: allSongsController.fetchSongsList,
                  builder: (BuildContext context, List<SongModel> newList,
                      Widget? _) {
                    return ListView.separated(
                      itemBuilder: (context, intex) {
                        return showBanner(context, newList, intex);
                      },
                      itemCount: newList.length,
                      separatorBuilder: (ctx, intex) => SizedBox(height: 10),
                    );
                  }),
        ),
      ),
    );
  }

  Widget divider = Divider(
    color: Colors.black,
  );

  Widget showBanner(BuildContext context, List<SongModel> newList, int intex) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //     image: AssetImage(newList[intex].size.toString()),
              //     fit: BoxFit.cover),
            ),
            child: Image(
              image: AssetImage("assets/heroimage.jpg"),
            ),
          ),
        ),
        title: Text(
          newList[intex].title,
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
              Audio.file(item.uri.toString(),
                  metas: Metas(
                    title: item.title,
                    artist: item.artist,
                    id: item.id.toString(),
                  )),
            );
          }
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
}
