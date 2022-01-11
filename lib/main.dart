import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/all%20songs/list_all_songs.dart';
import 'package:music_player/controller/notification.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:music_player/view/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationUser.init();
  await Hive.initFlutter();
  Hive.registerAdapter(AllSongsModelAdapter());
  await Hive.openBox("songs");
  final box = Boxes.getInstance();
  List _keys = box.keys.toList();
  final allSongsController = AllSongsController();
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  try {
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await onAudioQuery.permissionsRequest();
        await allSongsController.fetchDatas();
      }
    }
  } catch (e) {
    const CircularProgressIndicator();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //root widget of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
