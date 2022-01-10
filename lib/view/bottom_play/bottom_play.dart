// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomPlay extends StatelessWidget {
  BottomPlay({Key? key}) : super(key: key);
  String bottomImg = "assets/heroimage.jpg";
  final _assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  @override
  Widget build(BuildContext context) {
    return _assetsAudioPlayer.builderCurrent(builder: (context, curPlay) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white54, borderRadius: BorderRadius.circular(20)),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenPlayingNow()));
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 50,
                          height: 50,
                          child: QueryArtworkWidget(
                            artworkFit: BoxFit.cover,
                            id: int.parse(
                                curPlay.audio.audio.metas.id.toString()),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              child: Image(
                                image: AssetImage("assets/heroimage.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      curPlay.audio.audio.metas.title.toString(),
                      maxLines: 1,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  _assetsAudioPlayer.builderIsPlaying(
                      builder: (context, isPlay) {
                    return isPlay
                        ? IconButton(
                            onPressed: () async {
                              await _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.pause,
                              size: 35,
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              await _assetsAudioPlayer.playOrPause();
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              size: 35,
                            ),
                          );
                  }),
                  IconButton(
                    onPressed: () async {
                      await _assetsAudioPlayer.next();
                    },
                    icon: Icon(
                      Icons.skip_next,
                      size: 35,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
