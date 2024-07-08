import 'package:flutter/material.dart';

class Filterbox extends StatefulWidget {
  const Filterbox({super.key});

  @override
  _FilterboxState createState() => _FilterboxState();
}

class _FilterboxState extends State<Filterbox> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      height: MediaQuery.of(context).size.height / 100 * 60,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
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
                      fontSize: MediaQuery.of(context).size.height / 100 * 2.5,
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
          const SizedBox(
            height: 20,
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    initialSelection: 'R',
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: '', label: ''),
                      DropdownMenuEntry(value: 'R', label: 'Rapportino'),
                      DropdownMenuEntry(value: 'E', label: 'Evento'),
                    ],
                  ),
                ],
              ),
              Column(
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    dropdownMenuEntries: const [],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    width: screenWidth / 100 * 40,
                    dropdownMenuEntries: const [],
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    width: screenWidth / 100 * 40,
                    dropdownMenuEntries: const [],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    width: screenWidth / 100 * 40,
                    dropdownMenuEntries: const [],
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    width: screenWidth / 100 * 40,
                    dropdownMenuEntries: const [],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
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
                    trailingIcon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    width: screenWidth / 100 * 80,
                    dropdownMenuEntries: const [],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
