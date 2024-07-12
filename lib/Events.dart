import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hyfix/DialogEvent.dart';
import 'package:hyfix/models/Reports.dart';

import 'dart:math' as math;

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class Events extends StatefulWidget {
  const Events({super.key, required this.data, required this.lista,required this.action,required this.fetchRep,required this.update});

  final DateTime data;
  final List<Reports> lista;
  final Function action;
  final Function update;
  final Function fetchRep;
  
      
  @override
  _EventsState createState() => _EventsState();
}

void delete(context, report) {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Sei sicuro di voler eliminare questo evento?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Si'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // child: Column(children: createRow()),
        child: ListView.builder(
          itemCount: widget.lista.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Stack(children: [
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ],
                ),
              ),
              Slidable(
                key: UniqueKey(),
                endActionPane: ActionPane(
                    extentRatio: 0.2,
                    motion: const BehindMotion(),
                    children: [
                      GestureDetector(
                        onTap: () {
                          delete(context, widget.lista[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.only(left: 30),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(15)),
                            color: Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.delete_forever,
                              color: Colors.white),
                        ),
                      ),
                    ]),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DialogEvent(report: widget.lista[index]));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 6),
                    // margin: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1),
                      color: HexColor.fromHex(widget.lista[index].color),
                    ),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.lista[index].reportType == "R"
                                  ? Icons.assignment
                                  : Icons.bookmark,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "[  ${int.parse(widget.lista[index].quantity).toStringAsFixed(2)} ${widget.lista[index].unityCode}  ]",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            "${widget.lista[index].customerCode} - ${widget.lista[index].taskTypeCode}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }

  createRow() {
    double screenHeight = MediaQuery.of(context).size.height;
    var righe = <GestureDetector>[];
    for (var i in widget.lista) {
      var con = GestureDetector(
        onTap: () {
          /*showDialog(
              context: context,
              builder: (BuildContext context) => DialogEvent(report: i));*/
              print("VIA");
               Navigator.of(context)
                                  .push(widget.action(fetchRep: widget.fetchRep,data: widget.data,update: widget.update,action: "mod_el", report: i))
              ;
        },
        child: Container(
          padding: EdgeInsets.all(screenHeight / 100),
          margin: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          height: screenHeight / 100 * 5,
          decoration: i.reportType == "R"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1),
                  color: HexColor.fromHex(i.color),
                )
              : BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    transform: const GradientRotation(math.pi / 8),
                    begin: const Alignment(-1.0, -4.0),
                    end: const Alignment(1.0, 4.0),
                    colors: List.generate(26, (index) {
                      if (index % 4 == 0 || index % 4 == 1) {
                        return HexColor.fromHex(i.color);
                      } else {
                        return darken(HexColor.fromHex(i.color), .1);
                      }
                    }),
                    stops: () {
                      final List<double> stops = [];
                      double i = 0;
                      double increment = 0.08;
                      while (i < 1) {
                        stops.add(i);
                        i += increment;
                        if (i >= 1) {
                          stops.add(1);
                          break;
                        }
                        stops.add(i);
                      }
                      return stops;
                    }(),
                  ),
                ),
          child: Row(
            children: [
              Row(
                children: [
                  Icon(
                    i.reportType == "R" ? Icons.assignment : Icons.bookmark,
                    color: Colors.white,
                    size: screenHeight / 100 * 2.5,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Center(
                child: Text(
                  "[  ${int.parse(i.quantity).toStringAsFixed(2)} ${i.unityCode}  ]",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight / 100 * 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  "${i.customerCode} - ${i.taskTypeCode}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight / 100 * 2,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
      righe.add(con);
    }
    return righe.reversed.toList();
  }
}
