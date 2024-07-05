import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hyfix/services/Service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Login.dart' as globals;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final String themeJson = await rootBundle.loadString('assets/theme.json');
  final Map<String, dynamic> themeMap = jsonDecode(themeJson);

  // Light and dark color schemes
  final ColorScheme lightColorScheme =
      createColorScheme(themeMap['schemes']['light-medium-contrast']);
  final ColorScheme darkColorScheme =
      createColorScheme(themeMap['schemes']['dark-medium-contrast']);

  initializeDateFormatting().then((_) => runApp(MainApp(
      lightColorScheme: lightColorScheme, darkColorScheme: darkColorScheme)));
}

ColorScheme createColorScheme(Map<String, dynamic> schemeData) {
  return ColorScheme(
    brightness: schemeData.containsKey('inverseSurface')
        ? Brightness.dark
        : Brightness.light,
    primary: Color(int.parse(schemeData['primary'].replaceFirst('#', '0xff'))),
    onPrimary:
        Color(int.parse(schemeData['onPrimary'].replaceFirst('#', '0xff'))),
    primaryContainer: Color(
        int.parse(schemeData['primaryContainer'].replaceFirst('#', '0xff'))),
    onPrimaryContainer: Color(
        int.parse(schemeData['onPrimaryContainer'].replaceFirst('#', '0xff'))),
    secondary:
        Color(int.parse(schemeData['secondary'].replaceFirst('#', '0xff'))),
    onSecondary:
        Color(int.parse(schemeData['onSecondary'].replaceFirst('#', '0xff'))),
    secondaryContainer: Color(
        int.parse(schemeData['secondaryContainer'].replaceFirst('#', '0xff'))),
    onSecondaryContainer: Color(int.parse(
        schemeData['onSecondaryContainer'].replaceFirst('#', '0xff'))),
    tertiary:
        Color(int.parse(schemeData['tertiary'].replaceFirst('#', '0xff'))),
    onTertiary:
        Color(int.parse(schemeData['onTertiary'].replaceFirst('#', '0xff'))),
    tertiaryContainer: Color(
        int.parse(schemeData['tertiaryContainer'].replaceFirst('#', '0xff'))),
    onTertiaryContainer: Color(
        int.parse(schemeData['onTertiaryContainer'].replaceFirst('#', '0xff'))),
    error: Color(int.parse(schemeData['error'].replaceFirst('#', '0xff'))),
    onError: Color(int.parse(schemeData['onError'].replaceFirst('#', '0xff'))),
    errorContainer: Color(
        int.parse(schemeData['errorContainer'].replaceFirst('#', '0xff'))),
    onErrorContainer: Color(
        int.parse(schemeData['onErrorContainer'].replaceFirst('#', '0xff'))),
    background:
        Color(int.parse(schemeData['background'].replaceFirst('#', '0xff'))),
    onBackground:
        Color(int.parse(schemeData['onBackground'].replaceFirst('#', '0xff'))),
    surface: Color(int.parse(schemeData['surface'].replaceFirst('#', '0xff'))),
    onSurface:
        Color(int.parse(schemeData['onSurface'].replaceFirst('#', '0xff'))),
    surfaceVariant: Color(
        int.parse(schemeData['surfaceVariant'].replaceFirst('#', '0xff'))),
    onSurfaceVariant: Color(
        int.parse(schemeData['onSurfaceVariant'].replaceFirst('#', '0xff'))),
    outline: Color(int.parse(schemeData['outline'].replaceFirst('#', '0xff'))),
    shadow: Color(int.parse(schemeData['shadow'].replaceFirst('#', '0xff'))),
    inverseSurface: Color(
        int.parse(schemeData['inverseSurface'].replaceFirst('#', '0xff'))),
    onInverseSurface: Color(
        int.parse(schemeData['inverseOnSurface'].replaceFirst('#', '0xff'))),
    inversePrimary: Color(
        int.parse(schemeData['inversePrimary'].replaceFirst('#', '0xff'))),
    surfaceTint:
        Color(int.parse(schemeData['surfaceTint'].replaceFirst('#', '0xff'))),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    final prefs = SharedPreferences.getInstance();
    prefs.then((value) => value.setBool('isDark', isOn));
    notifyListeners();
  }
}

class MainApp extends StatelessWidget {
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;

  const MainApp(
      {super.key,
      required this.lightColorScheme,
      required this.darkColorScheme});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => JobList())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            restorationScopeId: 'app',
            debugShowCheckedModeBanner: false,
            title: 'HyFix',
            theme: ThemeData.from(colorScheme: lightColorScheme),
            darkTheme: ThemeData.from(colorScheme: darkColorScheme),
            themeMode: themeProvider.themeMode,
            home: const Accesso(),
          );
        },
      ),
    );
  }
}

class Accesso extends StatefulWidget {
  const Accesso({super.key});

  @override
  State<Accesso> createState() => _AccessoState();
}

class _AccessoState extends State<Accesso> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static DateTime parse(String date) {
    const int SP = 32;
    const List wkdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    const List weekdays = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    const List months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    const int formatRfc1123 = 0;
    const int formatRfc850 = 1;
    const int formatAsctime = 2;

    int index = 0;
    String tmp;

    void expect(String s) {
      if (date.length - index < s.length) {
        throw HttpException("Invalid HTTP date $date");
      }
      String tmp = date.substring(index, index + s.length);
      if (tmp != s) {
        throw HttpException("Invalid HTTP date $date");
      }
      index += s.length;
    }

