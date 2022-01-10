// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:music_player/controller/notification.dart';

class ScreenSettings extends StatelessWidget {
  ScreenSettings({Key? key}) : super(key: key);
  ValueNotifier<bool> valueSwich = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    var defValue = NotificationUser.getNotifiStatus();
    if (defValue == null) {
      valueSwich.value = true;
    } else {
      valueSwich.value = defValue;
    }
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
                trailing: ValueListenableBuilder(
                    valueListenable: valueSwich,
                    builder: (BuildContext context, bool newSwichValue, _) {
                      return Switch(
                        value: valueSwich.value,
                        onChanged: (value) {
                          valueSwich.value = value;
                          NotificationUser.saveNotification(valueSwich.value);
                        },
                        activeTrackColor: Colors.purple,
                        thumbColor: MaterialStateProperty.all(Colors.white),
                        inactiveThumbColor: Colors.black,
                      );
                    }),
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
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: "music",
                    applicationVersion: "1.0.0",
                    applicationIcon: Container(
                      width: 50,
                      height: 50,
                      child: Image(
                        image: AssetImage("assets/logo_image.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Spacer(
                flex: 2,
              ),
              Container(
                child: Text(
                  "1.0.0",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
