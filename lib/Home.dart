import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyfix/main.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:hyfix/services/service.dart';
import 'TableBasic.dart';
import 'ContainerEvents.dart';
import 'InsertActivity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'Login.dart' as globals;

class Cliente {
  int id = 0;
  int id_costumer = 1;
  String code = "";
  String costumer_code = "";
  String companyname = "";

  Cliente() {}
}

class JobList with ChangeNotifier {
  List<Reports> lista = <Reports>[];

  void addElement(Reports report) {
    lista.add(report);
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _data = DateTime.now();
  bool visible = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int i = 0;

  @override
  void initState() {
    super.initState();

    var jobList = context.read<JobList>();

    Service().getReports(globals.sesid).then((report) {
      jobList.lista = <Reports>[];
      for (var element in report) {
        // print("element");
        // print(element);
        Reports reports = Reports.fromJson(element);
        // print("entrato");
        jobList.lista.add(reports);
        // for (var i in jobList.lista) {
        //   print(i.toJson());
        // }
        // print("reports");
        // print(reports.toJson());
        // JobList().addElement(reports);
      }
      setState(() {
        jobList.lista = jobList.lista;
      });
    });
  }

  void aggiornaData(DateTime data) {
    if (_data == data) {
      visible = !visible;
    } else {
      visible = true;
    }
    setState(() {
      _data = data;
    });
  }

  void updateFormat(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var jobList = context.watch<JobList>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JobList()),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          leading: Container(
            child: IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Accesso()),
                    ),
                icon: const Icon(Icons.arrow_back)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                themeProvider
                    .toggleTheme(themeProvider.themeMode == ThemeMode.light);
              },
              icon: Icon(
                themeProvider.themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
          centerTitle: true,
          title: Container(
              child: Text('LE TUE ATTIVITÀ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 30))),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TableBasic(
                lista: jobList.lista,
                onDaySelected: aggiornaData,
                calendarFormat: _calendarFormat,
                updateFormat: updateFormat,
                visible: visible,
              ),
              Expanded(
                child: ContainerEvents(
                  selezionato: _data,
                  visible: visible,
                  lista: jobList.lista,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                  child: FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog.fullscreen(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InsertActivity(
                                addElement: jobList.addElement,
                                dataAttuale: _data,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.add_rounded),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
