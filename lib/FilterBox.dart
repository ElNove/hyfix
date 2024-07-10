import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:hyfix/Home.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:hyfix/services/Service.dart';
import 'Login.dart' as globals;

class Cliente {
  dynamic id;
  dynamic customer_code;
  dynamic customer_companyname;
  String label = "";

  Cliente(this.id, this.customer_code, this.customer_companyname) {
    id = id;
    customer_code = customer_code;
    customer_companyname = customer_companyname;
    label = "$customer_code - $customer_companyname";
  }
  @override
  String toString() {
    return "$customer_code - $customer_companyname";
  }
}

class Luogo {
  dynamic id;
  dynamic location_code;
  dynamic location_city;
  String label = "";

  Luogo(this.id, this.location_code, this.location_city) {
    id = id;
    location_code = location_code;
    location_city = location_city;
    label = "$location_code - $location_city";
  }
  @override
  String toString() {
    return "$id - $location_code - $location_city";
  }
}

class Progetto {
  dynamic id;
  dynamic project_code;
  dynamic customer_code;
  String label = "";

  Progetto(this.id, this.project_code, this.customer_code) {
    id = id;
    project_code = project_code;
    customer_code = customer_code;
    label = "$project_code - $customer_code";
  }
  @override
  String toString() {
    return "$id - $project_code - $customer_code";
  }
}

class Attivita {
  dynamic id;
  dynamic project_task_code;
  dynamic project_code;
  dynamic customer_code;
  String label = "";

  Attivita(
      this.id, this.project_task_code, this.project_code, this.customer_code) {
    id = id;
    project_task_code = project_task_code;
    project_code = project_code;
    customer_code = customer_code;
    label = "$project_task_code - $project_code - $customer_code";
  }
  @override
  String toString() {
    return "$id - $project_task_code - $project_code -  $customer_code";
  }
}

class TipoAttivita {
  dynamic id;
  dynamic task_type_code;
  dynamic unity_code;
  String label = "";

  TipoAttivita(this.id, this.task_type_code, this.unity_code) {
    id = id;
    task_type_code = task_type_code;
    unity_code = unity_code;
    label = "$task_type_code - $unity_code";
  }
  @override
  String toString() {
    return "$id - $task_type_code - $unity_code";
  }
}

class Utente {
  dynamic id;
  dynamic username;
  dynamic signature;
  dynamic avatar;
  String label = "";

