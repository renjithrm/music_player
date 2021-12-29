// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenScearch extends StatefulWidget {
  ScreenScearch({Key? key}) : super(key: key);

  @override
  State<ScreenScearch> createState() => _ScreenScearchState();
}

class _ScreenScearchState extends State<ScreenScearch> {
  final _myBox = Boxes.getInstance();

  String searchItem = "";

  var search = ValueNotifier(<AllSongsModel>[]);

  Widget divider = Divider(
    color: Colors.black,
  );

  List<Audio> songList = [];

  @override
  Widget build(BuildContext context) {
    search.value = searchItem.isNotEmpty
        ? _myBox.values
            .where((element) =>
                element.title.toLowerCase().contains(searchItem.toLowerCase()))
            .toList()
        : _myBox.values.toList();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.grey,
              ReuseWidgets.scaffoldBackground,
            ])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              const Text(
                "Search",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchItem = value;
                    });
                  },
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                    hintText: 'Search songs...',
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: search,
                    builder: (BuildContext context, List<AllSongsModel> result,
                        Widget? _) {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            return showBanner(context, search.value, index);
                          },
                          separatorBuilder: (ctx, intex) =>
                              SizedBox(height: 10),
                          itemCount: search.value.length);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showBanner(
      BuildContext context, List<AllSongsModel> result, int intex) {
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
                id: result[intex].id,
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
          result[intex].title,
          maxLines: 1,
          style: TextStyle(color: ReuseWidgets.colorInBody),
        ),
        subtitle: Text(
          result[intex].artist.toString(),
          style: TextStyle(color: ReuseWidgets.colorInBody),
        ),
        trailing: IconButton(
            onPressed: () => dilogBox(),
            icon: Icon(
              Icons.more_vert_outlined,
              color: ReuseWidgets.colorInBody,
            )),
        onTap: () {
          for (var item in result) {
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
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ));
  }
}
