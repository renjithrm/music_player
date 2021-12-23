// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/material.dart';

class ScreenPlayingNow extends StatefulWidget {
  List<Audio> playlist;
  int intex;
  ScreenPlayingNow({Key? key, required this.playlist, required this.intex})
      : super(key: key);
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

  var musicList = [];

  double deviceHeight = 0;
  double deviceWidth = 0;

  Future<void> initPlaySong() async {
    await assetsAudioPlayer.open(
      // Audio(widget.currentSongs),
      Playlist(audios: widget.playlist, startIndex: widget.intex),
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

//morve forward or backward songs.
  seekSongTime(value) async {
    await assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
  }

//slider in the play screen.
  sliderBar(RealtimePlayingInfos realtimeplayer) {
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

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
            width: deviceWidth,
            height: deviceHeight,
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
//main part of the page.
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
            height: deviceHeight * 0.04,
          ),
          Container(
            width: deviceWidth * 0.7,
            height: deviceHeight * 0.3,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/heroimage.jpg")
                  //  realtimeplayer.current!.audio.audio.metas.image!.path
                  ,
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: deviceWidth * 0.8,
            height: deviceHeight * 0.06,
            child: Center(
              child: Text(
                // widget.playlist[widget.intex].metas.title.toString(),
                realtimeplayer.current!.audio.audio.metas.title.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.03,
          ),
          Container(
            width: deviceWidth * 0.8,
            height: deviceHeight * 0.06,
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
            height: deviceHeight * 0.04,
          ),
          Container(
            width: deviceWidth * 0.9,
            height: deviceHeight * 0.03,
            child: sliderBar(realtimeplayer),
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
                Text(
                  getTimeString(realtimeplayer.duration.inMilliseconds),
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.05,
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
                  StreamBuilder<Object>(
                      stream: assetsAudioPlayer.isPlaying,
                      builder: (context, snapshot) {
                        return IconButton(
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
                        );
                      }),
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
}
