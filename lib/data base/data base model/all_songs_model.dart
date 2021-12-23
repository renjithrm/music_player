import 'package:hive_flutter/adapters.dart';
part 'all_songs_model.g.dart';

@HiveType(typeId: 0)
class AllSongsModel extends HiveObject {
  AllSongsModel(
      {required this.title,
      required this.artist,
      required this.uri,
      required this.id,
      required this.duration});

  @HiveField(0)
  String title;
  @HiveField(1)
  String artist;
  @HiveField(2)
  String uri;
  @HiveField(3)
  int id;
  @HiveField(4)
  int duration;
}
