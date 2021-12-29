import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';

class Boxes {
  static Box<AllSongsModel> getInstance() => Hive.box("songs");
}
