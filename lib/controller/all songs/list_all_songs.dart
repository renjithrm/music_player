// ignore_for_file: import_of_legacy_library_into_null_safe, invalid_use_of_protected_member

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';

import 'package:music_player/data%20base/data%20base%20model/all_songs_model.dart';
import 'package:music_player/data%20base/hive%20instance/hive_instance.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllSongsController extends GetxController {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final box = Boxes.getInstance();
  var hiveList = <AllSongsModel>[];
  var index = 2.obs;
  var searchItem = "";
  // var searchList = [].obs;
  List<SongModel> fetchSongsList = [];
  @override
  void onInit() {
    fetchDatas();
    super.onInit();
  }

  Future fetchDatas() async {
    List<SongModel> allFetchAllSongs = await onAudioQuery.querySongs();
    // fetchSongsList = allFetchAllSongs;
    for (var item in allFetchAllSongs) {
      if (item.fileExtension == "mp3" || item.fileExtension == "opus") {
        fetchSongsList.add(item);
      }
    }

    hiveList = fetchSongsList
        .map((e) => AllSongsModel(
            title: e.title,
            artist: e.artist.toString(),
            uri: e.uri.toString(),
            id: e.id,
            duration: e.duration!.toInt()))
        .toList();

    await box.put("allSongs", hiveList);
    update(["home"]);
  }

  seekSongTime(value) async {
    await assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
  }
}

// class SongBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put<AllSongsController>(AllSongsController());
//   }
// }
