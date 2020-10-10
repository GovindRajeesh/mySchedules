import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mySchedules/editpage.dart';
import 'package:mySchedules/scheduleModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mySchedules/showMsg.dart';
import 'package:intl/intl.dart';

class ViewPage extends StatefulWidget {
  int index;
  ViewPage({this.index});
  @override
  _ViewPageState createState() => _ViewPageState(index: index);
}

class _ViewPageState extends State<ViewPage> {
  int index;
  Box<ScheduleModel> schedules;
  _ViewPageState({this.index});
  bool select = false;
  bool enabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schedules = Hive.box("schedules");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: ListView(
            children: <Widget>[
              DataTable(
                showCheckboxColumn: true,
                columns: <DataColumn>[
                  DataColumn(
                      label: SizedBox(
                    child: Text("Title"),
                    width: 150,
                  )),
                  DataColumn(label: Text("Time")),
                ],
                rows: schedules
                    .getAt(index)
                    .items
                    .map((e) => DataRow(cells: <DataCell>[
                          DataCell(Text(e.title)),
                          DataCell(Text(DateFormat.Hms().format(e.time))),
                        ]))
                    .toList(),
              )
            ],
          ),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  tooltip:
                      "Open ${schedules.getAt(index).name.replaceFirst(schedules.getAt(index).name[0], schedules.getAt(index).name[0].toUpperCase())} in edit mode",
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            index: index,
                          ),
                        ));
                  })
            ],
            title: Text(
                "${schedules.getAt(index).name.replaceFirst(schedules.getAt(index).name[0], schedules.getAt(index).name[0].toUpperCase())}"),
          ),
        ),
        onWillPop: null);
  }
}
