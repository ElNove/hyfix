import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Home.dart';
import 'package:intl/date_symbol_data_local.dart';


void main(){
  initializeDateFormatting().then((_) =>runApp(MaterialApp(home: Accesso())));
} 

//CLASSE ACCESSO

class Accesso extends StatelessWidget {
  var utente = "";
  var password = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(width: 100, image: AssetImage('lib/img/logo.png')),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome Utente',
                  ),
                  onChanged: (String newText) {
                    utente = newText;
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
                    password = newText;
                  }),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 122, 213, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    utente != "" && password != ""
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          )
                        : showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Riempi i campi'),
                              content:utente==""?(
                                password==""?
                                  const Text('Inserisci nome utente e password'):const Text('Inserisci nome utente')
                                ):( 
                                    password==""?
                                    const Text('Inserisci la password'):null
                                  ) ,
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                  },
                  child: const Text(
                    'Accedi',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 122, 213, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // <-- Radius
                    ),
                  ),
                  onPressed: () => /*exit(0)*/ null,
                  child: const Text(
                    'Chiudi',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
