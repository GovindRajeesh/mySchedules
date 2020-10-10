// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduleModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class taskAdapter extends TypeAdapter<task> {
  @override
  final typeId = 1;
  @override
  task read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return task(
      title: fields[0] as String,
      time: fields[1] as DateTime,
      select: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, task obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.select);
  }
}

class ScheduleModelAdapter extends TypeAdapter<ScheduleModel> {
  @override
  final typeId = 0;
  @override
  ScheduleModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleModel(
      name: fields[0] as String,
      timeCreated: fields[1] as DateTime,
      items: (fields[2] as List)?.cast<task>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.timeCreated)
      ..writeByte(2)
      ..write(obj.items);
  }
}
