import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppMonthPicker extends StatelessWidget {
  final int year;
  final int selectedMonth;
  final ValueChanged<DateTime> onMonthSelected;

  const AppMonthPicker({
    Key? key,
    required this.year,
    required this.selectedMonth,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => DateTime(year, index + 1));

    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final month = months[index];
        final monthName = _monthName(month.month);

        return GestureDetector(
          onTap: () => onMonthSelected(month),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: index+1!=selectedMonth? AppColor.whiteColor : AppColor.tertiaryColor,
            child: Center(
              child: Text(
                monthName,
                style: AppTextStyle.textBodyStyle(
                  color: index+1!=selectedMonth? AppColor.blackColor : AppColor.primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    return [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ][month - 1];
  }
}
