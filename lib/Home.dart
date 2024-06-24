import 'package:flutter/material.dart';
import 'package:progetto/main.dart';
import 'TableBasic.dart';
import 'ContainerEvents.dart';
import 'InsertActivity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class Element {
  String cliente = "";
  String luogo = "";
  String progetto = "";
  String attivita = "";
  String ore = "";
  String tipo = "";
  String note = "";
  DateTime data = DateTime(2022);

  Element(this.cliente, this.luogo, this.progetto, this.attivita, this.ore,
      this.data, this.note, this.tipo);
}

class JobList with ChangeNotifier {
  List<Element> lista = <Element>[];

  void addElement(cliente, luogo, progetto, attivita, ore, data, note, tipo) {
    lista.add(
        Element(cliente, luogo, progetto, attivita, ore, data, note, tipo));
    notifyListeners();
  }

  // void removeElement(Element element) {
  //   lista.remove(element);
  //   notifyListeners();
  // }
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

  // void addElement(cliente, luogo, progetto, attivita, ore, data, note, tipo) {
  //   setState(() {
  //     JobList().addElement(
  //         Element(cliente, luogo, progetto, attivita, ore, data, note, tipo));
  //   });
  // }

  void updateFormat(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();

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
        body: Consumer<JobList>(
          builder: (context, jobList, _) => Container(
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
      ),
    );
  }
}
