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

  void fetchCalendar(Reports report) {
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
  bool loading = true;

  int i = 0;

  @override
  void initState() {
    super.initState();

    fetchRep();
    
  }

  void fetchRep(){
    var jobList = context.read<JobList>();
    Service().getReports(globals.sesid).then((report) {
      print("ciao");
      setState(() {
        loading = false;
      });
      jobList.lista = <Reports>[];
      for (var element in report) {
        Reports reports = Reports.fromJson(element);
        jobList.lista.add(reports);
      }
      setState(() {
        jobList.lista = jobList.lista;
      });
    });
  }

  void logout() async {
    var client = http.Client();

    var uri = Uri.https('hyfix.test.nealis.it', '/auth/logout');
    await client.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: globals.sesid,
    }).then(
      (response) {
        JobList jobList = context.read<JobList>();
        jobList.lista = <Reports>[];
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Accesso()),
        );
      },
    );
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
          leading: IconButton(
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
          actions: [
            PopScope(
              canPop: false,
              child: IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.errorContainer,
                ),
              ),
            ),
          ],
          // centerTitle: true,
          title: Center(
            child: Text('LE TUE ATTIVITÀ',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
          ),
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
                  loading: loading,
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
                                fetchCalendar: fetchRep,
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
