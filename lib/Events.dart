import 'package:diagonal_decoration/diagonal_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hyfix/DialogEvent.dart';
import 'package:hyfix/models/Reports.dart';

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
    var righe = <GestureDetector>[];
    for (var i in widget.lista) {
      if (DateUtils.isSameDay(i.reportDate, widget.data)) {
        var con = new GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogEvent(report: i));
          },
          child: Container(
            padding: EdgeInsets.all(12),
            margin: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            height: 50,
            decoration: i.reportType == "R"
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: HexColor.fromHex(i.color),
                  )
                : DiagonalDecoration(
                    radius: Radius.circular(8),
                    lineColor: darken(HexColor.fromHex(i.color), .1),
                    lineWidth: 8,
                    backgroundColor: HexColor.fromHex(i.color),
                    distanceBetweenLines: 140,
                  ),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      i.reportType == "R" ? Icons.assignment : Icons.bookmark,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    "[  ${int.parse(i.quantity).toStringAsFixed(2)} ${i.unityCode}  ]",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  "${i.customerCode} - ${i.taskTypeCode}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
        righe.add(con);
      }
    }
    return righe.reversed.toList();
  }
}
