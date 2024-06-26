import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;
import 'Login.dart' as globals;

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
      {required this.lightColorScheme, required this.darkColorScheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => JobList())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HyFix',
            theme: ThemeData.from(colorScheme: lightColorScheme),
            darkTheme: ThemeData.from(colorScheme: darkColorScheme),
            themeMode: themeProvider.themeMode,
            home: Accesso(),
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
  String utente = "";
  String password = "";

  Future<String> fetchUtente() async {
    final queryParameters = {
      'username': utente,
      'password': password,
    };
    final uri =
        Uri.https('hyfix.test.nealis.it', '/auth/login', queryParameters);
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    var sesid = response.headers["set-cookie"];
    globals.sesid = sesid!;

    return response.body;
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    var themeProvider = context.read<ThemeProvider>();

    setState(() {
      final isDark = prefs.getBool('isDark') ?? false;
      themeProvider.toggleTheme(isDark);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Image(width: 100, image: AssetImage('lib/img/logo.png')),
          SvgPicture.asset(
            'assets/full_logo.svg',
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primaryContainer,
                BlendMode.srcIn),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 250,
            child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome Utente',
                ),
                onChanged: (String newText) {
                  setState(() {
                    utente = newText;
                  });
                }),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 250,
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              onChanged: (String newText) {
                setState(() {
                  password = newText;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <-- Radius
                  ),
                ),
                onPressed: () async {
                  await fetchUtente().then((resp) => {
                        print(resp),
                        if (utente.isEmpty || password.isEmpty)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Riempi tutti i campi'),
                                action: SnackBarAction(
                                  label: 'Chiudi',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            ),
                          }
                        else if (resp.contains('"success":false'))
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Username e/o Password Errati'),
                                action: SnackBarAction(
                                  label: 'Chiudi',
                                  onPressed: () {
                                    // Code to execute.
                                  },
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            ),
                          }
                        else
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            ),
                          }
                      });
                },
                child: Text(
                  'Accedi',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text(
                  'Prova Demo',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          Text(
            globals.sesid,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
