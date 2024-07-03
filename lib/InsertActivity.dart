import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'Login.dart' as globals;
import './models/ReportSave.dart';

const List<int> _hoursOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8];
var loading = false;

class InsertActivity extends StatefulWidget {
  const InsertActivity(
      {super.key, required this.fetchCalendar, required this.dataAttuale});
  final Function fetchCalendar;
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
  late Map<String, dynamic> utente = {};
  late Map<String, dynamic> cliente = {};
  late Map<String, dynamic> luogo = {};
  late Map<String, dynamic> progetto = {};
  late Map<String, dynamic> attivita={};
  var id = 0;
  bool rimborso = false;
  String tipo = "";
  String note = "";
  String cate = "T";
  int task = 0;
  String task_type = "";
  var indirizzo = "";
  var tempCli = "";
  var tempLoc = "";
  var tempPro = "";
  var tempAct = "";

  void initState() {
    // verityFirstRun();
    setState(() {
      loading = false;
    });
    if (widget.dataAttuale.isAfter(DateTime.now())) {
      tipo = "E";
    } else {
      tipo = "R";
    }
    getUtente(globals.sesid);
    getClienti(globals.sesid, id);
    getProgetti(globals.sesid, id);
    getLuoghi(globals.sesid, id);

    setState(() {
      loading = true;
    });
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
        setState(() {
          utente = elem;
        });
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
    _progettiOptions.clear();
    final params = {
      "filters[customer_id]": '$id',
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
      _progettiOptions.add(elem["code"] + " - " + elem["customer_code"]);
    }
  }

