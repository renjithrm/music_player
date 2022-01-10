// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playlist/songs_add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlayingNow extends StatefulWidget {
  ScreenPlayingNow({
    Key? key,
  }) : super(key: key);
  @override
  State<ScreenPlayingNow> createState() => _ScreenPlayingNowState();
}

class _ScreenPlayingNowState extends State<ScreenPlayingNow> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");

  var musicList = [];

  double deviceHeight = 0;
  double deviceWidth = 0;
  Audio? audio;
//morve forward or backward songs.
  seekSongTime(value) async {
    await assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
  }

//slider in the play screen.
  Widget sliderBar(RealtimePlayingInfos realtimeplayer) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: SliderComponentShape.noThumb,
      ),
      child: Slider(
        value: realtimeplayer.currentPosition.inSeconds.toDouble(),
        max: realtimeplayer.duration.inSeconds.toDouble(),
        onChanged: (value) {
          setState(() {
            seekSongTime(value);
          });
        },
        inactiveColor: Colors.grey,
      ),
    );
  }

  final _box = Boxes.getInstance();
  List<AllSongsModel> allSongs = [];
  final favorites = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    final keys = _box.keys.toList();
    if (keys.where((element) => element == "allSongs").isNotEmpty) {
      List list = _box.get("allSongs");
      allSongs = list.cast<AllSongsModel>();
    }
    if (keys.where((element) => element == "fav").isNotEmpty) {
      favorites.value = _box.get("fav");
    }
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 75, 181, 230), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: buildPage(),
        ),
      ),
    );
  }

//====================================page builder=================
//main part of the page.
  Widget buildPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              Expanded(
                child: Text(
                  "Now Playing",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          assetsAudioPlayer.builderCurrent(builder: (context, nowPlay) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: deviceHeight * 0.3,
                width: deviceWidth * 0.9,
                child: QueryArtworkWidget(
                  artworkFit: BoxFit.cover,
                  id: int.parse(
                    nowPlay.audio.audio.metas.id.toString(),
                  ),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    decoration: BoxDecoration(),
                    child: Image(
                      image: AssetImage("assets/download.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            height: 30,
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimeplayer) {
            return Container(
              width: deviceWidth * 0.8,
              height: deviceHeight * 0.06,
              child: Center(
                child: Text(
                  realtimeplayer.current!.audio.audio.metas.title.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            );
          }),
          SizedBox(
            height: deviceHeight * 0.03,
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimeplayer) {
            return Container(
              width: deviceWidth * 0.8,
              height: deviceHeight * 0.06,
              child: Center(
                child: Text(
                  realtimeplayer.current!.audio.audio.metas.artist.toString(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          Container(
            width: deviceWidth * 0.9,
            height: deviceHeight * 0.03,
            child: assetsAudioPlayer.builderRealtimePlayingInfos(
                builder: (context, realtimeplayer) {
              return sliderBar(realtimeplayer);
            }),
          ),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerBuilder.currentPosition(
                    player: assetsAudioPlayer,
                    builder: (context, duration) {
                      var songTime = getTimeString(duration.inMilliseconds);

                      return Text(
                        songTime,
                        style: TextStyle(color: Colors.white),
                      );
                    }),
                SizedBox(
                  width: deviceWidth * 0.6,
                ),
                assetsAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, realtimeplayer) {
                  return Text(
                    getTimeString(realtimeplayer.duration.inMilliseconds),
                    style: TextStyle(color: Colors.white),
                  );
                })
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.05,
          ),
          assetsAudioPlayer.builderRealtimePlayingInfos(
              builder: (context, realtimeplayer) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ValueListenableBuilder(
                      valueListenable: favorites,
                      builder: (BuildContext context,
                          List<dynamic> newFavorites, _) {
                        return favorites.value
                                .where((element) =>
                                    element.id.toString() ==
                                    realtimeplayer
                                        .current!.audio.audio.metas.id)
                                .isEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: ReuseWidgets.colorInBody,
                                ),
                                onPressed: () async {
                                  var id = realtimeplayer
                                      .current!.audio.audio.metas.id;
                                  var indx = allSongs.indexWhere(
                                      (element) => element.id.toString() == id);
                                  favorites.value.add(allSongs[indx]);
                                  await _box.put("fav", favorites.value);
                                  favorites.notifyListeners();
                                  await snackBar(favorites.value[indx].title,
                                      "song add to favorites");
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  var id = realtimeplayer
                                      .current!.audio.audio.metas.id;
                                  var indx = allSongs.indexWhere(
                                      (element) => element.id.toString() == id);

                                  favorites.value.removeWhere(
                                      (element) => element.id.toString() == id);

                                  await _box.put("fav", favorites.value);
                                  favorites.notifyListeners();
                                  await snackBar(favorites.value[indx].title,
                                      "song remove from favorites");
                                },
                              );
                      }),
                  SizedBox(
                    width: 80,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.playlist_add,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      var id = realtimeplayer.current!.audio.audio.metas.id;
                      var indx = allSongs
                          .indexWhere((element) => element.id.toString() == id);
                      Get.bottomSheet(SongsAddToPlaylist(index: indx));
                    },
                  )
                ],
              ),
            );
          }),
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await previousSong();
                    },
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  assetsAudioPlayer.builderIsPlaying(
                      builder: (context, isPlay) {
                    return isPlay
                        ? IconButton(
                            onPressed: () async {
                              await assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 50,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              await assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ));
                  }),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () async {
                      await nextSong();
                    },
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 50,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//to play next song.
  Future<void> nextSong() async {
    await assetsAudioPlayer.next();
  }

//to play previous song.
  Future<void> previousSong() async {
    await assetsAudioPlayer.previous();
  }

//to play song.
  Future<void> playSong() async {
    await assetsAudioPlayer.play();
  }

//to pause the song.
  pauseSong() async {
    await assetsAudioPlayer.pause();
  }

//to convert the time into song time.
  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }

  snackBar(String title, String message) {
    Get.snackbar(title, message,
        colorText: ReuseWidgets.colorInBody, duration: Duration(seconds: 1));
  }
}
