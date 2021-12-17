// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:music_player/model/reuse_widgets.dart';
import 'package:music_player/view/playing_now/screen_playing_now.dart';

class ScreenFavorites extends StatelessWidget {
  ScreenFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red, ReuseWidgets.scaffoldBackground])),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red, ReuseWidgets.scaffoldBackground])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemBuilder: (context, intex) => showBanner(context),
            itemCount: 1,
            separatorBuilder: (ctx, intex) => SizedBox(
              height: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget divider = Divider(
    color: Colors.black,
  );

  Widget showBanner(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: "myImage",
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage("assets/heroimage.jpg"), fit: BoxFit.cover),
          ),
        ),
      ),
      title: Text(
        "Alan Walker Faded Music",
        style: TextStyle(color: ReuseWidgets.colorInBody),
      ),
      trailing: PopupMenuButton(
        color: Colors.grey[800],
        elevation: 8,
        padding: EdgeInsets.all(10),
        itemBuilder: (ctx) => [
          PopupMenuItem(
              child: Column(
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Add to Playlist',
                    style: TextStyle(color: ReuseWidgets.colorInBody),
                  )),
              divider,
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Delete Song',
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
      ),
      // onTap: () => Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (ctx) => ScreenPlayingNow())),
    );
  }
}
