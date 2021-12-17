// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';

class ScreenAllSonges extends StatefulWidget {
  ScreenAllSonges({Key? key}) : super(key: key);

  @override
  State<ScreenAllSonges> createState() => _ScreenAllSongesState();
}

class _ScreenAllSongesState extends State<ScreenAllSonges> {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  var audioList = ValueNotifier([
    Audio("assets/Alan_Walker_Alone.mp3",
        metas: Metas(
            title: "Alan_Walker_Alone",
            artist: "Alan_Walker",
            image: MetasImage(
                path: "assets/song_image_1.jpg", type: ImageType.asset))),
    Audio("assets/Alan-Walker-Faded.mp3",
        metas: Metas(
            title: "Alan-Walker-Faded",
            artist: "Alan_Walker",
            image: MetasImage(
                path: "assets/song_image_2.jpg", type: ImageType.asset))),
    Audio("assets/Alan_Walker_feat_Au_Ra_feat_Tomine_Harket_Darkside.mp3",
        metas: Metas(
            title: "Alan_Walker_feat_Au_Ra_feat",
            artist: "Alan_Walker",
            image:
                MetasImage(path: "assets/song_3.jpg", type: ImageType.asset))),
    Audio(
        "assets/Alan_Walker_feat_Sabrina_Carpenter_feat_Farruko_On_My_Way.mp3",
        metas: Metas(
          title: "Alan_Walker_feat_Sabrina_Carpenter",
          artist: "Alan_Walker",
          image:
              MetasImage(path: "assets/song_4.jpg", type: ImageType.asset), //
        )),
    Audio("assets/K391_feat_Alan_Walker_feat_Ahrix_End_of_Time.mp3",
        metas: Metas(
          title: "K391_feat_Alan_Walker",
          artist: "Alan_Walker",
          image: MetasImage(path: "assets/song_5.jpg", type: ImageType.asset),
        ))
  ]);
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
              valueListenable: audioList,
              builder: (BuildContext context, List<Audio> newList, Widget? _) {
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

  Widget showBanner(BuildContext context, List<Audio> newList, int intex) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AssetImage(newList[intex].metas.image!.path),
              fit: BoxFit.cover),
        ),
      ),
      title: Text(
        newList[intex].metas.title.toString(),
        style: TextStyle(color: ReuseWidgets.colorInBody),
      ),
      subtitle: Text(
        newList[intex].metas.artist.toString(),
        style: TextStyle(color: ReuseWidgets.colorInBody),
      ),
      trailing: popupMenu(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ScreenPlayingNow(
                playlist: newList,
                intex: intex,
              ))),
    );
  }

  Widget popupMenu() {
    return PopupMenuButton(
      color: ReuseWidgets.popupColors,
      elevation: 8,
      padding: EdgeInsets.all(10),
      itemBuilder: (ctx) => [
        PopupMenuItem(
            child: Column(
          children: [
            TextButton(
                onPressed: () {},
                child: Text(
                  'Add to Favorites',
                  style: TextStyle(color: ReuseWidgets.colorInBody),
                )),
            divider,
            TextButton(
                onPressed: () {},
                child: Text(
                  'Add to Playlist',
                  style: TextStyle(color: ReuseWidgets.colorInBody),
                )),
            divider,
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: ReuseWidgets.colorInBody),
                ))
          ],
        )),
      ],
      icon: Icon(
        Icons.more_vert,
        color: ReuseWidgets.colorInBody,
      ),
    );
  }
}
