// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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

class AllSongsController {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  final fetchSongsList = ValueNotifier<List<SongModel>>([]);
  premissionStatus() async {
    if (!kIsWeb) {
      bool permissionStatus = await onAudioQuery.permissionsStatus();
      if (!permissionStatus) {
        await onAudioQuery.permissionsRequest();
      }
    }
  }

  Future<void> fetchDatas() async {
    List<SongModel> allFetchAllSongs = await onAudioQuery.querySongs();

    fetchSongsList.value = allFetchAllSongs;
    print(fetchSongsList.value);
  }
}
