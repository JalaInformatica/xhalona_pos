import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppCalendarRange extends TableCalendar {
  AppCalendarRange({
    required DateTime focusedDay,
    required Function(DateTime?, DateTime?) onRangeSelected,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) : super(
          headerStyle: HeaderStyle(
            titleTextStyle: AppTextStyle.textSubtitleStyle(),
            titleCentered: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.whiteColor,
            ),
          ),
          weekNumbersVisible: false,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: AppTextStyle.textBodyStyle(),
            weekdayStyle: AppTextStyle.textBodyStyle(),
          ),
          rangeSelectionMode: RangeSelectionMode.toggledOn,
          rangeStartDay: rangeStart,
          rangeEndDay: rangeEnd,
          calendarStyle: CalendarStyle(
            todayDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColor.tertiaryColor,
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: const BoxDecoration(
              color: AppColor.primaryColor,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: const BoxDecoration(
              color: AppColor.secondaryColor,
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: AppColor.tertiaryColor,
            todayTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
            selectedTextStyle:
                AppTextStyle.textBodyStyle(color: AppColor.secondaryColor),
            defaultTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
            weekendTextStyle: AppTextStyle.textBodyStyle(color: Colors.black),
            disabledTextStyle:
                AppTextStyle.textBodyStyle(color: AppColor.grey500),
          ),
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          locale: 'id_ID',
          focusedDay: focusedDay,
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),

          onDaySelected: (selectedDay, _) {
            if (rangeEnd != rangeStart){
              //if range end exists, then reset
              onRangeSelected(selectedDay, selectedDay);
            }
            else if (rangeStart!=null){
              if (selectedDay.isAfter(rangeStart)) {
                onRangeSelected(rangeStart, selectedDay);
              } else {
                onRangeSelected(selectedDay, rangeStart);
              }
            }
          },
        );
}
