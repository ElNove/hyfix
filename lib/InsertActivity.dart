import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hyfix/models/Reports.dart';
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
  late Map<String, dynamic> utente;
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
  String refund = "N";
  var indirizzo = "";

  void initState() {
    // verityFirstRun();
    if (widget.dataAttuale.isAfter(DateTime.now())) {
      tipo = "E";
    } else {
      tipo = "R";
      cate = "T";
    }
    getUtente(globals.sesid);
    getClienti(globals.sesid, id);
    getProgetti(globals.sesid, id);
    getLuoghi(globals.sesid, id);
    getActivity(globals.sesid);
    super.initState();
  }

  void getUtente(sesid) async {
    final uri = Uri.https('hyfix.test.nealis.it', '/auth/user/read');

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.cookieHeader: sesid,
    });

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      if (elem["username"] == globals.username) {
        utente = elem;
      }
    }
  }

  void getClienti(sesid, id) async {
    clienti = [];
    _clientiOptions = [];
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
    progetti = [];
    _progettiOptions = [];
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
    luoghi = [];
    _luoghiOptions = [];
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
    print("via");
    activity = [];
    _activityOptions = [];
    final params = {
      'filters[unity_type]': cate,
    };
    final uri =
        Uri.https('hyfix.test.nealis.it', '/reports/tasktype/read', params);

    print("uri");
    print(uri);
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

  void insert() {
    final rep = Reports(
      id: 0,
      reportType: tipo,
      reportDate: widget.dataAttuale,
      customerId: cliente["customer_id"],
      locationId: luogo["location_id"],
      userId: 1,
      note: note,
      customerNote: "",
      projectId: progetto["project_id"],
      projectTaskId: "",
      taskTypeId: attivita["task_type_id"],
      quantity: "$task",
      customerQuantity: "$task",
      bill: attivita["bill"],
      refund: refund,
      refunded: "N",
      reportPrint: "${attivita["reportPrint"]}",
      billed: "N",
      blockdate: "",
      start: widget.dataAttuale,
      blocked: 0,
      typeDescription: "",
      customerCode: cliente["customer_code"],
      customerCompanyname: cliente["companyname"],
      locationCode: luogo["location_code"],
      locationAddress: luogo["location_address"],
      locationZip: luogo["location_zip"],
      locationCity: luogo["location_city"],
      locationProvince: luogo["location_province"],
      locationCountry: luogo["location_country"],
      projectCode: progetto["project_code"],
      projectDescription: progetto["project_code"],
      projectExpire: progetto["expire"],
      defaultProject: "${progetto["default"]}",
      projectPosition: progetto["position"],
      projectPositionNotZero: progetto["project_position_not_zero"],
      projectTaskCode: "",
      projectTaskDescription: "",
      projectTaskExpire: "",
      projectTaskEstimate: "",
      projectTaskPosition: 0,
      projectTaskPositionNotZero: 0,
      taskTypeCode: attivita["code"],
      unityId: attivita["unity_id"],
      taskTypeBill: attivita["bill"],
      taskTypeRefund: attivita["refund"],
      taskTypeReportPrint: attivita["report_print"],
      taskTypeColor: attivita["color_code"],
      color: attivita["color_code"],
      unityCode: attivita["unity_code"],
      unityType: attivita["unity_type"],
      firstOfTheMonth: DateTime(2024, 06, 01),
      locationDistance: luogo["location_distance"],
      locationFulladdress: luogo["location_fulladdress"],
      customerLocationId: luogo["customer_location_id"],
      username: utente["username"],
      signature: utente["signature"],
      avatar: "",
      userBlocked: 0,
      title: "",
    );
    widget.addElement(rep);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          backgroundColor: tipo == "R"
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // <-- Radius
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
                      width: 150,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          backgroundColor: tipo == "E"
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // <-- Radius
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
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  cate = "T";
                                });
                                getActivity(globals.sesid);
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
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  cate = "C";
                                });
                                getActivity(globals.sesid);
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
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8), // <-- Radius
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  cate = "D";
                                });
                                getActivity(globals.sesid);
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
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      return TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il cliente';
                          }
                          return null;
                        },
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                            label: Text('Cliente'),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          // Update suggestions based on user input
                          // Implement the logic to filter and refresh suggestions
                        },
                      );
                    }, onSelected: (String selection) {
                      var nomeC = selection.split(" ");
                      for (var c in clienti) {
                        if (c["companyname"] == nomeC[2]) {
                          cliente = c;
                        }
                      }
                      ;
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
                        return option
                            .contains(textEditingValue.text.toUpperCase());
                      });
                    }, fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci il progetto';
                          }
                          return null;
                        },
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                            label: Text('Progetto'),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          // Update suggestions based on user input
                          // Implement the logic to filter and refresh suggestions
                        },
                      );
                    }, onSelected: (String selection) {
                      var nomeP = selection.split(" ");
                      for (var p in progetti) {
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
                      return option
                          .contains(textEditingValue.text.toUpperCase());
                    });
                  }, fieldViewBuilder: (BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                    return TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Inserisci il luogo';
                        }
                        return null;
                      },
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      decoration: const InputDecoration(
                          label: Text('Luogo'), border: OutlineInputBorder()),
                      onChanged: (text) {
                        // Update suggestions based on user input
                        // Implement the logic to filter and refresh suggestions
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
                      print("attivita");
                      print(_activityOptions);
                      if (textEditingValue.text == '') {
                        return _activityOptions;
                      }
                      return _activityOptions.where((String option) {
                        return option
                            .contains(textEditingValue.text.toUpperCase());
                      });
                    }, fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Inserisci l'attività";
                          }
                          return null;
                        },
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                            label: Text('Attività'),
                            border: OutlineInputBorder()),
                        onChanged: (text) {
                          // Update suggestions based on user input
                          // Implement the logic to filter and refresh suggestions
                          fieldTextEditingController.value =
                              TextEditingValue(text: text);
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
                    child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci le note';
                          }
                          return null;
                        },
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
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: RefundButton(),
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
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.

                        insert();
                        Navigator.pop(context);
                      } else {
                        print("ok");
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Attenzione'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Devi riempire tutti i campi!'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      /*
                    
                  }*/
                    },
                    child: Text(
                      'Aggiungi',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
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
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                  )
                ],
              ),
            ])));
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
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci la quantità';
        }
        return null;
      },
      decoration: new InputDecoration(
          labelText: "Quantità", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onChanged: (value) {
        widget.task(int.parse(value));
      }, // Only numbers can be entered
    );
  }
}

////////////////////   REFUND   //////////////////////

class RefundButton extends StatefulWidget {
  const RefundButton({super.key});

  @override
  State<RefundButton> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RefundButton> {
  String s = "N";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            title: const Text('Rimborso'),
            leading: Radio<String>(
                value: s,
                toggleable: true,
                groupValue: "Rimborso",
                onChanged: (String? value) {
                  setState(() {
                    if (s == "S") {
                      s = "N";
                    } else {
                      s = "S";
                    }
                  });
                  print(value);
                })),
      ],
    );
  }
}
