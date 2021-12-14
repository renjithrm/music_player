// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ScreenPlayingNow extends StatefulWidget {
  ScreenPlayingNow({Key? key}) : super(key: key);

  @override
  State<ScreenPlayingNow> createState() => _ScreenPlayingNowState();
}

class _ScreenPlayingNowState extends State<ScreenPlayingNow> {
  @override
  Widget build(BuildContext context) {
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
          child: Padding(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Card(
                        elevation: 8,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage('assets/heroimage.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 300,
                  height: 30,
                  // color: ReuseWidgets.scaffoldBackground,
                  child: Center(
                    child: Text(
                      "Title of song",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 30,
                  // color: ReuseWidgets.scaffoldBackground,
                  child: Center(
                    child: Text(
                      "Subtitle of song",
                      style: TextStyle(
                          color: Colors.grey[350],
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SliderTheme(
                  data:
                      SliderThemeData(thumbShape: SliderComponentShape.noThumb),
                  child: Slider(
                    value: 2,
                    onChanged: (value) {},
                    max: 5,
                    thumbColor: Colors.white,
                    activeColor: Colors.purple,
                    inactiveColor: Colors.white,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "1:00",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 270,
                      ),
                      Text(
                        "3:00",
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
                        icon: Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.playlist_add,
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
                          onPressed: () {},
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.pause_circle_outline_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
