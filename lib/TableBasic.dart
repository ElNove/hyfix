import 'package:flutter/material.dart';
import 'package:hyfix/Home.dart';
import 'package:hyfix/WeeksDay.dart';
import 'package:hyfix/models/Reports.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TableBasic extends StatefulWidget {
  const TableBasic(
      {super.key,
      required this.context,
      required this.update,
      required this.lista,
      required this.onDaySelected,
      required this.calendarFormat,
      required this.fetchCalendar,
      required this.updateFormat,
      required this.visible});
  final Function(DateTime) onDaySelected;
  final Function(CalendarFormat) updateFormat;
  final CalendarFormat calendarFormat;
  final bool visible;
  final BuildContext context;
  final Function fetchCalendar;
  final List<Reports> lista;
  final Function update;

  @override
  _TableBasicState createState() => _TableBasicState();
}

class _TableBasicState extends State<TableBasic> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime selezionato = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var dataFetch = widget.context.watch<DataFetch>();

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
        headerPadding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        leftChevronIcon: Icon(Icons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onSurface),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        weekendStyle: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      daysOfWeekHeight: 20,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle),
      ),
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
          if (isSameDay(day, widget.lista[i].reportDate)) {
            return [widget.lista[i]];
          }
        }
        return [];
      },
      onFormatChanged: (format) {
        setState(() {
          widget.updateFormat(format);
        });
      },
      onPageChanged: (focusedDay) {
        switch (widget.calendarFormat) {
          case CalendarFormat.month:
            if (_selectedDay?.month == focusedDay.month &&
                _selectedDay?.year == focusedDay.year) {
              _focusedDay = _selectedDay ?? focusedDay;
            } else {
              _focusedDay = focusedDay;
            }
            break;
          default:
            _focusedDay = focusedDay;
            break;
        }

        widget.update(_focusedDay);
        List<List<DateTime>> weeks = getWeeksOfMonth(_focusedDay);

        dataFetch.first = weeks.first.first;
        dataFetch.last = weeks.last.last;

        widget.fetchCalendar(
            context: context,
            first: dataFetch.first,
            last: dataFetch.last,
            type: dataFetch.type,
            customer: dataFetch.getId(dataFetch.customer),
            location: dataFetch.getId(dataFetch.location),
            project: dataFetch.getId(dataFetch.project),
            projectTask: dataFetch.getId(dataFetch.projectTask),
            taskType: dataFetch.getId(dataFetch.taskType),
            user: dataFetch.getId(dataFetch.user));
      },
    );
  }
}
