import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class TableBasic extends StatefulWidget {
  const TableBasic(
      {super.key,
      required this.lista,
      required this.onDaySelected,
      required this.calendarFormat,
      required this.updateFormat,
      required this.visible});
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
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      locale: 'it_IT',
      availableCalendarFormats: const {
        CalendarFormat.month: 'Mese',
        CalendarFormat.twoWeeks: '2 Settimane',
        CalendarFormat.week: 'Settimana',
      },
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: widget.calendarFormat,
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle),
      ),
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
        for (var i = 0; i < widget.lista.length; i++) {
          if (isSameDay(day, widget.lista[i].data)) {
            return [widget.lista[i]];
          }
        }
        return [];
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}