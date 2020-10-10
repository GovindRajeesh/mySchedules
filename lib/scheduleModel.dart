import 'package:hive/hive.dart';

part 'ScheduleModel.g.dart';

@HiveType(typeId: 1)
class task {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  bool select;
  task({this.title, this.time, this.select});
}

@HiveType(typeId: 0)
class ScheduleModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime timeCreated;
  @HiveField(2)
  List<task> items;
  ScheduleModel({this.name, this.timeCreated, this.items});
}
