import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class TableBasic extends StatefulWidget {
  const TableBasic(
      {super.key,
      required this.onDaySelected,
      required this.calendarFormat,
      required this.updateFormat,
      required this.visible,
      required this.lista
      });
  final Function(DateTime) onDaySelected;
  final Function(CalendarFormat) updateFormat;
  final CalendarFormat calendarFormat;
  final bool visible;
  final List lista;

  @override
  _TableBasicState createState() => _TableBasicState();
}

class _TableBasicState extends State<TableBasic> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime selezionato = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TableCalendar(
         locale: 'it_IT',
         availableCalendarFormats:const {
  CalendarFormat.month : 'Mese',
  CalendarFormat.twoWeeks:'2 Settimane',
  CalendarFormat.week:'Settimana'
},
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: widget.calendarFormat,
          calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 97, 205, 255),
                  shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Color.fromARGB(255, 188, 234, 255),shape: BoxShape.circle)),
          onFormatChanged: (format) {
            setState(() {
              widget.updateFormat(format);
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              widget.onDaySelected(selectedDay);
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              selezionato = selectedDay;
            });
          },
          eventLoader: (day) {
            for (var i = 0; i <widget.lista.length; i++) {
              if (isSameDay(day,widget.lista[i].data)) {
                return [widget.lista[i]];
              }
            }
            return [];
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ));
  }
}
