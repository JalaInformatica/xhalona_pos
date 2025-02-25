import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/finance/lap_finance_controller.dart';

class LapFinanceScreen extends StatelessWidget {
  final LapFinanceController controller = Get.put(LapFinanceController());
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String? _selectedReportType;
  String _detailOption = 'Detail';
  String _formatOption = 'PDF';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10.w,
                    children: [
                      Expanded(
                          child: Obx(() => AppTextFormField(
                                context: context,
                                textEditingController: _startDateController
                                  ..text = controller.startDate.value,
                                readOnly: true,
                                icon: Icon(Icons.calendar_today),
                                onTap: () =>
                                    SmartDialog.show(builder: (context) {
                                  return AppDialog(
                                      content: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                AppCalendar(
                                                  focusedDay:
                                                      DateFormat("dd-MM-yyyy")
                                                          .parse(controller
                                                              .startDate.value),
                                                  onDaySelected:
                                                      (selectedDay, _) {
                                                    controller.startDate.value =
                                                        DateFormat('dd-MM-yyyy')
                                                            .format(
                                                                selectedDay);
                                                    SmartDialog.dismiss();
                                                  },
                                                ),
                                              ])));
                                }),
                                labelText: "Tanggal Dari",
                                style: AppTextStyle.textBodyStyle(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tanggal dari tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ))),
                      Expanded(
                          child: Obx(() => AppTextFormField(
                                context: context,
                                textEditingController: _endDateController
                                  ..text = controller.endDate.value,
                                readOnly: true,
                                icon: Icon(Icons.calendar_today),
                                onTap: () {
                                  SmartDialog.show(builder: (context) {
                                    return AppDialog(
                                        content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppCalendar(
                                                    focusedDay:
                                                        DateFormat("dd-MM-yyyy")
                                                            .parse(controller
                                                                .endDate.value),
                                                    onDaySelected:
                                                        (selectedDay, _) {
                                                      controller.endDate
                                                          .value = DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(selectedDay);
                                                      SmartDialog.dismiss();
                                                    },
                                                  ),
                                                ])));
                                  });
                                },
                                labelText: "Tanggal Sampai",
                                style: AppTextStyle.textBodyStyle(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tanggal Sampai tidak boleh kosong';
                                  }
                                  return null;
                                },
                              ))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Jenis Laporan:',
                      style: AppTextStyle.textSubtitleStyle()),
                  ListTile(
                    title: Text('Lap. Finance',
                        style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'Lap. Finance',
                      groupValue: _selectedReportType,
                      onChanged: (value) {
                        controller.selectedReportType.value = value.toString();
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('Lap. Piutang Customer',
                        style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'Lap. Piutang Customer',
                      groupValue: _selectedReportType,
                      onChanged: (value) {
                        controller.selectedReportType.value = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Detail Laporan:',
                      style: AppTextStyle.textSubtitleStyle()),
                  ListTile(
                    title:
                        Text('Detail', style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'Detail',
                      groupValue: _detailOption,
                      onChanged: (value) {
                        controller.detailOption.value = value.toString();
                      },
                    ),
                  ),
                  ListTile(
                    title:
                        Text('Rekap', style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'Rekap',
                      groupValue: _detailOption,
                      onChanged: (value) {
                        controller.detailOption.value = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Format:', style: AppTextStyle.textSubtitleStyle()),
                  ListTile(
                    title: Text('PDF', style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'PDF',
                      groupValue: _formatOption,
                      onChanged: (value) {
                        controller.formatOption.value = value.toString();
                      },
                    ),
                  ),
                  ListTile(
                    title:
                        Text('EXCEL', style: AppTextStyle.textSubtitleStyle()),
                    leading: Radio(
                      value: 'EXCEL',
                      groupValue: _formatOption,
                      onChanged: (value) {
                        controller.formatOption.value = value.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(child: masterButton(() {}, "Cetak", Icons.print)),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
