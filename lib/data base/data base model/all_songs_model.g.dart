// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_songs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AllSongsModelAdapter extends TypeAdapter<AllSongsModel> {
  @override
  final int typeId = 0;

  @override
  AllSongsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AllSongsModel(
      title: fields[0] as String,
      artist: fields[1] as String,
      uri: fields[2] as String,
      id: fields[3] as int,
      duration: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AllSongsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.uri)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllSongsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
