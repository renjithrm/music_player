import 'package:hive_flutter/hive_flutter.dart';

class Boxes {
  static Box getInstance() => Hive.box("songs");
}