    int expectWeekday() {
      int weekday;
      // The formatting of the weekday signals the format of the date string.
      int pos = date.indexOf(",", index);
      if (pos == -1) {
        int pos = date.indexOf(" ", index);
        if (pos == -1) throw HttpException("Invalid HTTP date $date");
        tmp = date.substring(index, pos);
        index = pos + 1;
        weekday = wkdays.indexOf(tmp);
        if (weekday != -1) {
          return formatAsctime;
        }
      } else {
        tmp = date.substring(index, pos);
        index = pos + 1;
        weekday = wkdays.indexOf(tmp);
        if (weekday != -1) {
          return formatRfc1123;
        }
        weekday = weekdays.indexOf(tmp);
        if (weekday != -1) {
          return formatRfc850;
        }
      }
      throw HttpException("Invalid HTTP date $date");
    }

    int expectMonth(String separator) {
      int pos = date.indexOf(separator, index);
      if (pos - index != 3) throw HttpException("Invalid HTTP date $date");
      tmp = date.substring(index, pos);
      index = pos + 1;
      int month = months.indexOf(tmp);
      if (month != -1) return month;
      throw HttpException("Invalid HTTP date $date");
    }

    int expectNum(String separator) {
      int pos;
      if (separator.isNotEmpty) {
        pos = date.indexOf(separator, index);
      } else {
        pos = date.length;
      }
      String tmp = date.substring(index, pos);
      index = pos + separator.length;
      try {
        int value = int.parse(tmp);
        return value;
      } on FormatException {
        throw HttpException("Invalid HTTP date $date");
      }
    }

    void expectEnd() {
      if (index != date.length) {
        throw HttpException("Invalid HTTP date $date");
      }
    }

    int format = expectWeekday();
    int year;
    int month;
    int day;
    int hours;
    int minutes;
    int seconds;
    if (format == formatAsctime) {
      month = expectMonth(" ");
      if (date.codeUnitAt(index) == SP) index++;
      day = expectNum(" ");
      hours = expectNum(":");
      minutes = expectNum(":");
      seconds = expectNum(" ");
      year = expectNum("");
    } else {
      expect(" ");
      day = expectNum(format == formatRfc1123 ? " " : "-");
      month = expectMonth(format == formatRfc1123 ? " " : "-");
      year = expectNum(" ");
      hours = expectNum(":");
      minutes = expectNum(":");
      seconds = expectNum(" ");
      expect("GMT");
    }
    expectEnd();
    return DateTime.utc(year, month + 1, day, hours, minutes, seconds, 0);
  }

  late final LocalAuthentication auth;
  bool isLogged = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      if (isLogged && isSupported) {
        _authenticate();
      }
    });
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var themeProvider = context.read<ThemeProvider>();

    setState(() {
      final isDark = prefs.getBool('isDark') ?? false;
      themeProvider.toggleTheme(isDark);
    });

    if (prefs.getString('sesid') != null) {
      var sesid = prefs.getString('sesid');
      sesid?.split('; ').forEach((element) {
        if (element.contains('expires')) {
          var data = parse(element.split('=')[1].replaceAll(RegExp(r'-'), ' '));
          if (data.isBefore(DateTime.now())) {
            prefs.remove('sesid');
            prefs.remove('username');
            return;
          }
        }
      });
      userController.text = prefs.getString('username')!;
      setState(() {
        globals.sesid = sesid!;
        isLogged = true;
      });
    }
  }

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visible = false;
  FocusNode passwordFocus = FocusNode();

  void setVisible() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        heightFactor: 1.5,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Image(
              //     width: 350, image: AssetImage('assets/full_logo.png')),
              SvgPicture.asset(
                'assets/full_logo.svg',
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primaryContainer,
                    BlendMode.srcIn),
                width: 280,
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: userController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => {userController.clear()},
                                icon: const Icon(Icons.clear)),
                            border: const OutlineInputBorder(),
                            labelText: "Nome Utente"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il tuo nome utente';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !visible,
                        focusNode: passwordFocus,
                        decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // added line
                              mainAxisSize: MainAxisSize.min, // added line
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(visible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setVisible();
                                    }),
                                IconButton(
                                    onPressed: () =>
                                        {passwordController.clear()},
                                    icon: const Icon(Icons.clear)),
                              ],
                            ),
                            border: const OutlineInputBorder(),
                            labelText: "Password"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci la tua password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    PopScope(
                      canPop: false,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Service()
                                .fetchUtente(userController.text,
                                    passwordController.text)
                                .then((res) async {
                              var sesid = res.headers["set-cookie"];
                              globals.sesid = sesid!;

                              var prefs = await SharedPreferences.getInstance();
                              prefs.setString('sesid', sesid);
                              prefs.setString('username', userController.text);
                              if (res.body.contains('"success":false')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Username e/o Password Errati',
                                      textAlign: TextAlign.center,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                setState(() {
                                  globals.username = userController.text;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()),
                                );
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Riempi tutti i campi',
                                  textAlign: TextAlign.center,
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Accedi',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Autenticazione richiesta',
            biometricHint: 'Verifica identità',
            biometricNotRecognized: 'Impronta non riconosciuta',
            biometricSuccess: 'Autenticazione riuscita',
            biometricRequiredTitle: 'Tocca il sensore',
            cancelButton: 'Chiudi',
          ),
          IOSAuthMessages(
            cancelButton: 'Chiudi',
          ),
        ],
        localizedReason: 'Autenticazione richiesta per accedere a HyFix',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (authenticated) {
        setState(() {
          globals.username = userController.text;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
