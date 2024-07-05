import 'package:flutter/material.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:hyfix/main.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:hyfix/services/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TableBasic.dart';
import 'ContainerEvents.dart';
import 'InsertActivity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'Login.dart' as globals;

class JobList with ChangeNotifier {
  List<Reports> lista = <Reports>[];
  List<Reports> listaEventi = <Reports>[];

  void addElement(Reports report) {
    lista.add(report);
    notifyListeners();
  }

  void updateLista() {
    listaEventi.clear();
    notifyListeners();
  }

  void eventiGiorno(DateTime data) {
    listaEventi.clear();
    for (var element in lista) {
      if (DateUtils.isSameDay(element.reportDate, data)) {
        listaEventi.add(element);
      }
    }
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

    DateTime focusedDay = DateTime.now();

    List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

    fetchRep(weeks.first.first, weeks.last.last);
  }

  void fetchRep(first, last) {
    var jobList = context.read<JobList>();
    setState(() {
      loading = true;
    });
    Service().getReports(globals.sesid, first, last).then((report) {
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
        if (jobList.listaEventi.isEmpty) {
          jobList.eventiGiorno(_data);
        }
      });
    });
  }

  void logout() {
    Service().logout(globals.sesid).then(
      (response) async {
        JobList jobList = context.read<JobList>();
        jobList.lista = <Reports>[];

        var prefs = await SharedPreferences.getInstance();
        prefs.remove('username');
        prefs.remove('sesid');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Accesso()),
        );
      },
    );
  }

  void aggiornaData(DateTime data) {
    var jobList = context.read<JobList>();
    if (_data == data) {
      visible = !visible;
    } else {
      visible = true;
    }
    setState(() {
      _data = data;
    });
    jobList.eventiGiorno(_data);
  }

  void updateFormat(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  void update() {
    var updList = context.read<JobList>();

    updList.updateLista();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var jobList = context.watch<JobList>();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => JobList()),
      ],
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: screenHeight / 100 * 6,
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
          title: Center(
            child: Text('LE TUE ATTIVITÀ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 100 * 7,
                )),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TableBasic(
                lista: jobList.lista,
                onDaySelected: aggiornaData,
                calendarFormat: _calendarFormat,
                updateFormat: updateFormat,
                fetchCalendar: fetchRep,
                visible: visible,
              ),
              Expanded(
                child: ContainerEvents(
                  loading: loading,
                  selezionato: _data,
                  visible: visible,
                  lista: jobList.listaEventi,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 10, 15),
                  child: FloatingActionButton(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    onPressed: () {
                      Navigator.of(context)
                          .push(_createRoute(fetchRep, _data, update));
                    },
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

Route _createRoute(fetchRep, data, update) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 750),
    pageBuilder: (context, animation, secondaryAnimation) => InsertActivity(
        fetchCalendar: fetchRep, update: update, dataAttuale: data),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.fastOutSlowIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
