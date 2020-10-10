import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mySchedules/scheduleModel.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mySchedules/showMsg.dart';
import 'package:intl/intl.dart';
import 'package:mySchedules/viewpage.dart';

class EditPage extends StatefulWidget {
  int index;
  EditPage({this.index});
  @override
  _EditPageState createState() => _EditPageState(index: index);
}

class _EditPageState extends State<EditPage> {
  int index;
  TextEditingController title = TextEditingController();
  Box<ScheduleModel> schedules;
  _EditPageState({this.index});
  bool select = false;
  bool enabled = true;
  Map items;
  DateTime time;
  List<task> datas = [];
  List<Widget> body = [];
  final _formkey = GlobalKey<FormState>();
  Widget add(BuildContext context) {}
  void reset() {
    setState(() {
      datas.clear();
      schedules.getAt(index).items.forEach((element) {
        datas.add(task(
            title: element.title, time: element.time, select: element.select));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schedules = Hive.box("schedules");
    schedules.getAt(index).items.forEach((element) {
      datas.add(task(
          title: element.title, time: element.time, select: element.select));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          bottomSheet: Container(
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Add"),
                                content: Wrap(
                                  children: <Widget>[
                                    Form(
                                      key: _formkey,
                                      child: Wrap(
                                        children: <Widget>[
                                          TextFormField(
                                            validator: (e) {
                                              if (e.isEmpty) {
                                                return "You have'nt entered the title";
                                              }
                                              ;
                                            },
                                            controller: title,
                                            decoration: InputDecoration(
                                                labelText: "Title"),
                                          ),
                                          RaisedButton(
                                              color: Colors.amber,
                                              onPressed: () {
                                                DatePicker.showTimePicker(
                                                    context,
                                                    onConfirm: (value) {
                                                  setState(() {
                                                    time = value;
                                                  });
                                                });
                                              },
                                              child: Text("Choose your time")),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        if (_formkey.currentState.validate() &&
                                            time != null) {
                                          task model = task(
                                              title: title.text,
                                              time: time,
                                              select: false);
                                          schedules
                                              .getAt(index)
                                              .items
                                              .add(model);
                                          schedules.putAt(
                                              index,
                                              ScheduleModel(
                                                  name: schedules
                                                      .getAt(index)
                                                      .name,
                                                  items: schedules
                                                      .getAt(index)
                                                      .items,
                                                  timeCreated: schedules
                                                      .getAt(index)
                                                      .timeCreated));
                                          reset();
                                          setState(() {
                                            title.text = "";
                                            time = DateTime.now();
                                          });
                                          Navigator.pop(context);
                                        } else if (time == null) {
                                          showMsg(
                                              "You have'nt selected the time");
                                        }
                                        ;
                                      },
                                      child: Text("Add")),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                ],
                              ));
                    }),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      List<task> deltasks = [];
                      schedules.getAt(index).items.forEach((element) {
                        if (element.select) {
                          deltasks.add(element);
                        }
                      });
                      deltasks.length == 0
                          ? showMsg("You have'nt selected anything to delete")
                          : deltasks.forEach((element) {
                              schedules.getAt(index).items.remove(element);
                            });
                      schedules.putAt(
                          index,
                          ScheduleModel(
                              name: schedules.getAt(index).name,
                              items: schedules.getAt(index).items,
                              timeCreated: schedules.getAt(index).timeCreated));
                      reset();
                    })
              ],
            ),
          ),
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
                rows: datas
                    .map((e) => DataRow(
                            onSelectChanged: (v) {
                              setState(() {
                                int change =
                                    schedules.getAt(index).items.indexOf(e);
                                e.select = v;
                                schedules
                                    .getAt(index)
                                    .items
                                    .where((element) =>
                                        element.title == e.title &&
                                        e.time == element.time)
                                    .first
                                    .select = v;
                                schedules.putAt(
                                    index,
                                    ScheduleModel(
                                        name: schedules.getAt(index).name,
                                        items: schedules.getAt(index).items,
                                        timeCreated: schedules
                                            .getAt(index)
                                            .timeCreated));
                              });
                            },
                            selected: e.select,
                            cells: <DataCell>[
                              DataCell(Text(e.title)),
                              DataCell(Text(DateFormat.Hm().format(e.time)))
                            ]))
                    .toList(),
              ),
            ],
          ),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.table_view),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPage(
                                  index: index,
                                )));
                  })
            ],
            title: Text(
                "Edit ${schedules.getAt(index).name.replaceFirst(schedules.getAt(index).name[0], schedules.getAt(index).name[0].toUpperCase())}"),
          ),
        ),
        onWillPop: null);
  }
}
