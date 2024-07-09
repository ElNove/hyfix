import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:hyfix/Home.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyfix/services/Service.dart';
import 'Login.dart' as globals;

class Cliente{
  dynamic customer_id;
  dynamic customer_code;
  dynamic customer_companyname;

  Cliente(customer_id,customer_code,customer_companyname){
    customer_id=customer_id;
    customer_code=customer_code;
    customer_companyname=customer_companyname;
  }
}
class Luogo{
  dynamic location_id;
  dynamic location_code;
  dynamic location_city;

  Luogo(location_id,location_code,location_city){
    location_id=location_id;
    location_code=location_code;
    location_city=location_city;
  }
}
class Progetto{
  dynamic project_id;
  dynamic project_code;
  dynamic customer_code;

  Progetto(project_id,project_code,customer_code){
    project_id=project_id;
    project_code=project_code;
    customer_code=customer_code;
  }
}
class Attivita{
  dynamic project_task_id;
  dynamic project_task_code;
  dynamic project_code;
  dynamic customer_code;

  Attivita(project_task_id,project_task_code,customer_companyname,customer_code){
    project_task_id=project_task_id;
    project_task_code=project_task_code;
    project_code=project_code;
    customer_code=customer_code;
  }
}
class TipoAttivita{
  dynamic task_type_id;
  dynamic task_type_code;
  dynamic unity_code;

  TipoAttivita(task_type_id,task_type_code,unity_code){
    task_type_id=task_type_id;
    task_type_code=task_type_code;
    unity_code=unity_code;
  }
}
class Utente{
  dynamic user_id;
  dynamic username;
  dynamic signature;
  dynamic avatar;

  Utente(user_id,username,signature,avatar){
    user_id=user_id;
    username=username;
    signature=signature;
    avatar=avatar;
  }
}

class Filterbox extends StatefulWidget {
  const Filterbox(
      {super.key,
      required this.fetchRep,
      required this.data,
      required this.aggiornaData});

  final Function fetchRep;
  final DateTime data;
  final Function aggiornaData;

  @override
  _FilterboxState createState() => _FilterboxState();
}

class _FilterboxState extends State<Filterbox> {
  Future<void> clear() async {
    widget.aggiornaData();
  }

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      applyButtonText: 'Applica',
      allButtonText: 'Tutti',
      themeData: FilterListThemeData(
        context,
        backgroundColor: Theme.of(context).colorScheme.surface,
        headerTheme: HeaderThemeData(
          backgroundColor: Theme.of(context).colorScheme.surface,
          closeIconColor: Theme.of(context).colorScheme.onSurface,
          searchFieldBackgroundColor: Theme.of(context).colorScheme.onSurface,
          searchFieldIconColor: Theme.of(context).colorScheme.surface,
          searchFieldHintText: 'Cerca...',
          searchFieldHintTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.outline, fontSize: 18),
          searchFieldTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.surface, fontSize: 18),
          headerTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        controlButtonBarTheme: ControlButtonBarThemeData(
          context,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          controlButtonTheme: ControlButtonThemeData(
            primaryButtonBackgroundColor:
                Theme.of(context).colorScheme.tertiaryContainer,
            primaryButtonTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontSize: 15,
            ),
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              fontSize: 15,
            ),
          ),
        ),
      ),
      context,
      listData: ['asd', 'asd', 'asd'],
      selectedListData: [],
      choiceChipLabel: (user) => user,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (user, query) {
        return true;
        // return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          // selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );

  List<Cliente> clienti=List.empty(growable: true);
  List<Luogo> luoghi=List.empty(growable: true);
  List<Progetto> progetti=List.empty(growable: true);
  List<Attivita> attivita=List.empty(growable: true);
  List<TipoAttivita> tipoAttivita=List.empty(growable: true);
  List<Utente> utenti=List.empty(growable: true);

  @override
  void initState() {
    Service().selectRead(sesid: globals.sesid, tipo: "C").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      
      print("clienti");
      // ignore: avoid_print
      for (var element in data) {
        clienti.add(Cliente(element["customer_id"],element["customer_code"],element["customer_companyname"]));
        print(element);
      }
    });
    Service().selectRead(sesid: globals.sesid, tipo: "L").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      print("luogo");
      // ignore: avoid_print
      for (var element in data) {
        luoghi.add(Luogo(element["locatio_id"],element["location_code"],element["location_city"]));
        print(element);
      }
    });
    Service().selectRead(sesid: globals.sesid, tipo: "P").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      print("progetto");
      // ignore: avoid_print
      for (var element in data) {
        progetti.add(Progetto(element["project_id"],element["project_code"],element["customer_code"]));
        print(element);
      }
    });
    Service().selectRead(sesid: globals.sesid, tipo: "A").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      print("attività");
      // ignore: avoid_print
      for (var element in data) {
        attivita.add(Attivita(element["project_task_id"],element["project_task_code"],element["project_code"],element["customer_code"]));
        print(element);
      }
    });
    Service().selectRead(sesid: globals.sesid, tipo: "TA").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      print("tipo attività");
      
      // ignore: avoid_print
      for (var element in data) {
        tipoAttivita.add(TipoAttivita(element["task_type_id"],element["task_type_code"],element["unity_code"]));
        print(element);
      }
    });
    Service().selectRead(sesid: globals.sesid, tipo: "U").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      print("utenti");
      
      // ignore: avoid_print
      for (var element in data) {
        utenti.add(Utente(element["user_id"],element["username"],element["signature"],element["avatar"]));
        print(element);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dataFetch = context.watch<DataFetch>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight / 100 * 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FILTRA PER:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height / 100 * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight / 100 * 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('TIPO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        DropdownMenu<String>(
                          inputDecorationTheme: InputDecorationTheme(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          textStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          width: screenWidth / 100 * 40,
                          trailingIcon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                          selectedTrailingIcon: const Icon(
                            Icons.arrow_drop_up,
                            color: Colors.white,
                          ),
                          initialSelection: dataFetch.type,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: '', label: ''),
                            DropdownMenuEntry(value: 'R', label: 'Rapportino'),
                            DropdownMenuEntry(value: 'E', label: 'Evento'),
                          ],
                          onSelected: (value) async {
                            List<List<DateTime>> weeks =
                                getWeeksOfMonth(widget.data);

                            dataFetch.type = value ?? '';

                            clear().then((val) {
                              widget.fetchRep(
                                  first: weeks.first.first,
                                  last: weeks.last.last,
                                  type: value ?? '');
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('CLIENTE',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 100 * 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('LUOGO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('PROGETTO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 100 * 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('ATTIVITÀ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 37,
                            alignment: Alignment.centerLeft,
                            child: const Text('TIPO ATTIVITÀ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 100 * 2.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: screenWidth / 100 * 75,
                            alignment: Alignment.centerLeft,
                            child: const Text('UTENTE',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 80,
                          child: TextField(
                            readOnly: true,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () => openFilterDialog(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight / 100 * 2.5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