  void getLuoghi(sesid, id) async {
    luoghi = [];
    _luoghiOptions.clear();
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
      if (id != 0) {
        if (elem["default_location"] == "Y") {
          setState(() {
            luogo = elem;
          });
        }
      }
      luoghi.add(elem);
      _luoghiOptions.add(elem["location_code"] +
          " - " +
          elem["customer_code"] +
          " - " +
          elem["location_city"]);
    }
    setState(() {
      _luoghiOptions = _luoghiOptions;
      luoghi = luoghi;
    });
  }

  void getResolve(sesid, id, code, tipo) async {
    var params;

    setState(() {
      loading = false;
    });
    switch (tipo) {
      case "C":
        lController.clear();
        params = {
          'data[customer_id]': '$id',
          'data[customer_code]': '$code',
          'fieldsNames[]': ['customer_id', 'customer_code'],
        };
        break;
      case "L":
        cController.clear();
        params = {
          'data[customer_location_id]': '$id',
          'data[location_code]': '$code',
          'fieldsNames[]': ['customer_location_id', 'location_code'],
        };
        break;
      case "P":
        cController.clear();
        lController.clear();
        params = {
          'data[project_id]': '$id',
          'data[project_code]': '$code',
          'fieldsNames[]': ['project_id', 'project_code'],
        };
        break;
      case "A":
        params = {
          'data[task_type_id]': '$id',
          'data[task_type_code]': '$code',
          'data[unity_code]': '${attivita["unity_code"]}',
          'fieldsNames[]': ['task_type_id', 'task_type_code','unity_code'],
        };
        break;
    }

    final uri;
    uri = Uri.https('hyfix.test.nealis.it', '/reports/report/resolve', params);
    await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.cookieHeader: sesid,
      },
    ).then((response) async {
      var deco = jsonDecode(response.body);
      var data = deco["data"];
      switch (tipo) {
        case "C":
          var loc = (data["location_code"] +
              " - " +
              data["customer_code"] +
              " - " +
              data["location_city"]);
          setState(() {
            lController.text = loc;
            indirizzo = data["location_fulladdress"];
            aController.clear();
            pController.clear();
          });

          break;
        case "L":
          final params = {
            'filters[id]': '${data["customer_id"]}',
          };
          final uri;
          uri = Uri.https(
              'hyfix.test.nealis.it', '/reports/customer/read', params);

          await http.get(uri, headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.cookieHeader: globals.sesid,
          }).then((resp) {
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            var cli2 = (data["customer_code"] + " - " + d[0]["companyname"]);
            setState(() {
              cliente = d[0];
              cController.text = cli2;
              aController.clear();
            });
          });
          break;
        case "P":
          var pro = (data["project_code"] + " - " + data["customer_code"]);
          setState(() {
            pController.text = pro;
          });
          var loc = (data["location_code"] +
              " - " +
              data["customer_code"] +
              " - " +
              data["location_city"]);
          setState(() {
            lController.text = loc;
            indirizzo = data["location_fulladdress"];
          });

          final params = {
            'filters[id]': '${data["customer_id"]}',
          };
          final uri;
          uri = Uri.https(
              'hyfix.test.nealis.it', '/reports/customer/read', params);

          await http.get(uri, headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.cookieHeader: globals.sesid,
          }).then((resp) {
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            var cli2 = (data["customer_code"] + " - " + d[0]["companyname"]);
            setState(() {
              cliente = d[0];
              cController.text = cli2;
            });
          });
          break;
        case "A":
           final params = {
            'filters[customer_id]': '${cliente["customer_id"]}',
          };
          final uri;
          uri = Uri.https(
              'hyfix.test.nealis.it', '/reports/project/readactive', params);

          await http.get(uri, headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.cookieHeader: globals.sesid,
          }).then((resp) {
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            setState(() {
              progetto = d[0];
            });
          });
          break;
      }

      setState(() {
        // _clientiOptions.clear();
        // _activityOptions.clear();
        // _progettiOptions.clear();
        // luoghi.clear();
        _clear("L");
        _clear("P");
        _clear("A");
        
      });
      getLuoghi(globals.sesid, cliente["customer_id"]);
      getProgetti(globals.sesid, cliente["customer_id"]);
      setState(() {
        loading = true;
      });
    });
  }

  void getActivity(sesid) async {
    activity = [];
    _activityOptions = [];
    final params = {
      'filters[unity_type]': cate,
    };
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

  void assegnaRimborso(bool r) {
    rimborso = r;
  }

  String getRimborso() {
    if (rimborso) {
      return "Y";
    } else {
      return "N";
    }
  }

  void insert() async {
    final rep = ReportSave(
      id: 0,
      reportType: tipo,
      reportDate: widget.dataAttuale,
      customerId: cliente["customer_id"],
      customerLocationId: luogo["customer_location_id"],
      customerCode: cliente["customer_code"],
      locationId: luogo["location_id"],
      locationCode: luogo["location_code"],
      locationFulladdress: luogo["location_fulladdress"],
      locationDistance: luogo["location_distance"],
      projectId: progetto["project_id"],
      defaultProject: progetto["default_project"],
      projectTaskId: 0,
      taskTypeId: attivita["task_type_id"],
      taskTypeCode: attivita["task_type_code"],
      quantity: task,
      customerQuantity: task,
      note: "",
      customerNote: note,
      userId: utente["id"],
      signature: utente["signature"],
      username: utente["username"],
      bill: "Y",
      billed: "N",
      refund: getRimborso(),
      refunded: "N",
      reportPrint: "N",
      unityCode: attivita["unity_code"],
      unityType: attivita["unity_type"],
      reportUnityType: cate,
      userBlocked: utente["is_active"],
      locationCity: luogo["location_city"],
      customerCompanyname: progetto["customer_companyname"],
      locationAddress: luogo["location_address"],
      locationZip: luogo["location_zip"],
      locationProvince: luogo["location_province"],
      locationCountry: luogo["location_country"],
      projectCode: progetto["project_code"],
      projectExpire: progetto["expire"].toString(),
      projectActive: progetto["active"],
      unityId: attivita["unity_id"],
    );
    var uri = Uri.https('hyfix.test.nealis.it', '/reports/report/save');
    await http
        .post(uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Cookie': globals.sesid,
            },
            body: ReportSaveToJson(rep))
        .then((report) {
      DateTime focusedDay = DateTime.now();

      List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

      widget.fetchCalendar(weeks.first.first, weeks.last.last);
      Navigator.pop(context);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController cController = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController lController = TextEditingController();
  TextEditingController aController = TextEditingController();

  void _clear(type) {
    switch (type) {
      case "C":
        setState(() {
          _clientiOptions.clear();
        });
        for (var element in clienti) {
          _clientiOptions.add(element["code"] + " - " + element["companyname"]);
        }
        setState(() {
          _clientiOptions = _clientiOptions;
        });
        break;
      case "L":
        setState(() {
          _luoghiOptions.clear();
        });
        for (var element in luoghi) {
          _luoghiOptions.add(element["location_code"] +
              " - " +
              element["customer_code"] +
              " - " +
              element["location_city"]);
        }
        setState(() {
          _luoghiOptions = _luoghiOptions;
        });
        break;
      case "P":
        setState(() {
          _progettiOptions.clear();
        });
        for (var element in progetti) {
          _progettiOptions
              .add(element["project_code"] + " - " + element["customer_code"]);
        }
        setState(() {
          _progettiOptions = _progettiOptions;
        });
        break;
      case "A":
        setState(() {
          _activityOptions.clear();
        });
        for (var element in activity) {
          _activityOptions
              .add(element["task_type_code"] + " - " + element["unity_code"]);
        }
        setState(() {
          _activityOptions = _activityOptions;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Text(
                      "AGGIUNGI ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontSize: screenHeight / 100 * 4,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: screenWidth / 100 * 40,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 3),
                                backgroundColor: tipo == "R"
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
                            width: screenWidth / 100 * 40,
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    width: 3),
                                backgroundColor: tipo == "E"
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
                                  tipo = "E";
                                  cate = "T";
                                  rimborso = false;
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
                                  width: screenWidth / 100 * 23,
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
                                        borderRadius: BorderRadius.circular(
                                            8), // <-- Radius
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        cate = "T";
                                        rimborso = false;

                                        _clear("P");
                                        _clear("A");
                                        pController.clear();
                                        aController.clear();
                                        task_type="";
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
                                  width: screenWidth / 100 * 23,
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
                                        borderRadius: BorderRadius.circular(
                                            8), // <-- Radius
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        cate = "C";

                                        _clear("P");
                                        _clear("A");
                                        pController.clear();
                                        aController.clear();
                                        task_type="";
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
                                  width: screenWidth / 100 * 23,
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
                                        borderRadius: BorderRadius.circular(
                                            8), // <-- Radius
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        cate = "D";

                                        _clear("P");
                                        _clear("A");
                                        pController.clear();
                                        aController.clear();
                                        task_type="";
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
                      style: TextStyle(
                          fontSize: screenHeight / 100 * 2,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Autocomplete<String>(optionsBuilder:
                              (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return _clientiOptions;
                            }
                            return _clientiOptions.where((String option) {
                              return option.toUpperCase().contains(
                                  textEditingValue.text.toUpperCase());
                            });
                          }, fieldViewBuilder: (BuildContext context,
                              customerController,
                              FocusNode clientFocus,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              enabled: loading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il cliente';
                                }
                                return null;
                              },
                              controller: cController,
                              focusNode: clientFocus,
                              decoration: const InputDecoration(
                                  label: Text('Cliente'),
                                  border: OutlineInputBorder()),
                              onChanged: (text) {
                                // Update suggestions based on user input
                                // Implement the logic to filter and refresh suggestions
                                if (text == "") {
                                  _clear("C");
                                  return;
                                }

                                setState(() {
                                  _clientiOptions.clear();
                                });
                                clienti.forEach((element) {
                                  if (element["companyname"].contains(text) ||
                                      element["code"].contains(text)) {
                                    _clientiOptions.add(element["code"] +
                                        " - " +
                                        element["companyname"]);
                                  }
                                });
                                setState(() {
                                  _clientiOptions = _clientiOptions;
                                });
                              },
                              onEditingComplete: () {
                                if (cController.text == "" && tempCli.isEmpty) {
                                  cController.clear();
                                  clientFocus.unfocus();
                                  _clear("C");
                                  return;
                                }
                                for (var element in clienti) {
                                  if (element.containsValue(cController.text)) {
                                    cController.text = _clientiOptions[
                                        clienti.indexOf(element)];
                                    clientFocus.unfocus();
                                  } else {
                                    if (_clientiOptions
                                        .contains(cController.text)) {
                                      clientFocus.unfocus();
                                    } else {
                                      if (tempCli.isNotEmpty) {
                                        cController.text = tempCli;
                                      } else {
                                        cController.clear();
                                      }
                                      clientFocus.unfocus();
                                      _clear("C");
                                    }
                                  }
                                }
                              },
                              onTap: () => {
                                customerController.clear(),
                                setState(() {
                                  tempCli = cController.text;
                                }),
                                cController.clear(),
                                _clear("C")
                              },
                            );
                          }, onSelected: (String selection) {
                            cController.text = selection;
                            var nomeC = selection.split(" ");
                            for (var c in clienti) {
                              if (c["companyname"] == nomeC[2]) {
                                setState(() {
                                  cliente = c;
                                });
                              }
                            }
                            if (id == 0) {
                              setState(() {
                                id = cliente["customer_id"];
                              });
                            }
                            getResolve(globals.sesid, id,
                                cliente["customer_code"], "C");
                            FocusScope.of(context).unfocus();

                            setState(() {
                              id = 0;
                            });
                            // getProgetti(globals.sesid, id);
                            // getLuoghi(globals.sesid, id);
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
                          child: Autocomplete<String>(optionsBuilder:
                              (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return _luoghiOptions;
                            }
                            return _luoghiOptions.where((String option) {
                              return option.toUpperCase().contains(
                                  textEditingValue.text.toUpperCase());
                            });
                          }, fieldViewBuilder: (BuildContext context,
                              locationController,
                              FocusNode locationFocus,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              enabled: loading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il luogo';
                                }
                                return null;
                              },
                              controller: lController,
                              focusNode: locationFocus,
                              decoration: const InputDecoration(
                                  label: Text('Luogo'),
                                  border: OutlineInputBorder()),
                              onChanged: (text) {
                                // Update suggestions based on user input
                                // Implement the logic to filter and refresh suggestions
                                if (text == "") {
                                  _clear("L");
                                  return;
                                }

                                setState(() {
                                  _luoghiOptions.clear();
                                });

                                for (var element in luoghi) {
                                  if (element["location_code"].contains(text) ||
                                      element["customer_code"].contains(text) ||
                                      element["location_city"].contains(text)) {
                                    _luoghiOptions.add(
                                        element["location_code"] +
                                            " - " +
                                            element["customer_code"] +
                                            " - " +
                                            element["location_city"]);
                                  }
                                }
                                setState(() {
                                  _luoghiOptions = _luoghiOptions;
                                });
                              },
                              onEditingComplete: () {
                                if (lController.text == "" && tempLoc.isEmpty) {
                                  lController.clear();
                                  locationFocus.unfocus();
                                  _clear("L");
                                  return;
                                }

                                for (var element in luoghi) {
                                  if (element.containsValue(lController.text)) {
                                    lController.text =
                                        _luoghiOptions[luoghi.indexOf(element)];
                                    locationFocus.unfocus();
                                  } else {
                                    if (_luoghiOptions
                                        .contains(lController.text)) {
                                      locationFocus.unfocus();
                                    } else {
                                      if (tempLoc.isNotEmpty) {
                                        lController.text = tempLoc;
                                      } else {
                                        lController.clear();
                                      }
                                      locationFocus.unfocus();
                                      _clear("L");
                                    }
                                  }
                                }
                              },
                              onTap: () => {
                                locationController.clear(),
                                setState(() {
                                  tempLoc = lController.text;
                                }),
                                lController.clear(),
                                _clear("L")
                              },
                            );
                          }, onSelected: (String selection) {
                            lController.text = selection;
                            var nomeC = selection.split(" - ");
                            for (var c in luoghi) {
                              if (c["location_code"] == nomeC[0] &&
                                  c["customer_code"] == nomeC[1] &&
                                  c["location_city"] == nomeC[2]) {
                                luogo = c;
                              }
                            }
                            if (id == 0) {
                              setState(() {
                                id = luogo["customer_location_id"];
                              });
                            }
                            if (cliente.isEmpty) {
                              getResolve(globals.sesid, id,
                                  luogo["customer_code"], "L");
                            }
                            indirizzo = luogo["location_fulladdress"];

                            FocusScope.of(context).unfocus();

                            setState(() {
                              id = 0;
                            });
                            // getProgetti(globals.sesid, id);
                            // getLuoghi(globals.sesid, id);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            //color:Colors.white,
                            width: screenWidth,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "INDIRIZZO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    softWrap: true,
                                    "${indirizzo} ",
                                  ),
                                )
                              ],
                            ))),
                    const SizedBox(
                      height: 10,
                    ),
                    cate == "T"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Autocomplete<String>(optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return _progettiOptions;
                                  }
                                  return _progettiOptions
                                      .where((String option) {
                                    return option.toUpperCase().contains(
                                        textEditingValue.text.toUpperCase());
                                  });
                                }, fieldViewBuilder: (BuildContext context,
                                    progettoController,
                                    FocusNode progettoFocus,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    enabled: loading,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Inserisci il progetto';
                                      }
                                      return null;
                                    },
                                    controller: pController,
                                    focusNode: progettoFocus,
                                    decoration: const InputDecoration(
                                        label: Text('Progetto'),
                                        border: OutlineInputBorder()),
                                    onChanged: (text) {
                                      // Update suggestions based on user input
                                      // Implement the logic to filter and refresh suggestions
                                      if (text == "") {
                                        _clear("P");
                                        return;
                                      }

                                      setState(() {
                                        _progettiOptions.clear();
                                      });

                                      for (var element in progetti) {
                                        if (element["project_code"]
                                                .contains(text) ||
                                            element["customer_code"]
                                                .contains(text)) {
                                          _progettiOptions.add(
                                              element["project_code"] +
                                                  " - " +
                                                  element["customer_code"]);
                                        }
                                      }
                                      setState(() {
                                        _progettiOptions = _progettiOptions;
                                      });
                                    },
                                    onEditingComplete: () {
                                      if (pController.text == "" &&
                                          tempPro.isEmpty) {
                                        pController.clear();
                                        progettoFocus.unfocus();
                                        _clear("P");
                                        return;
                                      }

                                      for (var element in progetti) {
                                        if (element
                                            .containsValue(pController.text)) {
                                          pController.text = _progettiOptions[
                                              progetti.indexOf(element)];
                                          progettoFocus.unfocus();
                                        } else {
                                          if (_progettiOptions
                                              .contains(pController.text)) {
                                            progettoFocus.unfocus();
                                          } else {
                                            if (tempPro.isNotEmpty) {
                                              pController.text = tempPro;
                                            } else {
                                              pController.clear();
                                            }
                                            progettoFocus.unfocus();
                                            _clear("P");
                                          }
                                        }
                                      }
                                    },
                                    onTap: () => {
                                      progettoController.clear(),
                                      setState(() {
                                        tempPro = pController.text;
                                      }),
                                      pController.clear(),
                                      _clear("P")
                                    },
                                  );
                                }, onSelected: (String selection) {
                                  pController.text = selection;
                                  var nomeC = selection.split(" - ");
                                  for (var c in progetti) {
                                    if (c["project_code"] == nomeC[0] &&
                                        c["customer_code"] == nomeC[1]) {
                                      progetto = c;
                                    }
                                  }
                                  if (id == 0) {
                                    setState(() {
                                      id = progetto["project_id"];
                                    });
                                  }
                                  if (cliente.isEmpty) {
                                    getResolve(globals.sesid, id,
                                        progetto["project_code"], "P");
                                  }

                                  getActivity(globals.sesid);
                                  FocusScope.of(context).unfocus();

                                  setState(() {
                                    id = 0;
                                  });
                                  // getProgetti(globals.sesid, id);
                                  // getLuoghi(globals.sesid, id);
                                }),
                              ),
                            ],
                          )
                        : const SizedBox(
                            height: 0.01,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Autocomplete<String>(optionsBuilder:
                              (TextEditingValue textEditingValue) {
                            if (textEditingValue.text == '') {
                              return _activityOptions;
                            }
                            return _activityOptions.where((String option) {
                              return option.toUpperCase().contains(
                                  textEditingValue.text.toUpperCase());
                            });
                          }, fieldViewBuilder: (BuildContext context,
                              activityController,
                              FocusNode activityFocus,
                              VoidCallback onFieldSubmitted) {
                            return TextFormField(
                              enabled: loading,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Inserisci il attività';
                                }
                                return null;
                              },
                              controller: aController,
                              focusNode: activityFocus,
                              decoration: InputDecoration(
                                  label: Text(cate == "T"
                                      ? 'Attività'
                                      : 'Tipo attività'),
                                  border: OutlineInputBorder()),
                              onChanged: (text) {
                                // Update suggestions based on user input
                                // Implement the logic to filter and refresh suggestions
                                if (text == "") {
                                  _clear("A");
                                  return;
                                }

                                setState(() {
                                  _activityOptions.clear();
                                });

                                for (var element in activity) {
                                  // c["task_type_code"] == nomeC[0] &&
                                  // c["unity_code"] == nomeC[1]
                                  if (element["task_type_code"]
                                          .contains(text) ||
                                      element["unity_code"].contains(text)) {
                                    _activityOptions.add(
                                        element["task_type_code"] +
                                            " - " +
                                            element["unity_code"]);
                                  }
                                }
                                setState(() {
                                  _activityOptions = _activityOptions;
                                });
                              },
                              onEditingComplete: () {
                                if (aController.text == "" && tempAct.isEmpty) {
                                  aController.clear();
                                  activityFocus.unfocus();
                                  _clear("A");
                                  return;
                                }

                                for (var element in activity) {
                                  if (element.containsValue(aController.text)) {
                                    aController.text = _activityOptions[
                                        activity.indexOf(element)];
                                    activityFocus.unfocus();
                                  } else {
                                    if (_activityOptions
                                        .contains(aController.text)) {
                                      activityFocus.unfocus();
                                    } else {
                                      if (tempAct.isNotEmpty) {
                                        aController.text = tempAct;
                                      } else {
                                        aController.clear();
                                      }
                                      activityFocus.unfocus();
                                      _clear("A");
                                    }
                                  }
                                }
                              },
                              onTap: () => {
                                activityController.clear(),
                                setState(() {
                                  tempAct = aController.text;
                                }),
                                aController.clear(),
                                _clear("A"),
                                if(cliente.isNotEmpty){
                                  getActivity(globals.sesid)
                                }
                                
                              },
                            );
                          }, onSelected: (String selection) {
                            aController.text = selection;
                            var nomeC = selection.split(" - ");
                            for (var c in activity) {
                              if (c["task_type_code"] == nomeC[0] &&
                                  c["unity_code"] == nomeC[1]) {
                                attivita = c;
                                setState(() {
                                  task_type = c["unity_code"];
                                });
                              }
                            }
                            if(cliente.isNotEmpty){
                              getResolve(globals.sesid, attivita["task_type_id"], attivita["task_type_code"], "A");
                            }
                            
                            FocusScope.of(context).unfocus();

                            setState(() {
                              id = 0;
                            });
                            // getProgetti(globals.sesid, id);
                            // getLuoghi(globals.sesid, id);
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
                              enabled: loading,
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
                    cate == "T"
                        ? const Text("")
                        : Row(
                            children: [
                              Expanded(
                                child: RefundButton(
                                    assegnaRimborso: assegnaRimborso),
                              )
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
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
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              insert();
                            } else {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
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
                          },
                          child: Text(
                            'Aggiungi',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
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
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Chiudi',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          ),
                        )
                      ],
                    ),
                  ]),
                ))),
      ),
    );
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
      enabled: loading,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci la quantità';
        }
        return null;
      },
      decoration: const InputDecoration(
          labelText: "Quantità", border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onChanged: (value) {
        widget.task(value != '' ? int.parse(value) : 0);
      }, // Only numbers can be entered
    );
  }
}

////////////////////   REFUND   //////////////////////
class RefundButton extends StatefulWidget {
  const RefundButton({super.key, required this.assegnaRimborso});

  final Function assegnaRimborso;

  @override
  State<RefundButton> createState() => _RefundButtonState();
}

class _RefundButtonState extends State<RefundButton> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<WidgetState> states) {
      if (isChecked) {
        return Theme.of(context).colorScheme.primaryContainer;
      }
      return Theme.of(context).colorScheme.onPrimaryContainer;
    }

    return CheckboxListTile(
      title: Text("Rimborso"),
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      fillColor: WidgetStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        widget.assegnaRimborso(value!);
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
