import 'package:flutter/material.dart';
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
  const Events({super.key, required this.data, required this.lista});

  final DateTime data;
  final List<Reports> lista;
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: createRow())));
  }

  createRow() {
    double screenHeight = MediaQuery.of(context).size.height;
    var righe = <GestureDetector>[];
    for (var i in widget.lista) {
        var con = new GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogEvent(report: i));
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
                      transform: GradientRotation(math.pi / 8),
                      begin: Alignment(-1.0, -4.0),
                      end: Alignment(1.0, 4.0),
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
                  child: Container(
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
