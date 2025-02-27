import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class AppCalendar extends TableCalendar {
  AppCalendar(
      {required DateTime focusedDay,
      void Function(DateTime, DateTime)? onDaySelected})
      : super(
          headerStyle: HeaderStyle(
              titleTextStyle: AppTextStyle.textSubtitleStyle(),
              titleCentered: true,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.whiteColor)),
          weekNumbersVisible: false,
          daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: AppTextStyle.textBodyStyle(),
              weekdayStyle: AppTextStyle.textBodyStyle()),
          calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColor.tertiaryColor,
                shape: BoxShape.circle,
              ),
              todayTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
              selectedTextStyle:
                  AppTextStyle.textBodyStyle(color: AppColor.secondaryColor),
              defaultTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
              weekendTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
              disabledTextStyle:
                  AppTextStyle.textBodyStyle(color: AppColor.grey500)),
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          locale: 'id_ID',
          focusedDay: focusedDay,
          firstDay: DateTime(2024, 1, 1),
          lastDay: DateTime(2030, 12, 31),
          onDaySelected: onDaySelected,
          selectedDayPredicate: (day) => isSameDay(focusedDay, day),
        );
}
