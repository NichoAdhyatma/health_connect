import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/controller/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends GetView<CalendarController> {
  const CalendarWidget({
    super.key,
    this.onDayChange,
  });

  final void Function(DateTime dateChange)? onDayChange;

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());

    return Obx(() {
      return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: controller.selectedDate.value,
        selectedDayPredicate: (selectedDay) {
          return isSameDay(selectedDay, controller.selectedDate.value);
        },
        calendarFormat: CalendarFormat.week,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        onDaySelected: (selectedDate, focusedDate) {
          controller.selectedDate.value = selectedDate;
          onDayChange?.call(selectedDate);
        },
      );
    });
  }
}
