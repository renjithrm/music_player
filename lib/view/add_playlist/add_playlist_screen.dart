import 'package:flutter/material.dart';
import 'package:music_player/model/reuse_widgets.dart';

class ScreenAddPlaylist extends StatelessWidget {
  final titlePlaList;
  ScreenAddPlaylist({Key? key, required this.titlePlaList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titlePlaList),
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Add songs',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
