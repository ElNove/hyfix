import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'Login.dart' as globals;
import './models/ReportSave.dart';
import './services/Service.dart';

var loading = false;

class InsertActivity extends StatefulWidget {
  const InsertActivity(
      {super.key,
      required this.fetchCalendar,
      required this.dataAttuale,
      required this.update});
  final Function fetchCalendar;
  final DateTime dataAttuale;
  final Function update;

  @override
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
  late Map<String, dynamic> attivita = {};
  var id = 0;
  bool rimborso = false;
  String tipo = "";
  String note = "";
  String cate = "T";
  int task = 0;
  String task_type = "";
  dynamic project_task_id = 0;
  var indirizzo = "";
  var tempCli = "";
  var tempLoc = "";
  var tempPro = "";
  var tempAct = "";

  void setProgetti(Response response) {
    setState(() {
      _clear("P");
      progetti.clear();
    });
    _progettiOptions.clear();

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      progetti.add(elem);
      _progettiOptions.add(elem["code"] + " - " + elem["customer_code"]);
    }
    setState(() {
      progetti = progetti;
      _progettiOptions = _progettiOptions;
    });
  }

  void setActivity(Response response) {
    _clear("A");
    setState(() {
      loading = false;
      activity.clear();
      _activityOptions.clear();
    });

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      activity.add(elem);
      _activityOptions.add(elem["task_type_code"] + " - " + elem["unity_code"]);
    }
    setState(() {
      _activityOptions = _activityOptions;
      loading = true;
    });
  }

  void setLuoghi(Response response) {
    _clear("L");
    luoghi = [];
    _luoghiOptions.clear();

    var deco = jsonDecode(response.body);
    for (var elem in deco["data"]) {
      if (luogo.isEmpty) {
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

  @override
  void initState() {
    setState(() {
      loading = false;
    });
    if (widget.dataAttuale.isAfter(DateTime.now())) {
      tipo = "E";
    } else {
      tipo = "R";
    }

    Service().getUtente(globals.sesid).then((response) {
      var deco = jsonDecode(response.body);
      for (var elem in deco["data"]) {
        if (elem["username"] == globals.username) {
          setState(() {
            utente = elem;
          });
        }
      }
    });

    Service().getClienti(globals.sesid, id).then((response) {
      clienti = [];
      _clientiOptions = [];

      var deco = jsonDecode(response.body);
      for (var elem in deco["data"]) {
        clienti.add(elem);
        _clientiOptions.add(elem["code"] + " - " + elem["companyname"]);
      }
    });

    Service().getProgetti(globals.sesid, id, cliente).then((response) {
      setProgetti(response);
    });

    Service().getLuoghi(globals.sesid, id).then((response) {
      setLuoghi(response);
    });

    setState(() {
      loading = true;
    });

    super.initState();
  }

  void getResolve(sesid, id, code, tipo) async {
    Map<String, Object> params = {};

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
          'fieldsNames[]': ['task_type_id', 'task_type_code', 'unity_code'],
        };
        break;
    }

    Service().getResolve(sesid, params).then((response) async {
      var deco = jsonDecode(response.body);
      var data = deco["data"];
      project_task_id = data["project_task_id"];
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
            progetto.clear();
            progetti.clear();
            activity.clear();
            _activityOptions.clear();
          });

          if (cate != "T") {
            Service()
                .getActivity(sesid: globals.sesid, cate: cate, defaultPr: "Y")
                .then((response) {
              setActivity(response);
            });
          }

          Service()
              .getLuoghi(globals.sesid, cliente["customer_id"])
              .then((res) {
            setLuoghi(res);
            Service()
                .getProgetti(globals.sesid, cliente["customer_id"], cliente)
                .then((res) {
              setProgetti(res);
              setState(() {
                loading = true;
              });
            });
          });

          break;
        case "L":
          Service().getClienti(sesid, data["customer_id"]).then((resp) {
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            var cli2 = (data["customer_code"] + " - " + d[0]["companyname"]);
            setState(() {
              cliente = d[0];
              cController.text = cli2;
              aController.clear();
            });

            Service()
                .getLuoghi(globals.sesid, cliente["customer_id"])
                .then((res) {
              setLuoghi(res);
              Service()
                  .getProgetti(globals.sesid, cliente["customer_id"], cliente)
                  .then((res) {
                setProgetti(res);
                setState(() {
                  loading = true;
                });
              });
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

          Service().getClienti(sesid, data["customer_id"]).then((resp) {
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            var cli2 = (data["customer_code"] + " - " + d[0]["companyname"]);
            setState(() {
              cliente = d[0];
              cController.text = cli2;
            });

            _clear("A");
            Service()
                .getActivity(
                    sesid: globals.sesid,
                    cate: cate,
                    pr_id: progetto["project_id"],
                    cu_id: cliente["customer_id"],
                    defaultPr: progetto["default_project"])
                .then((response) {
              setActivity(response);
            });

            Service()
                .getLuoghi(globals.sesid, cliente["customer_id"])
                .then((res) {
              setLuoghi(res);
              Service()
                  .getProgetti(globals.sesid, cliente["customer_id"], cliente)
                  .then((res) {
                setProgetti(res);
                setState(() {
                  loading = true;
                });
              });
            });
          });
          break;
        case "A":
          Service()
              .getProgetti(sesid, cliente["customer_id"], cliente)
              .then((resp) {
            setProgetti(resp);
            var deco2 = jsonDecode(resp.body);
            var d = deco2["data"];
            setState(() {
              progetto = d[0];
            });

            Service()
                .getLuoghi(globals.sesid, cliente["customer_id"])
                .then((res) {
              setLuoghi(res);
              setState(() {
                loading = true;
              });
            });
          });
          break;
      }
    });
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
      projectTaskId: project_task_id,
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

    Service().saveReport(globals.sesid, ReportSaveToJson(rep)).then((report) {
      if (report.body.contains('"success":false')) {
        showTopSnackBar(
          Overlay.of(context),
          dismissType: DismissType.onSwipe,
          const CustomSnackBar.error(
            message: "Inserimento non riuscito",
          ),
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          dismissType: DismissType.onSwipe,
          const CustomSnackBar.success(
            message: "Inserimento avvenuto con successo",
          ),
        );
        DateTime focusedDay = DateTime.now();

        List<List<DateTime>> weeks = getWeeksOfMonth(focusedDay);

        widget.update();
        widget.fetchCalendar(
            first: weeks.first.first, last: weeks.last.last, type: 'R');
        Navigator.pop(context);
      }
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
          _progettiOptions.add(
              "${element["project_code"]}  -  ${element["customer_code"]}");
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
                                        activity.clear();

                                        _clear("P");
                                        pController.clear();
                                        aController.clear();
                                        progetto = {};
                                        FocusScope.of(context).unfocus();
                                        task_type = "";
                                      });
                                      Service()
                                          .getProgetti(globals.sesid,
                                              cliente["customer_id"], cliente)
                                          .then((res) {
                                        setProgetti(res);
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
                                        progetto.clear();
                                        pController.clear();
                                        aController.clear();
                                        FocusScope.of(context).unfocus();
                                        task_type = "";
                                      });
                                      Service()
                                          .getActivity(
                                              sesid: globals.sesid,
                                              cate: cate,
                                              defaultPr:
                                                  progetto["default_project"] ??
                                                      "Y")
                                          .then((response) {
                                        setActivity(response);
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

                                        progetto.clear();
                                        _clear("P");
                                        pController.clear();
                                        aController.clear();
                                        FocusScope.of(context).unfocus();
                                        task_type = "";
                                      });
                                      Service()
                                          .getActivity(
                                              sesid: globals.sesid,
                                              cate: cate,
                                              defaultPr:
                                                  progetto["default_project"] ??
                                                      "Y")
                                          .then((response) {
                                        setActivity(response);
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
                        : const Text(""),
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
                          child: LayoutBuilder(
                            builder: (context, constraints) =>
                                RawAutocomplete<String>(
                              optionsViewBuilder:
                                  (context, onSelected, options) => Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(4.0)),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        border: Border(
                                          left: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                          bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                          right: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                        )),
                                    height: 65.0 * options.length,
                                    width: constraints
                                        .biggest.width, // <-- Right here !
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      shrinkWrap: false,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String option =
                                            options.elementAt(index);
                                        return InkWell(
                                          onTap: () => onSelected(option),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return _clientiOptions;
                                }
                                return _clientiOptions.where((String option) {
                                  return option.toUpperCase().contains(
                                      textEditingValue.text.toUpperCase());
                                });
                              },
                              fieldViewBuilder: (BuildContext context,
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
                                      suffixIcon: Icon(Icons.arrow_drop_down),
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
                                    for (var element in clienti) {
                                      if (element["companyname"]
                                              .contains(text) ||
                                          element["code"].contains(text)) {
                                        _clientiOptions.add(element["code"] +
                                            " - " +
                                            element["companyname"]);
                                      }
                                    }
                                    setState(() {
                                      _clientiOptions = _clientiOptions;
                                    });
                                  },
                                  onEditingComplete: () {
                                    if (cController.text == "" &&
                                        tempCli.isEmpty) {
                                      cController.clear();
                                      clientFocus.unfocus();
                                      _clear("C");
                                      return;
                                    }
                                    for (var element in clienti) {
                                      if (element
                                          .containsValue(cController.text)) {
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
                                    if (clientFocus.hasFocus)
                                      {
                                        cController.text = tempCli,
                                        clientFocus.unfocus()
                                      }
                                    else
                                      {
                                        customerController.clear(),
                                        setState(() {
                                          tempCli = cController.text;
                                        }),
                                        cController.clear(),
                                        _clear("C"),
                                      }
                                  },
                                );
                              },
                              onSelected: (String selection) {
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
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) => RawAutocomplete<
                                    String>(
                                optionsViewBuilder: (context, onSelected,
                                        options) =>
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(4.0)),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(8),
                                                bottomRight: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              border: Border(
                                                left: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline),
                                                bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline),
                                                right: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline),
                                              )),
                                          height: 65.0 * options.length,
                                          width: constraints.biggest
                                              .width, // <-- Right here !
                                          child: ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemCount: options.length,
                                            shrinkWrap: false,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final String option =
                                                  options.elementAt(index);
                                              return InkWell(
                                                onTap: () => onSelected(option),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Text(
                                                    option,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimaryContainer),
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const Divider();
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return _luoghiOptions;
                                  }
                                  return _luoghiOptions.where((String option) {
                                    return option.toUpperCase().contains(
                                        textEditingValue.text.toUpperCase());
                                  });
                                },
                                fieldViewBuilder: (BuildContext context,
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
                                        suffixIcon: Icon(Icons.arrow_drop_down),
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
                                        if (element["location_code"]
                                                .contains(text) ||
                                            element["customer_code"]
                                                .contains(text) ||
                                            element["location_city"]
                                                .contains(text)) {
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
                                      if (lController.text == "" &&
                                          tempLoc.isEmpty) {
                                        lController.clear();
                                        locationFocus.unfocus();
                                        _clear("L");
                                        return;
                                      }

                                      for (var element in luoghi) {
                                        if (element
                                            .containsValue(lController.text)) {
                                          lController.text = _luoghiOptions[
                                              luoghi.indexOf(element)];
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
                                      if (locationFocus.hasFocus)
                                        {
                                          lController.text = tempLoc,
                                          locationFocus.unfocus()
                                        }
                                      else
                                        {
                                          locationController.clear(),
                                          setState(() {
                                            tempLoc = lController.text;
                                          }),
                                          lController.clear(),
                                          _clear("L"),
                                        }
                                    },
                                  );
                                },
                                onSelected: (String selection) {
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
                                }),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            width: screenWidth,
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              children: [
                                const Text(
                                  "INDIRIZZO: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    softWrap: true,
                                    "$indirizzo ",
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
                                child: LayoutBuilder(
                                  builder: (context, constraints) =>
                                      RawAutocomplete<String>(
                                          optionsViewBuilder: (context,
                                                  onSelected, options) =>
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Material(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    4.0)),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  8),
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          topRight:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                        border: Border(
                                                          left: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .outline),
                                                          bottom: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .outline),
                                                          right: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .outline),
                                                        )),
                                                    height:
                                                        65.0 * options.length,
                                                    width: constraints.biggest
                                                        .width, // <-- Right here !
                                                    child: ListView.separated(
                                                      physics:
                                                          const AlwaysScrollableScrollPhysics(),
                                                      padding: EdgeInsets.zero,
                                                      itemCount: options.length,
                                                      shrinkWrap: false,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final String option =
                                                            options.elementAt(
                                                                index);
                                                        return InkWell(
                                                          onTap: () =>
                                                              onSelected(
                                                                  option),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Text(
                                                              option,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onPrimaryContainer),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return const Divider();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return _progettiOptions;
                                            }
                                            return _progettiOptions
                                                .where((String option) {
                                              return option
                                                  .toUpperCase()
                                                  .contains(textEditingValue
                                                      .text
                                                      .toUpperCase());
                                            });
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              progettoController,
                                              FocusNode progettoFocus,
                                              VoidCallback onFieldSubmitted) {
                                            return TextFormField(
                                              enabled: loading,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Inserisci il progetto';
                                                }
                                                return null;
                                              },
                                              controller: pController,
                                              focusNode: progettoFocus,
                                              decoration: const InputDecoration(
                                                  suffixIcon: Icon(
                                                      Icons.arrow_drop_down),
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
                                                    _progettiOptions.add(element[
                                                            "project_code"] +
                                                        " - " +
                                                        element[
                                                            "customer_code"]);
                                                  }
                                                }
                                                setState(() {
                                                  _progettiOptions =
                                                      _progettiOptions;
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
                                                  if (element.containsValue(
                                                      pController.text)) {
                                                    pController.text =
                                                        _progettiOptions[
                                                            progetti.indexOf(
                                                                element)];
                                                    progettoFocus.unfocus();
                                                  } else {
                                                    if (_progettiOptions
                                                        .contains(
                                                            pController.text)) {
                                                      progettoFocus.unfocus();
                                                    } else {
                                                      if (tempPro.isNotEmpty) {
                                                        pController.text =
                                                            tempPro;
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
                                                if (progettoFocus.hasFocus)
                                                  {
                                                    pController.text = tempPro,
                                                    progettoFocus.unfocus()
                                                  }
                                                else
                                                  {
                                                    progettoController.clear(),
                                                    setState(() {
                                                      tempPro =
                                                          pController.text;
                                                    }),
                                                    pController.clear(),
                                                    _clear("P"),
                                                  }
                                              },
                                            );
                                          },
                                          onSelected: (String selection) {
                                            pController.text = selection;
                                            var nomeC = selection.split(" - ");
                                            setState(() {
                                              progetto = {};
                                            });
                                            for (var c in progetti) {
                                              if (c["project_code"]
                                                          .toString()
                                                          .trim() ==
                                                      nomeC[0]
                                                          .toString()
                                                          .trim() &&
                                                  c["customer_code"]
                                                          .toString()
                                                          .trim() ==
                                                      nomeC[1]
                                                          .toString()
                                                          .trim()) {
                                                setState(() {
                                                  progetto = c;
                                                });
                                                break;
                                              }
                                            }

                                            if (id == 0) {
                                              setState(() {
                                                id = progetto["project_id"];
                                              });
                                            }

                                            if (cliente.isEmpty) {
                                              getResolve(
                                                  globals.sesid,
                                                  id,
                                                  progetto["project_code"],
                                                  "P");
                                            } else {
                                              pController.text = (progetto[
                                                      "project_code"] +
                                                  " - " +
                                                  progetto["customer_code"]);

                                              _clear("A");
                                              Service()
                                                  .getActivity(
                                                      sesid: globals.sesid,
                                                      cate: cate,
                                                      pr_id: progetto[
                                                          "project_id"],
                                                      cu_id: cliente[
                                                          "customer_id"],
                                                      defaultPr: progetto[
                                                          "default_project"])
                                                  .then((response) {
                                                setActivity(response);
                                              });
                                            }
                                            FocusScope.of(context).unfocus();

                                            setState(() {
                                              id = 0;
                                            });
                                          }),
                                ),
                              )
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
                            child: LayoutBuilder(
                          builder: (context, constraints) => RawAutocomplete<
                                  String>(
                              optionsViewBuilder: (context, onSelected,
                                      options) =>
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(4.0)),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            border: Border(
                                              left: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline),
                                              bottom: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline),
                                              right: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline),
                                            )),
                                        height: 65.0 * options.length,
                                        width: constraints
                                            .biggest.width, // <-- Right here !
                                        child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount: options.length,
                                          shrinkWrap: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final String option =
                                                options.elementAt(index);
                                            return InkWell(
                                              onTap: () => onSelected(option),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimaryContainer),
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return _activityOptions;
                                }

                                return _activityOptions.where((String option) {
                                  return option.toUpperCase().contains(
                                      textEditingValue.text.toUpperCase());
                                });
                              },
                              fieldViewBuilder: (BuildContext context,
                                  activityController,
                                  FocusNode activityFocus,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  enabled: loading,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Inserisci l\'attività';
                                    }
                                    return null;
                                  },
                                  controller: aController,
                                  focusNode: activityFocus,
                                  decoration: InputDecoration(
                                      suffixIcon:
                                          const Icon(Icons.arrow_drop_down),
                                      label: Text(cate == "T" &&
                                              progetto["code"] != "N/A"
                                          ? 'Attività'
                                          : 'Tipo attività'),
                                      border: const OutlineInputBorder()),
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
                                      if (element["task_type_code"]
                                              .contains(text) ||
                                          element["unity_code"]
                                              .contains(text)) {
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
                                    if (aController.text == "" &&
                                        tempAct.isEmpty) {
                                      aController.clear();
                                      activityFocus.unfocus();
                                      _clear("A");
                                      return;
                                    }

                                    for (var element in activity) {
                                      if (element
                                          .containsValue(aController.text)) {
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
                                    if (progetto.isEmpty)
                                      {
                                        _activityOptions.clear(),
                                      },
                                    if (activityFocus.hasFocus)
                                      {
                                        aController.text = tempAct,
                                        activityFocus.unfocus()
                                      }
                                    else
                                      {
                                        _clear("A"),
                                        activityController.clear(),
                                        setState(() {
                                          tempAct = aController.text;
                                          _activityOptions = _activityOptions;
                                        }),
                                        aController.clear(),
                                        _clear("A"),
                                      }
                                  },
                                );
                              },
                              onSelected: (String selection) {
                                aController.text = selection;
                                var nomeC = selection.split(" - ");
                                for (var c in activity) {
                                  if (c["task_type_code"] == nomeC[0] &&
                                      c["unity_code"] == nomeC[1]) {
                                    setState(() {
                                      attivita = c;
                                      task_type = c["unity_code"];
                                    });
                                  }
                                }
                                if (progetto.isEmpty) {
                                  getResolve(
                                      globals.sesid,
                                      attivita["task_type_id"],
                                      attivita["task_type_code"],
                                      "A");
                                } else {
                                  Service()
                                      .getActivity(
                                          sesid: globals.sesid,
                                          cate: cate,
                                          pr_id: progetto["project_id"],
                                          cu_id: cliente["customer_id"],
                                          defaultPr:
                                              progetto["default_project"])
                                      .then((response) {
                                    setActivity(response);
                                    var deco = jsonDecode(response.body);
                                    var data = deco["data"];
                                    if (data[0]["project_task_id"] != null) {
                                      project_task_id =
                                          data[0]["project_task_id"];
                                    } else {
                                      project_task_id = 0;
                                    }
                                  });
                                }

                                FocusScope.of(context).unfocus();
                              }),
                        )),
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
      title: const Text("Rimborso"),
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
