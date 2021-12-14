// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ScreenSettings extends StatelessWidget {
  ScreenSettings({Key? key}) : super(key: key);
  bool valueSwich = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          color: Colors.grey,
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Push Notification",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Switch(
                  value: valueSwich,
                  onChanged: (value) {},
                  activeTrackColor: Colors.purple,
                  thumbColor: MaterialStateProperty.all(Colors.white),
                  inactiveThumbColor: Colors.black,
                ),
              ),
              ListTile(
                title: Text(
                  "About",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
