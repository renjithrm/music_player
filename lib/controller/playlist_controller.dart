import 'package:flutter/foundation.dart';
import 'package:music_player/model/list_model.dart';

class PlaylistController {
  ValueNotifier<List<DataBase>> playlistName = ValueNotifier([]);
  addPlaylist(DataBase obj) {
    playlistName.value.add(obj);
  }
}
