List<List<DateTime>> getWeeksOfMonth(DateTime date) {
  List<List<DateTime>> weeks = [];

  // Get the first and last day of the month
  DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
  DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

  // Determine the start and end date to include days from previous and next months
  int firstWeekday = firstDayOfMonth.weekday;
  int lastWeekday = lastDayOfMonth.weekday;

  // Calculate the start and end dates to include full weeks
  DateTime startDay =
      firstDayOfMonth.subtract(Duration(days: firstWeekday - 1));
  DateTime endDay = lastDayOfMonth.add(Duration(days: 7 - lastWeekday));

  // Iterate through each day from startDay to endDay
  DateTime currentDay = startDay;
  List<DateTime> week = [];

  while (currentDay.isBefore(endDay) || currentDay.isAtSameMomentAs(endDay)) {
    week.add(currentDay);
    if (week.length == 7) {
      weeks.add(week);
      week = [];
    }
    currentDay = currentDay.add(const Duration(days: 1));
    if (currentDay.hour == 1) {
      currentDay = DateTime(currentDay.year, currentDay.month, currentDay.day);
    } else if (currentDay.hour == 23) {
      currentDay =
          DateTime(currentDay.year, currentDay.month, currentDay.day + 1);
    }
  }

  if (week.isNotEmpty) {
    weeks.add(week);
  }

  return weeks;
}
