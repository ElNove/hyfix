import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:hyfix/Home.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:hyfix/services/Service.dart';
import 'Login.dart' as globals;

class Cliente {
  dynamic customer_id;
  dynamic customer_code;
  dynamic customer_companyname;
  String label = "";

  Cliente(this.customer_id, this.customer_code, this.customer_companyname) {
    customer_id = customer_id;
    customer_code = customer_code;
    customer_companyname = customer_companyname;
    label = "$customer_code - $customer_companyname";
  }
  @override
  String toString() {
    return "{$customer_id - $customer_code - $customer_companyname}";
  }
}

class Luogo {
  dynamic location_id;
  dynamic location_code;
  dynamic location_city;
  String label = "";

  Luogo(this.location_id, this.location_code, this.location_city) {
    location_id = location_id;
    location_code = location_code;
    location_city = location_city;
    label = "$location_code - $location_city";
  }
  @override
  String toString() {
    return "{$location_id - $location_code - $location_city}";
  }
}

class Progetto {
  dynamic project_id;
  dynamic project_code;
  dynamic customer_code;
  String label = "";

  Progetto(this.project_id, this.project_code, this.customer_code) {
    project_id = project_id;
    project_code = project_code;
    customer_code = customer_code;
    label = "$project_code - $customer_code";
  }
  @override
  String toString() {
    return "{$project_id - $project_code - $customer_code}";
  }
}

class Attivita {
  dynamic project_task_id;
  dynamic project_task_code;
  dynamic project_code;
  dynamic customer_code;
  String label = "";

  Attivita(this.project_task_id, this.project_task_code, this.project_code,
      this.customer_code) {
    project_task_id = project_task_id;
    project_task_code = project_task_code;
    project_code = project_code;
    customer_code = customer_code;
    label = "$project_task_code - $project_code - $customer_code";
  }
  @override
  String toString() {
    return "{$project_task_id - $project_task_code - $project_code -  $customer_code}";
  }
}

class TipoAttivita {
  dynamic task_type_id;
  dynamic task_type_code;
  dynamic unity_code;
  String label = "";

  TipoAttivita(this.task_type_id, this.task_type_code, this.unity_code) {
    task_type_id = task_type_id;
    task_type_code = task_type_code;
    unity_code = unity_code;
    label = "$task_type_code - $unity_code";
  }
  @override
  String toString() {
    return "{$task_type_id - $task_type_code - $unity_code}";
  }
}

class Utente {
  dynamic user_id;
  dynamic username;
  dynamic signature;
  dynamic avatar;
  String label = "";

