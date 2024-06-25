import 'package:flutter/material.dart';
import 'package:progetto/main.dart';
import 'TableBasic.dart';
import 'ContainerEvents.dart';
import 'InsertActivity.dart';
import 'package:table_calendar/table_calendar.dart';


class Cliente{
  int id=0;
  int id_costumer=1;
  String code="";
  String costumer_code="";
  String companyname="";

  Cliente(){
    
  }

}

class Element {
  String cliente = "";
  String luogo = "";
  String progetto = "";
  String attivita = "";
  String ore = "";
  String tipo = "";
  String note = "";
  DateTime data = new DateTime(2022);

  Element(String cliente,String luogo,String progetto,String attivita, String ore, DateTime data,String note, String tipo) {
    this.cliente = cliente;
    this.luogo = luogo;
    this.progetto = progetto;
    this.attivita = attivita;
    this.ore = ore;
    this.data = data;
    this.tipo = tipo;
    this.note = note;
  }
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  List<Element> lista = <Element>[];
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

  void addElement(cliente,luogo,progetto,attivita, ore, data,note, tipo) {
    setState(() {
      widget.lista.add(Element(cliente,luogo,progetto,attivita, ore, data,note, tipo));
    });
  }

  void updateFormat(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          leading: Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: IconButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Accesso()),
                    ),
                icon: const Icon(Icons.arrow_back)),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 10, 0),
              child: Image(width: 45, image: AssetImage('lib/img/logo.png')),
            )
          ],
          centerTitle: true,
          title: Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: const Text('LE TUE ATTIVITÀ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 54, 158, 244),
                      fontWeight: FontWeight.bold,
                      fontSize: 30))),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TableBasic(
                onDaySelected: aggiornaData,
                calendarFormat: _calendarFormat,
                updateFormat: updateFormat,
                visible: visible,
                lista: widget.lista,
              ),
              Expanded(
                child: ContainerEvents(
                  selezionato: _data,
                  visible: visible,
                  lista: widget.lista,
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                    child: FloatingActionButton(
                      backgroundColor: Color.fromARGB(255, 122, 213, 255),
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog.fullscreen(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InsertActivity(
                                addElement: addElement,
                                dataAttuale: _data,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      child: const Icon(Icons.add_rounded),
                    ),
                  ))
            ],
          ),
        ));
  }
}
