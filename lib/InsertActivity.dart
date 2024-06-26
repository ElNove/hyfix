import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Login.dart' as globals;

const List<int> _hoursOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8];

class InsertActivity extends StatefulWidget {
  const InsertActivity(
      {super.key, required this.addElement, required this.dataAttuale});
  final Function addElement;
  final DateTime dataAttuale;

  _InsertActivity createState() => _InsertActivity();
}

class _InsertActivity extends State<InsertActivity> {
  List<Map<String, dynamic>> activity = <Map<String, dynamic>>[];
  List<String> _activityOptions = <String>[];
  List<Map<String, dynamic>> clienti = <Map<String, dynamic>>[];
  List<String> _clientiOptions = <String>[];
  List<Map<String, dynamic>> progetti = <Map<String, dynamic>>[];
  List<String> _progettiOptions = <String>[];
  List<Map<String, dynamic>> luoghi = <Map<String, dynamic>>[];
  List<String> _luoghiOptions = <String>[];
  late Map<String, dynamic> cliente;
  late Map<String, dynamic> luogo;
  late Map<String, dynamic> progetto;
  late Map<String, dynamic> attivita;
  var id = 0;

  String tipo = "";
  String note = "";
  String cate = "";
  int task = 0;
  String task_type = "";
  var indirizzo = "";

  void initState() {
    // verityFirstRun();
    if (widget.dataAttuale.isAfter(DateTime.now())) {
      tipo = "E";
    } else {
      tipo = "R";
      cate = "T";
    }
    getClienti(globals.sesid, id);
    getProgetti(globals.sesid, id);
    getLuoghi(globals.sesid, id);
    super.initState();
  }

