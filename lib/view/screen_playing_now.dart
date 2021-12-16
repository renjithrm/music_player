// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ScreenPlayingNow extends StatefulWidget {
  ScreenPlayingNow({Key? key}) : super(key: key);

  @override
  State<ScreenPlayingNow> createState() => _ScreenPlayingNowState();
}

class _ScreenPlayingNowState extends State<ScreenPlayingNow> {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  late bool isPlay;
  Color favoriteIconeColor = Colors.white;
  @override
  void initState() {
    initPlaySong();
    isPlay = true;
    super.initState();
  }

  var audioList = [
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
            title: "Alan_Walker_feat_Au_Ra_feat_Tomine_Harket_Darkside",
            artist: "Alan_Walker",
            image:
                MetasImage(path: "assets/song_3.jpg", type: ImageType.asset))),
    Audio(
        "assets/Alan_Walker_feat_Sabrina_Carpenter_feat_Farruko_On_My_Way.mp3",
        metas: Metas(
          title: "Alan_Walker_feat_Sabrina_Carpenter_feat_Farruko_On_My_Way",
          artist: "Alan_Walker",
          image:
              MetasImage(path: "assets/song_4.jpg", type: ImageType.asset), //
        )),
    Audio("assets/K391_feat_Alan_Walker_feat_Ahrix_End_of_Time.mp3",
        metas: Metas(
          title: "K391_feat_Alan_Walker_feat_Ahrix_End_of_Time",
          artist: "Alan_Walker",
          image: MetasImage(path: "assets/song_5.jpg", type: ImageType.asset),
        ))
  ];
  Future<void> initPlaySong() async {
    await assetsAudioPlayer.open(
      //Audio("assets/Alan_Walker_Alone.mp3"),
      Playlist(audios: audioList),
      showNotification: true,
      notificationSettings: NotificationSettings(
        playPauseEnabled: true,
        customPlayPauseAction: (asset) {
          if (isPlay) {
            pauseSong();
            setState(() {
              isPlay = false;
            });
          } else if (!isPlay) {
            playSong();
            setState(() {
              isPlay = true;
            });
          }
        },
      ),
      loopMode: LoopMode.playlist,
    );
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = assetsAudioPlayer.isPlaying.value;
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('assets/playnow_background.png'),
                    fit: BoxFit.cover)),
            child: assetsAudioPlayer.builderRealtimePlayingInfos(builder:
                (BuildContext context, RealtimePlayingInfos realtimeplayer) {
              if (realtimeplayer != null) {
                return buildPage(realtimeplayer);
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            })),
      ),
    );
  }

//====================================page builder=================

  Widget buildPage(RealtimePlayingInfos realtimeplayer) {
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
            height: 30,
          ),
          Hero(
            tag: "myImage",
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(
                        realtimeplayer.current!.audio.audio.metas.image!.path),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 300,
            height: 30,
            // color: ReuseWidgets.scaffoldBackground,
            child: Center(
              child: Text(
                realtimeplayer.current!.audio.audio.metas.title.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            height: 30,
            // color: ReuseWidgets.scaffoldBackground,
            child: Center(
              child: Text(
                realtimeplayer.current!.audio.audio.metas.artist.toString(),
                style: TextStyle(
                    color: Colors.grey[350],
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 340,
            height: 30,
            child: LinearPercentIndicator(
              backgroundColor: Colors.grey,
              progressColor: Colors.white,
              percent: realtimeplayer.currentPosition.inSeconds /
                  realtimeplayer.duration.inSeconds,
            ),
          ),
          SizedBox(
            height: 10,
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
                  width: 250,
                ),
                Text(
                  getTimeString(realtimeplayer.duration.inMilliseconds),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    size: 30,
                  ),
                  color: favoriteIconeColor,
                  onPressed: () {
                    setState(() {
                      favoriteIconeColor = Colors.red;
                    });
                  },
                ),
                SizedBox(
                  width: 80,
                ),
                IconButton(
                  icon: Icon(
                    Icons.playlist_add,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      previousSong();
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
                  IconButton(
                    onPressed: () {
                      if (assetsAudioPlayer.isPlaying.value) {
                        pauseSong();
                        setState(() {
                          isPlay = false;
                        });
                      } else if (!assetsAudioPlayer.isPlaying.value) {
                        playSong();
                        setState(() {
                          isPlay = true;
                        });
                      }
                    },
                    icon: Icon(
                      isPlay ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      nextSong();
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

  Future<void> nextSong() async {
    await assetsAudioPlayer.next();
  }

  Future<void> previousSong() async {
    await assetsAudioPlayer.previous();
  }

  Future<void> playSong() async {
    await assetsAudioPlayer.play();
  }

  pauseSong() async {
    await assetsAudioPlayer.pause();
  }

  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds';
  }
}