  Utente(this.user_id, this.username, this.signature, this.avatar) {
    user_id = user_id;
    username = username;
    signature = signature;
    avatar = avatar;
    label = "$username";
  }
  @override
  String toString() {
    return "{$user_id - $username - $signature - $avatar}";
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

  List<Cliente> clienti = List.empty(growable: true);
  List<Luogo> luoghi = List.empty(growable: true);
  List<Progetto> progetti = List.empty(growable: true);
  List<Attivita> attivita = List.empty(growable: true);
  List<TipoAttivita> tipoAttivita = List.empty(growable: true);
  List<Utente> utenti = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    var dataFetch = context.watch<DataFetch>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void openFilterDialog<T extends Object>(List<T> list) async {
      late List selectedList = List.empty(growable: true);

      if (list is List<Cliente>) {
        selectedList = dataFetch.customer;
      } else if (list is List<Luogo>) {
        selectedList = dataFetch.location;
      } else if (list is List<Progetto>) {
        selectedList = dataFetch.project;
      } else if (list is List<Attivita>) {
        selectedList = dataFetch.projectTask;
      } else if (list is List<TipoAttivita>) {
        selectedList = dataFetch.taskType;
      } else if (list is List<Utente>) {
        selectedList = dataFetch.user;
      }

      // print(selectedList.toString());

      await FilterListDialog.display<T>(
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
        listData: list,
        selectedListData: selectedList as List<T>,
        choiceChipLabel: (item) => '',
        choiceChipBuilder: (context, item, isSelected) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected!
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).colorScheme.onSurface),
            ),
            child: Text(
              item.label,
              style: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onTertiaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                  fontSize: 15),
            )),
        validateSelectedItem: (list, val) {
          // for (var ele in selectedList) {
          //   if (ele.toString() == val.toString()) {
          //     print("Ciao");
          //   }
          // }
          return list!.contains(val);
        },
        onItemSearch: (ele, query) {
          if (ele is Cliente) {
            return ele.customer_code!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ele.customer_companyname!
                    .toLowerCase()
                    .contains(query.toLowerCase());
          } else if (ele is Luogo) {
            return ele.location_code!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ele.location_city!.toLowerCase().contains(query.toLowerCase());
          } else if (ele is Progetto) {
            return ele.project_code!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ele.customer_code!.toLowerCase().contains(query.toLowerCase());
          } else if (ele is Attivita) {
            return ele.project_task_code!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ele.project_code!.toLowerCase().contains(query.toLowerCase()) ||
                ele.customer_code!.toLowerCase().contains(query.toLowerCase());
          } else if (ele is TipoAttivita) {
            return ele.task_type_code!
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                ele.unity_code!.toLowerCase().contains(query.toLowerCase());
          } else if (ele is Utente) {
            return ele.username!.toLowerCase().contains(query.toLowerCase());
          } else {
            return false;
          }
        },
        onApplyButtonClick: (list) {
          setState(() {
            dataFetch.customer = list as List<Cliente>;
          });
          print(dataFetch.customer);
          Navigator.pop(context);
        },
      );
    }

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
                            onTap: () {
                              if (clienti.isEmpty) {
                                Service()
                                    .selectRead(sesid: globals.sesid, tipo: "C")
                                    .then((res) {
                                  clienti.clear();
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];

                                  // ignore: avoid_print
                                  for (var element in data) {
                                    clienti.add(Cliente(
                                        element["customer_id"],
                                        element["customer_code"],
                                        element["customer_companyname"]));
                                  }
                                  openFilterDialog(clienti);
                                });
                              } else {
                                openFilterDialog(clienti);
                              }
                            },
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
                            onTap: () {
                              if (luoghi.isEmpty) {
                                Service()
                                    .selectRead(sesid: globals.sesid, tipo: "L")
                                    .then((res) {
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];
                                  // ignore: avoid_print
                                  for (var element in data) {
                                    luoghi.add(Luogo(
                                        element["locatio_id"],
                                        element["location_code"],
                                        element["location_city"]));
                                  }
                                  openFilterDialog(luoghi);
                                });
                              } else {
                                openFilterDialog(luoghi);
                              }
                            },
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
                            onTap: () {
                              if (progetti.isEmpty) {
                                Service()
                                    .selectRead(sesid: globals.sesid, tipo: "P")
                                    .then((res) {
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];
                                  // ignore: avoid_print
                                  for (var element in data) {
                                    progetti.add(Progetto(
                                        element["project_id"],
                                        element["project_code"],
                                        element["customer_code"]));
                                  }
                                  openFilterDialog(progetti);
                                });
                              } else {
                                openFilterDialog(progetti);
                              }
                            },
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
                            onTap: () {
                              if (attivita.isEmpty) {
                                Service()
                                    .selectRead(sesid: globals.sesid, tipo: "A")
                                    .then((res) {
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];
                                  // ignore: avoid_print
                                  for (var element in data) {
                                    attivita.add(Attivita(
                                        element["project_task_id"],
                                        element["project_task_code"],
                                        element["project_code"],
                                        element["customer_code"]));
                                  }
                                  openFilterDialog(attivita);
                                });
                              } else {
                                openFilterDialog(attivita);
                              }
                            },
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
                            onTap: () {
                              if (tipoAttivita.isEmpty) {
                                Service()
                                    .selectRead(
                                        sesid: globals.sesid, tipo: "TA")
                                    .then((res) {
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];

                                  // ignore: avoid_print
                                  for (var element in data) {
                                    tipoAttivita.add(TipoAttivita(
                                        element["task_type_id"],
                                        element["task_type_code"],
                                        element["unity_code"]));
                                  }
                                  openFilterDialog(tipoAttivita);
                                });
                              } else {
                                openFilterDialog(tipoAttivita);
                              }
                            },
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
                            onTap: () {
                              if (utenti.isEmpty) {
                                Service()
                                    .selectRead(sesid: globals.sesid, tipo: "U")
                                    .then((res) {
                                  var body = jsonDecode(res.body);
                                  var data = body["data"];

                                  // ignore: avoid_print
                                  for (var element in data) {
                                    utenti.add(Utente(
                                        element["user_id"],
                                        element["username"],
                                        element["signature"],
                                        element["avatar"]));
                                  }
                                  openFilterDialog(utenti);
                                });
                              } else {
                                openFilterDialog(utenti);
                              }
                            },
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
