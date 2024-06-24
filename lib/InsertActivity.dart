import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<int> _hoursOptions = <int>[1, 2, 3, 4, 5, 6, 7, 8];

class InsertActivity extends StatefulWidget {
  const InsertActivity(
      {super.key, required this.addElement, required this.dataAttuale});
  final Function addElement;
  final DateTime dataAttuale;

  @override
  _InsertActivity createState() => _InsertActivity();
}

class _InsertActivity extends State<InsertActivity> {
  static const List<String> _activityOptions = <String>[
    'WORK',
    'SMARTWORKING',
    'TRASFERTA',
  ];
  static const List<String> _clientiOptions = <String>[
    'PAOLO',
    'GIORGIO',
    'SANDRO',
  ];
  static const List<String> _locationOptions = <String>[
    'SEDE',
  ];
  static const List<String> _progettoOptions = <String>[
    'PRIMO',
    'SECONDO',
  ];
  String attivita = "";
  String luogo = "";
  String cliente = "";
  String progetto = "";
  String tipo = "";
  String note = "";
  int ore = 0;

  @override
  void initState() {
    // verityFirstRun();
    if (widget.dataAttuale.isAfter(DateTime.now())) {
      tipo = "E";
    } else {
      tipo = "A";
    }
    super.initState();
  }

  void assegnaOre(int o) {
    ore = o;
  }

  void aggiornaTipo(String t) {
    tipo = t;
  }

  void controllo() {
    if (attivita == "" || tipo == "" || ore == 0) {
    } else {
      if (attivita.toUpperCase() != "WORK" &&
          attivita.toUpperCase() != "SMARTWORKING" &&
          attivita.toUpperCase() != "TRASFERTA") {
      } else {
        widget.addElement(cliente, luogo, progetto, attivita.toUpperCase(),
            ore.toString(), widget.dataAttuale, note, tipo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 3,
                        ),
                        backgroundColor: tipo == "A"
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          tipo = "A";
                        });
                      },
                      child: Text(
                        'Attività',
                        style: TextStyle(
                            color: tipo == "A"
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null),
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
                          color: Theme.of(context).colorScheme.primaryContainer,
                          width: 3,
                        ),
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
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : null),
                      ),
                    ))
              ],
            ),
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
                        cliente = text;
                      },
                      onSubmitted: (text) {
                        // Handle the submission of the selected suggestion
                        // Implement the logic for the selection action
                      },
                    );
                  }, onSelected: (String selection) {
                    cliente = selection;
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
                      optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return _progettoOptions;
                    }
                    return _progettoOptions.where((String option) {
                      return option
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
                          label: Text('Progetto'),
                          border: OutlineInputBorder()),
                      onChanged: (text) {
                        // Update suggestions based on user input
                        // Implement the logic to filter and refresh suggestions
                        progetto = text;
                      },
                      onSubmitted: (text) {
                        // Handle the submission of the selected suggestion
                        // Implement the logic for the selection action
                      },
                    );
                  }, onSelected: (String selection) {
                    progetto = selection;
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
                      attivita = text;
                    },
                    onSubmitted: (text) {
                      // Handle the submission of the selected suggestion
                      // Implement the logic for the selection action
                    },
                  );
                }, onSelected: (String selection) {
                  attivita = selection;
                })),
                const SizedBox(
                  width: 10,
                ),
                Ore(
                  ore: assegnaOre,
                )
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
                    return _locationOptions;
                  }
                  return _locationOptions.where((String option) {
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
                      luogo = text;
                    },
                    onSubmitted: (text) {
                      // Handle the submission of the selected suggestion
                      // Implement the logic for the selection action
                      luogo = text;
                    },
                  );
                }, onSelected: (String selection) {
                  luogo = selection;
                })),
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
                    controllo();

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Aggiungi',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

////////////////     ORE     ///////////////////////

class Ore extends StatefulWidget {
  const Ore({super.key, required this.ore});
  final Function ore;

  @override
  State<Ore> createState() => _OreState();
}

class _OreState extends State<Ore> {
  int dropdownValue = _hoursOptions.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: const Text("Ore"),
      initialSelection: 0,
      onSelected: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
        widget.ore(dropdownValue);
      },
      dropdownMenuEntries:
          _hoursOptions.map<DropdownMenuEntry<int>>((int value) {
        return DropdownMenuEntry<int>(
          value: value,
          label: '$value',
        );
      }).toList(),
    );
  }
}

////////////////////   TIPO   //////////////////////
