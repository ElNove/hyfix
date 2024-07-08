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



class Filterbox extends StatefulWidget {
  const Filterbox({super.key});



  @override
  _FilterboxState createState() => _FilterboxState();
}

class _FilterboxState extends State<Filterbox> {

  List<Cliente> clienti=List.empty(growable: true);
  List<DropdownMenuEntry<String>> clienti_option=List.empty(growable: true);
  @override
  void initState() {
    Service().selectRead(sesid: globals.sesid, tipo: "C").then((res){
      
      var body=jsonDecode(res.body);
      var data=body["data"];
      // ignore: avoid_print
      for (var element in data) {
        clienti.add(Cliente(element["customer_id"],element["customer_code"],element["customer_companyname"]));
        clienti_option.add(DropdownMenuEntry(value: "${element["customer_id"]}", label:"${element["customer_id"]}"));
      }
      print(clienti_option);
      
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      initialSelection: 'R',
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: '', label: ''),
                        DropdownMenuEntry(value: 'R', label: 'Rapportino'),
                        DropdownMenuEntry(value: 'E', label: 'Evento'),
                      ],
                      onSelected: (value) {},
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
                      onSelected: (value) {
                        Service().selectRead(
                            sesid: globals.sesid,
                            tipo: "T").then((res)=>{
                              print((res.body))
                            });
                      },
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
                      dropdownMenuEntries: clienti_option,
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
                    GestureDetector(
                      onTap: () {},
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        trailingIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        width: screenWidth / 100 * 40,
                        dropdownMenuEntries: const [],
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
                    GestureDetector(
                      onTap: () {},
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        trailingIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        width: screenWidth / 100 * 40,
                        dropdownMenuEntries: const [],
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
                    GestureDetector(
                      onTap: () {},
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        trailingIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        width: screenWidth / 100 * 40,
                        dropdownMenuEntries: const [],
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
                    GestureDetector(
                      onTap: () {},
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        trailingIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        width: screenWidth / 100 * 40,
                        dropdownMenuEntries: const [],
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
                    GestureDetector(
                      onTap: () {},
                      child: DropdownMenu<String>(
                        inputDecorationTheme: InputDecorationTheme(
                            fillColor: Theme.of(context).colorScheme.tertiary,
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        trailingIcon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        width: screenWidth / 100 * 80,
                        dropdownMenuEntries: const [],
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
    );
  }
}