  Utente(this.id, this.username, this.signature, this.avatar) {
    id = id;
    username = username;
    signature = signature;
    avatar = avatar;
    label = "$username";
  }
  @override
  String toString() {
    return "$id - $username - $signature - $avatar";
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

class _FilterboxState<T extends Object> extends State<Filterbox> {
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
    List<T> selectedList = [];
    String tipo = "";

    void openFilterDialog(List<T> lista) async {
      setState(() {
        for (var ele in lista) {
          if (ele is Cliente) {
            selectedList = dataFetch.customer as List<T>;
            tipo = "C";
          } else if (ele is Luogo) {
            selectedList = dataFetch.location as List<T>;
            tipo = "L";
          } else if (ele is Progetto) {
            selectedList = dataFetch.project as List<T>;
            tipo = "P";
          } else if (ele is Attivita) {
            selectedList = dataFetch.projectTask as List<T>;
            tipo = "A";
          } else if (ele is TipoAttivita) {
            selectedList = dataFetch.taskType as List<T>;
            tipo = "T";
          } else if (ele is Utente) {
            selectedList = dataFetch.user as List<T>;
            tipo = "U";
          }
          break;
        }
      });

      await FilterListDialog.display<T>(
        applyButtonText: 'Applica',
        allButtonText: 'Tutti',
        themeData: FilterListThemeData(
          context,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          headerTheme: HeaderThemeData(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            closeIconColor: Theme.of(context).colorScheme.onTertiaryContainer,
            searchFieldBackgroundColor:
                Theme.of(context).colorScheme.onTertiaryContainer,
            searchFieldIconColor:
                Theme.of(context).colorScheme.tertiaryContainer,
            searchFieldHintText: 'Cerca...',
            searchFieldHintTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.outline, fontSize: 18),
            searchFieldTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontSize: 18),
            headerTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          controlButtonBarTheme: ControlButtonBarThemeData(
            context,
            backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
            controlButtonTheme: ControlButtonThemeData(
              primaryButtonBackgroundColor:
                  Theme.of(context).colorScheme.tertiaryContainer,
              primaryButtonTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontSize: 15,
              ),
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                fontSize: 15,
              ),
            ),
          ),
        ),
        context,
        hideCloseIcon: true,
        listData: lista,
        selectedItemsText: 'Selezionati',
        selectedListData: selectedList,
        choiceChipLabel: (item) => '',
        choiceChipBuilder: (context, item, isSelected) {
        
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected! || selectedList.contains(item.toString())
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onTertiaryContainer),
              ),
              child: Text(
                item.label,
                style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: 15),
              ));
        },
        validateSelectedItem: (list, val) {
          return list.toString().contains(val.toString());
        },
        validateRemoveItem: (list, item) {
          list!.remove(item);
          for (var ele in list) {
            if (ele.toString() == item.toString()) {
              list.remove(ele);
              break;
            }
          }
          return list.cast<T>();
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
            switch (tipo) {
              case "C":
                dataFetch.customer = list!.cast<Cliente>();
                break;
              case "L":
                dataFetch.location = list!.cast<Luogo>();
                break;
              case "P":
                dataFetch.project = list!.cast<Progetto>();
                break;
              case "A":
                dataFetch.projectTask = list!.cast<Attivita>();
                break;
              case "T":
                dataFetch.taskType = list!.cast<TipoAttivita>();
                break;
              case "U":
                dataFetch.user = list!.cast<Utente>();
                break;
              default:
            }
            selectedList = list!;

            var jobList = context.read<JobList>();
            jobList.updateLista();
            widget.fetchRep(
                first: dataFetch.first,
                last: dataFetch.last,
                type: dataFetch.type,
                customer: dataFetch.getId(dataFetch.customer),
                location: dataFetch.getId(dataFetch.location),
                project: dataFetch.getId(dataFetch.project),
                projectTask: dataFetch.getId(dataFetch.projectTask),
                taskType: dataFetch.getId(dataFetch.taskType),
                user: dataFetch.getId(dataFetch.user));
          });
          Navigator.pop(context);
        },
      );
    }

    Future<void> startLoading() async {
      return await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor:
                Colors.transparent, // can change this to your prefered color
            children: <Widget>[
              Center(
                child: RefreshProgressIndicator(),
              )
            ],
          );
        },
      );
    }

    Future<void> stopLoading() async {
      Navigator.of(context).pop();
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
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            fontSize:
                                MediaQuery.of(context).size.height / 100 * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
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
                            child: Text('TIPO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
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
                          textStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                              fontWeight: FontWeight.bold),
                          width: screenWidth / 100 * 40,
                          trailingIcon: Icon(Icons.arrow_drop_down,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer),
                          selectedTrailingIcon: Icon(
                            Icons.arrow_drop_up,
                            color: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                          ),
                          initialSelection: dataFetch.type,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: '', label: ''),
                            DropdownMenuEntry(value: 'R', label: 'Rapportino'),
                            DropdownMenuEntry(value: 'E', label: 'Evento'),
                          ],
                          onSelected: (value) async {
                            getWeeksOfMonth(widget.data);

                            dataFetch.type = value ?? '';

                            clear().then((val) {
                              widget.fetchRep(
                                  first: dataFetch.first,
                                  last: dataFetch.last,
                                  type: dataFetch.type,
                                  customer: dataFetch.getId(dataFetch.customer),
                                  location: dataFetch.getId(dataFetch.location),
                                  project: dataFetch.getId(dataFetch.project),
                                  projectTask:
                                      dataFetch.getId(dataFetch.projectTask),
                                  taskType: dataFetch.getId(dataFetch.taskType),
                                  user: dataFetch.getId(dataFetch.user));
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
                            child: Text('CLIENTE',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.customer.isEmpty
                                  ? ""
                                  : "${dataFetch.customer.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service()
                                  .selectRead(
                                      sesid: globals.sesid,
                                      tipo: "C",
                                      report_type: dataFetch.type,
                                      customer_id: [],
                                      location_id:
                                          dataFetch.getId(dataFetch.location),
                                      project_id:
                                          dataFetch.getId(dataFetch.project),
                                      project_task_id: dataFetch
                                          .getId(dataFetch.projectTask),
                                      task_type_id:
                                          dataFetch.getId(dataFetch.taskType),
                                      user_id: dataFetch.getId(dataFetch.user))
                                  .then((res) {
                                clienti.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];
                                for (var element in data) {
                                  clienti.add(Cliente(
                                      element["customer_id"],
                                      element["customer_code"],
                                      element["customer_companyname"]));
                                }
                                stopLoading();
                                openFilterDialog(clienti.cast<T>());
                              });
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
                            child: Text('LUOGO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.location.isEmpty
                                  ? ""
                                  : "${dataFetch.location.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service()
                                  .selectRead(
                                      sesid: globals.sesid,
                                      tipo: "L",
                                      report_type: dataFetch.type,
                                      customer_id:
                                          dataFetch.getId(dataFetch.customer),
                                      location_id: [],
                                      project_id:
                                          dataFetch.getId(dataFetch.project),
                                      project_task_id: dataFetch
                                          .getId(dataFetch.projectTask),
                                      task_type_id:
                                          dataFetch.getId(dataFetch.taskType),
                                      user_id: dataFetch.getId(dataFetch.user))
                                  .then((res) {
                                luoghi.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];
                                for (var element in data) {
                                  luoghi.add(Luogo(
                                      element["location_id"],
                                      element["location_code"],
                                      element["location_city"]));
                                }
                                stopLoading();
                                openFilterDialog(luoghi.cast<T>());
                              });
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
                            child: Text('PROGETTO',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.project.isEmpty
                                  ? ""
                                  : "${dataFetch.project.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service()
                                  .selectRead(
                                      sesid: globals.sesid,
                                      tipo: "P",
                                      report_type: dataFetch.type,
                                      customer_id:
                                          dataFetch.getId(dataFetch.customer),
                                      location_id:
                                          dataFetch.getId(dataFetch.location),
                                      project_id: [],
                                      project_task_id: dataFetch
                                          .getId(dataFetch.projectTask),
                                      task_type_id:
                                          dataFetch.getId(dataFetch.taskType),
                                      user_id: dataFetch.getId(dataFetch.user))
                                  .then((res) {
                                progetti.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];
                                for (var element in data) {
                                  progetti.add(Progetto(
                                      element["project_id"],
                                      element["project_code"],
                                      element["customer_code"]));
                                }
                                stopLoading();
                                openFilterDialog(progetti.cast<T>());
                              });
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
                            child: Text('ATTIVITÀ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.projectTask.isEmpty
                                  ? ""
                                  : "${dataFetch.projectTask.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service()
                                  .selectRead(
                                      sesid: globals.sesid,
                                      tipo: "A",
                                      report_type: dataFetch.type,
                                      customer_id:
                                          dataFetch.getId(dataFetch.customer),
                                      location_id:
                                          dataFetch.getId(dataFetch.location),
                                      project_id:
                                          dataFetch.getId(dataFetch.project),
                                      project_task_id: [],
                                      task_type_id:
                                          dataFetch.getId(dataFetch.taskType),
                                      user_id: dataFetch.getId(dataFetch.user))
                                  .then((res) {
                                attivita.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];
                                for (var element in data) {
                                  attivita.add(Attivita(
                                      element["project_task_id"],
                                      element["project_task_code"],
                                      element["project_code"],
                                      element["customer_code"]));
                                }
                                stopLoading();
                                openFilterDialog(attivita.cast<T>());
                              });
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
                            child: Text('TIPO ATTIVITÀ',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 40,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.taskType.isEmpty
                                  ? ""
                                  : "${dataFetch.taskType.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service()
                                  .selectRead(
                                      sesid: globals.sesid,
                                      tipo: "TA",
                                      report_type: dataFetch.type,
                                      customer_id:
                                          dataFetch.getId(dataFetch.customer),
                                      location_id:
                                          dataFetch.getId(dataFetch.location),
                                      project_id:
                                          dataFetch.getId(dataFetch.project),
                                      project_task_id: dataFetch
                                          .getId(dataFetch.projectTask),
                                      task_type_id: [],
                                      user_id: dataFetch.getId(dataFetch.user))
                                  .then((res) {
                                tipoAttivita.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];

                                for (var element in data) {
                                  tipoAttivita.add(TipoAttivita(
                                      element["task_type_id"],
                                      element["task_type_code"],
                                      element["unity_code"]));
                                }
                                stopLoading();
                                openFilterDialog(tipoAttivita.cast<T>());
                              });
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
                            child: Text('UTENTE',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          width: screenWidth / 100 * 80,
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: dataFetch.user.isEmpty
                                  ? ""
                                  : "${dataFetch.user.length} selezionati",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer),
                              fillColor: Theme.of(context).colorScheme.tertiary,
                              filled: true,
                              suffixIcon: Icon(
                                Icons.filter_list,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onTap: () {
                              startLoading();
                              Service().selectRead(
                                  sesid: globals.sesid,
                                  tipo: "U",
                                  report_type: dataFetch.type,
                                  customer_id:
                                      dataFetch.getId(dataFetch.customer),
                                  location_id:
                                      dataFetch.getId(dataFetch.location),
                                  project_id:
                                      dataFetch.getId(dataFetch.project),
                                  project_task_id:
                                      dataFetch.getId(dataFetch.projectTask),
                                  task_type_id:
                                      dataFetch.getId(dataFetch.taskType),
                                  user_id: []).then((res) {
                                utenti.clear();
                                var body = jsonDecode(res.body);
                                var data = body["data"];

                                for (var element in data) {
                                  utenti.add(Utente(
                                      element["user_id"],
                                      element["username"],
                                      element["signature"],
                                      element["avatar"]));
                                }
                                stopLoading();
                                openFilterDialog(utenti.cast<T>());
                              });
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
