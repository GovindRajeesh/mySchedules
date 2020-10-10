import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mySchedules/scheduleModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mySchedules/showMsg.dart';
import 'package:mySchedules/editpage.dart';
import 'package:mySchedules/viewpage.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory storage = await getApplicationDocumentsDirectory();
  Hive.init(storage.path);
  Hive.registerAdapter(ScheduleModelAdapter());
  Hive.registerAdapter(taskAdapter());
  await Hive.openBox<ScheduleModel>("schedules");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mySchedules',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<ScheduleModel> schedules;
  TextEditingController name = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Widget deleteDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Text(
          "Do you want to delete ${schedules.getAt(index).name.replaceFirst(schedules.getAt(index).name[0], schedules.getAt(index).name[0].toUpperCase())}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
              "Are you sure you want to delete ${schedules.getAt(index).name.replaceFirst(schedules.getAt(index).name[0], schedules.getAt(index).name[0].toUpperCase())}"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
        FlatButton(
            onPressed: () {
              String name = schedules.getAt(index).name.replaceFirst(
                  schedules.getAt(index).name[0],
                  schedules.getAt(index).name[0].toUpperCase());
              schedules.deleteAt(index);

              Navigator.pop(context);
              showMsg("Successfully deleted ${name}");
            },
            child: Text("Yes")),
      ],
    );
  }

  Future<bool> quitDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("No")),
          FlatButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Yes")),
        ],
        title: Text("Quit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Do you want to quit this app"),
          ],
        ),
      ),
    );
  }

  Widget addDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Create a schedule"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Form(
              key: _formkey,
              child: Wrap(
                children: <Widget>[
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'You didnt enter the name';
                      }
                    },
                    decoration: InputDecoration(labelText: "Schedule name"),
                  ),
                ],
              )),
        ],
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  if (_formkey.currentState.validate()) {
                    ScheduleModel model = ScheduleModel(
                        name: name.text,
                        timeCreated: DateTime.now(),
                        items: <task>[]);
                    schedules.add(model);
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Schedule ${name.text} created");
                    List find = [];
                    schedules.values.forEach((element) {
                      find.add(element.name);
                    });
                    int ind =
                        find.indexWhere((element) => element == name.text);

                    showMsg("Opened ${name.text} in editing mode");
                    name.text = "";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            index: ind,
                          ),
                        ));
                  }
                },
                child: Text("Add")),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
          ],
        )
      ],
    );
  }

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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => addDialog(context),
              );
            },
          ),
          appBar: AppBar(
            title: Text("Schedules"),
          ),
          body: ValueListenableBuilder(
            valueListenable: schedules.listenable(),
            builder: (context, Box<ScheduleModel> schedules, _) {
              return schedules.length == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Tap the add button on the bottom to create schedules",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        height: 30,
                      ),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Wrap(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  schedules.getAt(index).name.replaceFirst(
                                      schedules.getAt(index).name[0],
                                      schedules
                                          .getAt(index)
                                          .name[0]
                                          .toUpperCase()),
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditPage(
                                                    index: index,
                                                  ),
                                                ));
                                          }),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewPage(index: index),
                                              ));
                                        },
                                        child: Text("View"),
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    deleteDialog(
                                                        context, index));
                                          }),
                                    ],
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Time created:${DateFormat.Hm().format(schedules.getAt(index).timeCreated)}",
                                  style: TextStyle(fontSize: 16.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
        ),
        onWillPop: quitDialog);
  }
}
