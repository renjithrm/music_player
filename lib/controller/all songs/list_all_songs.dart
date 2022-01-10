// ignore_for_file: import_of_legacy_library_into_null_safe, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:on_audio_query/on_audio_query.dart';

// class AllSongsController extends GetxController {
//   var fetchSongsList = [].obs;

//   final OnAudioQuery onAudioQuery = OnAudioQuery();
//   premissionStatus() async {
//     if (!kIsWeb) {
//       bool permissionStatus = await onAudioQuery.permissionsStatus();
//       if (!permissionStatus) {
//         await onAudioQuery.permissionsRequest();
//       }
//     }
//   }

//   Future<void> fetchDatas() async {
//     List<SongModel> allFetchAllSongs = await onAudioQuery.querySongs(
//         orderType: OrderType.ASC_OR_SMALLER,
//         uriType: UriType.EXTERNAL,
//         ignoreCase: true);

//     fetchSongsList.value = allFetchAllSongs;
//     update();
//     //   print(fetchSongsList.value);
//   }
// }

class AllSongsController extends GetxController {
  final OnAudioQuery onAudioQuery = OnAudioQuery();

  final box = Boxes.getInstance();
  final hiveList = ValueNotifier<List<AllSongsModel>>([]);
  List<SongModel> fetchSongsList = [];
  // late AllSongsModel hiveList;
  // List<AllSongsModel> hiveList = [];
  premissionStatus() async {}

  Future fetchDatas() async {
    List<SongModel> allFetchAllSongs = await onAudioQuery.querySongs();
    // fetchSongsList = allFetchAllSongs;
    for (var item in allFetchAllSongs) {
      if (item.fileExtension == "mp3" || item.fileExtension == "opus") {
        fetchSongsList.add(item);
      }
    }

    hiveList.value = fetchSongsList
        .map((e) => AllSongsModel(
            title: e.title,
            artist: e.artist.toString(),
            uri: e.uri.toString(),
            id: e.id,
            duration: e.duration!.toInt()))
        .toList();

    await box.put("allSongs", hiveList.value);
  }

  // getData() async {
  //   hiveList.value = await box.get("allSongs");
  //   print(hiveList);
  // }
}
