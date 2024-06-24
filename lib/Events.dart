import 'package:diagonal_decoration/diagonal_decoration.dart';
import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key, required this.lista, required this.data});

  final List lista;
  final DateTime data;
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {

  createRow() {
    var righe = <GestureDetector>[];
    widget.lista.forEach((i) {
      if (DateUtils.isSameDay(i.data, widget.data)) {
        print(i.attivita);
        var con = new GestureDetector(
          onTap: () {
            print("ciao " + i.attivita);
          },
          child: Container(
            padding: EdgeInsets.all(12),
              margin: const EdgeInsets.fromLTRB(5, 3, 5, 3),
              height: 50,
              decoration: i.tipo=="A"?BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: i.attivita == 'TRASFERTA' ? Colors.red :  i.attivita == 'WORK'?Colors.green:Colors.blue,
              ):DiagonalDecoration(
                radius: Radius.circular(8),
                lineColor: i.attivita == 'TRASFERTA' ? Colors.red :  i.attivita == 'WORK'?Colors.green:Colors.blue,
                lineWidth: 9,
                backgroundColor:i.attivita == 'TRASFERTA' ? const Color.fromARGB(255, 255, 95, 83) :  i.attivita == 'WORK'?const Color.fromARGB(255, 113, 255, 118):const Color.fromARGB(255, 94, 182, 255) ,
                distanceBetweenLines: 150,
              ),
                child: 
                    Row(
                      children: [
                        Center(
                            child:Text(i.ore+" h",
                            style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold))
                          ),
                        const SizedBox(
                          width: 50,  
                        ),
                        Text(
                          i.attivita,
                          style: const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
              ),
        );
        righe.add(con);
      }
    });
    return righe;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 5,bottom: 5), 
        child:SingleChildScrollView(
                scrollDirection: Axis.vertical,
        child: Column(

          children: createRow()
        ))
      );
  }
}
