import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hyfix/FilterBox.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:hyfix/main.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:hyfix/services/Service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
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
  DateTime focusedDay = DateTime.now();

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

  void addFocused(DateTime data) {
    focusedDay = data;
    notifyListeners();
  }
}

class DataFetch with ChangeNotifier {
  dynamic first;
  dynamic last;
  String type = 'R';
  List<Cliente> customer = [];
  List<Luogo> location = [];
  List<Progetto> project = [];
  List<Attivita> projectTask = [];
  List<TipoAttivita> taskType = [];
  List<Utente> user = [];

  void initData() {
    DateTime focusedDay = DateTime.now();

    List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

    first = weeks.first.first;
    last = weeks.last.last;
    type = 'R';
    customer = [];
    location = [];
    project = [];
    projectTask = [];
    taskType = [];
    user = [];
  }

  dynamic getId(List list) {
    List<String> ids = List.empty(growable: true);
    if (list.isEmpty) {
      return List.empty();
    } else {
      for (var element in list) {
        ids.add("${element.id}");
      }
      return ids;
    }
  }

  void clear() {
    type = 'R';
    customer = [];
    location = [];
    project = [];
    projectTask = [];
    taskType = [];
    user = [];

    notifyListeners();
  }

  @override
  String toString() {
    return 'DataFetch: first: $first, last: $last, type: $type, customer: $customer, location: $location, project: $project, projectTask: $projectTask, taskType: $taskType, user: $user';
  }

  void addList(String tipo, List<dynamic> list) {
    switch (tipo) {
      case "C":
        customer = list.cast<Cliente>();
        break;
      case "L":
        location = list.cast<Luogo>();
        break;
      case "P":
        project = list.cast<Progetto>();
        break;
      case "A":
        projectTask = list.cast<Attivita>();
        break;
      case "T":
        taskType = list.cast<TipoAttivita>();
        break;
      case "U":
        user = list.cast<Utente>();
        break;
      default:
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
  bool visible = true;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int i = 0;

  DateTime _data = DateTime.now();
  bool loading = true;

  void fetchRep(
      {required dynamic first,
      required dynamic last,
      required String type,
      List? customer,
      List? location,
      List? project,
      List? projectTask,
      List? taskType,
      List? user}) {
    var jobList = context.read<JobList>();
    setState(() {
      loading = true;
    });
    Service()
        .getReports(
            globals.sesid,
            first,
            last,
            type,
            customer ?? '',
            location ?? '',
            project ?? '',
            projectTask ?? '',
            taskType ?? '',
            user ?? '')
        .then((report) {
      if (report == false) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Errore nel caricamento dei dati. Riprova più tardi...',
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() {
          loading = false;
        });
        jobList.lista = <Reports>[];
        for (var element in report) {
          Reports reports = Reports.fromJson(element);
          jobList.lista.add(reports);
        }
        jobList.lista = jobList.lista;
        if (jobList.listaEventi.isEmpty) {
          jobList.eventiGiorno(_data);
        }
      }
    });
  }

  late StreamSubscription<InternetStatus> listener;
  bool result = true;

  void checkConnection() async {
    result = await InternetConnection().hasInternetAccess;
  }

  @override
  void initState() {
    super.initState();

    DateTime focusedDay = DateTime.now();

    List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

    fetchRep(
        first: weeks.first.first,
        last: weeks.last.last,
        type: 'R'); // Pass the context object to fetchRep
    final dataFetch = context.read<DataFetch>();
    dataFetch.initData();

    checkConnection();

    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:

          // The internet is now connected
          if (result == false) {
            if (Navigator.canPop(context)) {
              _handleRefresh();
            }
          }

          setState(() {
            result = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            result = false;
          });
          break;
      }
    });
  }

  void logout() {
    Service().logout(globals.sesid).then(
      (response) async {
        final dataFetch = context.read<DataFetch>();
        final jobList = context.read<JobList>();

        jobList.lista = <Reports>[];
        jobList.updateLista();
        dataFetch.initData();

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

  Future<void> _handleRefresh() async {
    final dataFetch = context.read<DataFetch>();
    final jobList = context.read<JobList>();

    // Update the list of items and refresh the UI

    dataFetch.initData();

    List<List<DateTime>> weeks = getWeeksOfMonth(jobList.focusedDay);

    fetchRep(
        first: weeks.first.first,
        last: weeks.last.last,
        type: dataFetch.type,
        customer: dataFetch.getId(dataFetch.customer),
        location: dataFetch.getId(dataFetch.location),
        project: dataFetch.getId(dataFetch.project),
        projectTask: dataFetch.getId(dataFetch.projectTask),
        taskType: dataFetch.getId(dataFetch.taskType),
        user: dataFetch.getId(dataFetch.user));
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
        ChangeNotifierProvider(create: (context) => DataFetch()),
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
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TableBasic(
                        lista: jobList.lista,
                        onDaySelected: aggiornaData,
                        calendarFormat: _calendarFormat,
                        updateFormat: updateFormat,
                        fetchCalendar: fetchRep,
                        update: jobList.addFocused,
                        visible: visible,
                        context: context,
                      ),
                      Expanded(
                        child: ContainerEvents(
                          loading: loading,
                          selezionato: _data,
                          visible: visible,
                          lista: jobList.listaEventi,
                          fetchRep: fetchRep,
                          dayReload: jobList.updateLista,
                          data: jobList.focusedDay,
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
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(fetchRep, data, update) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1500),
    pageBuilder: (context, animation, secondaryAnimation) => InsertActivity(
        fetchCalendar: fetchRep, update: update, dataAttuale: data),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.fastEaseInToSlowEaseOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
