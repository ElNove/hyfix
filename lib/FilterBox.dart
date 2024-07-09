import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:hyfix/Home.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:provider/provider.dart';

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