  void getClienti(sesid, id) async {
    clienti = [];
    _clientiOptions=[];
    print("get Clietni");
    final params = {
      'filters[id]': '$id',
    };
    final uri;
    if (id == 0) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customer/read');
    } else {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customer/read', params);
    }
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      clienti.add(elem);
      _clientiOptions.add(elem["code"] + " - " + elem["companyname"]);
    }
  }

  void getProgetti(sesid, id) async {
    progetti=[];
    _progettiOptions=[];
    final params = {
      "filters[project_or_customer]": '$id',
    };
    final uri;
    if (id == 0) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/project/readactive');
    } else {
      uri = Uri.https(
          'hyfix.test.nealis.it', '/reports/project/readactive', params);
    }

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      progetti.add(elem);
      _progettiOptions.add(elem["code"] + " - " + elem["customer_companyname"]);

    }
  }

  void getLuoghi(sesid, id) async {
    luoghi=[];
    _luoghiOptions=[];
    final params = {
      'filters[customer_id]': '${id}',
    };

    final uri;
    if (id == 0) {
      uri = Uri.https('hyfix.test.nealis.it', '/reports/customerlocation/read');
    } else {
      uri = Uri.https(
          'hyfix.test.nealis.it', '/reports/customerlocation/read', params);
    }
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );
    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      luoghi.add(elem);
      _luoghiOptions.add(elem["location_code"] +
          " - " +
          elem["customer_code"] +
          " - " +
          elem["location_city"]);
    }
  }

  void getActivity(sesid) async {
    activity = [];
    _luoghiOptions=[];
    final params = {
      'filters[unity_type]': cate,
    };
    print(params);
    final uri =
        Uri.https('hyfix.test.nealis.it', '/reports/tasktype/read', params);
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    );
    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      activity.add(elem);
      _activityOptions.add(elem["task_type_code"] + " - " + elem["unity_code"]);
    }
  }

  void assegnaTask(int o) {
    task = o;
  }

  void aggiornaTipo(String t) {
    tipo = t;
  }
  void FetchClienti() {}
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Text(
            "AGGIUNGI ",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryContainer,
                fontSize: 50,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      backgroundColor: tipo == "R"
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        tipo = "R";
                      });
                    },
                    child: Text(
                      'Rapportino',
                      style: TextStyle(
                        color: tipo == "R"
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  )),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                  width: 150,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color:
                              Theme.of(context).colorScheme.primaryContainer),
                      backgroundColor: tipo == "E"
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        tipo = "E";
                      });
                    },
                    child: Text(
                      'Evento',
                      style: TextStyle(
                        color: tipo == "E"
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          tipo == 'R'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 3),
                            backgroundColor: cate == "T"
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              cate = "T";
                              getActivity(globals.sesid);
                            });
                          },
                          child: Text(
                            'Tempo',
                            style: TextStyle(
                              color: cate == "T"
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        width: 100,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 3),
                            backgroundColor: cate == "C"
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              cate = "C";
                              getActivity(globals.sesid);
                            });
                          },
                          child: Text(
                            'Costo',
                            style: TextStyle(
                              color: cate == "C"
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        width: 100,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 3),
                            backgroundColor: cate == "D"
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              cate = "D";
                              getActivity(globals.sesid);
                            });
                          },
                          child: Text(
                            'Distanza',
                            style: TextStyle(
                              color: cate == "D"
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                            ),
                          ),
                        ))
                  ],
                )
              : Text(""),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Data: ${DateFormat('dd/MM/yyyy').format(widget.dataAttuale)}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return _clientiOptions;
                  }
                  return _clientiOptions.where((String option) {
                    return option
                        .toUpperCase()
                        .contains(textEditingValue.text.toUpperCase());
                  });
                }, fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                        label: Text('Cliente'), border: OutlineInputBorder()),
                    onChanged: (text) {
                      // Update suggestions based on user input
                      // Implement the logic to filter and refresh suggestions
                    },
                    onSubmitted: (text) {
                      // Handle the submission of the selected suggestion
                      // Implement the logic for the selection action
                      fieldTextEditingController.text="";
                    },
                  );
                }, onSelected: (String selection) {
                  var nomeC = selection.split(" ");
                  for (var c in clienti) {
                    if (c["companyname"] == nomeC[2]) {
                      cliente = c;
                    }
                  };
                  if (id == 0) {
                    setState(() {
                      id = cliente["customer_id"];
                    });
                  }

                  getProgetti(globals.sesid, id);
                  getLuoghi(globals.sesid, id);
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Autocomplete<String>(

                    //initialValue: TextEditingValue(text:progetti[0]["code"]+" - "+progetti[0]["customer_code"]),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return _progettiOptions;
                  }
                  return _progettiOptions.where((String option) {
                    return option.contains(textEditingValue.text.toUpperCase());
                  });
                }, fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                        label: Text('Progetto'), border: OutlineInputBorder()),
                    onChanged: (text) {
                      // Update suggestions based on user input
                      // Implement the logic to filter and refresh suggestions
                    },
                    onSubmitted: (text) {
                      // Handle the submission of the selected suggestion
                      // Implement the logic for the selection action
                    },
                  );
                }, onSelected: (String selection) {
                  var nomeP = selection.split(" ");
                  for (var p in progetti) {
                    print(p);
                    if (p["code"] == nomeP[0]) {
                      progetto = p;
                    }
                  }
                  if (id == 0) {
                    setState(() {
                      id = progetto["customer_id"];
                    });
                    getLuoghi(globals.sesid, id);
                    getClienti(globals.sesid, id);
                  }
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return _luoghiOptions;
                }
                return _luoghiOptions.where((String option) {
                  return option.contains(textEditingValue.text.toUpperCase());
                });
              }, fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                      label: Text('Luogo'), border: OutlineInputBorder()),
                  onChanged: (text) {
                    // Update suggestions based on user input
                    // Implement the logic to filter and refresh suggestions
                  },
                  onSubmitted: (text) {
                    // Handle the submission of the selected suggestion
                    // Implement the logic for the selection action
                  },
                );
              }, onSelected: (String selection) {
                var nomeL = selection.split(" ");
                for (var l in luoghi) {
                  if (l["location_code"] == nomeL[0]) {
                    luogo = l;
                    setState(() {
                      indirizzo = l["location_fulladdress"];
                    });
                  }
                }
                ;
                if (id == 0) {
                  setState(() {
                    id = luogo["customer_id"];
                  });
                }
                getProgetti(globals.sesid, id);
                getClienti(globals.sesid, id);
              })),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Row(
                    children: [
                      const Text(
                        "INDIRIZZO: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${indirizzo} ",
                      ),
                    ],
                  ))),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return _activityOptions;
                  }
                  return _activityOptions.where((String option) {
                    return option.contains(textEditingValue.text.toUpperCase());
                  });
                }, fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                        label: Text('Attività'), border: OutlineInputBorder()),
                    onChanged: (text) {
                      // Update suggestions based on user input
                      // Implement the logic to filter and refresh suggestions
                    },
                    onSubmitted: (text) {
                      // Handle the submission of the selected suggestion
                      // Implement the logic for the selection action
                    },
                  );
                }, onSelected: (String selection) {
                  var nomeA = selection.split(" ");
                  for (var a in activity) {
                    if (a["task_type_code"] == nomeA[0]) {
                      attivita = a;
                      setState(() {
                        task_type = a["unity_code"];
                      });
                      print(a);
                    }
                  }
                  ;
                }),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                child: Task(
                  task: assegnaTask,
                  task_type: task_type,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                task_type,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Note',
                    ),
                    onChanged: (String newText) {
                      note = newText;
                    }),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Aggiungi',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // <-- Radius
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Chiudi',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              )
            ],
          ),
        ]));
  }
}

////////////////     ORE     ///////////////////////

class Task extends StatefulWidget {
  const Task({super.key, required this.task, required this.task_type});
  final Function task;
  final String task_type;

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: new InputDecoration(
            labelText: "Quantità", border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ] // Only numbers can be entered
        );
  }
}

////////////////////   TIPO   //////////////////////
