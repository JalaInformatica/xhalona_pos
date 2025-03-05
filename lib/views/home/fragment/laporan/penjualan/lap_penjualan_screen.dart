import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_controller.dart';

class LapPenjualanScreen extends StatelessWidget {
  final LapPenjualanController controller = Get.put(LapPenjualanController());
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void handleLapPenjualan(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      controller.printLapPenjualan().then((url) async {
        if (controller.formatOption.value == 'EXCEL') {
          // Jika format EXCEL, unduh file
          await launchUrl(Uri.parse(url));
        } else {
          // Jika format PDF, tampilkan di PDF viewer
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppPDFViewer(pdfUrl: url)),
          );
        }
      });
    }
  }

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
              child: Form(
                key: _formKey,
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
                                  suffixIcon: Icon(Icons.calendar_today),
                                  onTap: () =>
                                      SmartDialog.show(builder: (context) {
                                    return AppDialog(
                                        content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppCalendar(
                                                    focusedDay:
                                                        DateFormat("dd-MM-yyyy")
                                                            .parse(controller
                                                                .startDate
                                                                .value),
                                                    onDaySelected:
                                                        (selectedDay, _) {
                                                      controller.startDate
                                                          .value = DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(selectedDay);
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
                                  suffixIcon: Icon(Icons.calendar_today),
                                  onTap: () {
                                    SmartDialog.show(builder: (context) {
                                      return AppDialog(
                                          content: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    AppCalendar(
                                                      focusedDay: DateFormat(
                                                              "dd-MM-yyyy")
                                                          .parse(controller
                                                              .endDate.value),
                                                      onDaySelected:
                                                          (selectedDay, _) {
                                                        controller.endDate
                                                            .value = DateFormat(
                                                                'dd-MM-yyyy')
                                                            .format(
                                                                selectedDay);
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
                      title: Text(
                        'Lap. Penjualan',
                        style: AppTextStyle.textBodyStyle(),
                      ),
                      leading: Obx(() => Radio(
                            value: 'Lap_Penjualan',
                            groupValue: controller.selectedReportType.value,
                            onChanged: (value) {
                              controller.selectedReportType.value =
                                  value.toString();
                            },
                          )),
                    ),
                    ListTile(
                      title: Text('Lap. Terapis',
                          style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: 'Lap_Penjualan_By_Terapis',
                            groupValue: controller.selectedReportType.value,
                            onChanged: (value) {
                              controller.selectedReportType.value =
                                  value.toString();
                            },
                          )),
                    ),
                    ListTile(
                      title: Text('Lap. Kasir',
                          style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: 'Lap_Penjualan_Kasir',
                            groupValue: controller.selectedReportType.value,
                            onChanged: (value) {
                              controller.selectedReportType.value =
                                  value.toString();
                            },
                          )),
                    ),
                    SizedBox(height: 16),
                    Text('Detail Laporan:',
                        style: AppTextStyle.textSubtitleStyle()),
                    ListTile(
                      title:
                          Text('Detail', style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: '1',
                            groupValue: controller.detailOption.value,
                            onChanged: (value) {
                              controller.detailOption.value = value.toString();
                            },
                          )),
                    ),
                    ListTile(
                      title: Text('Rekap', style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: '0',
                            groupValue: controller.detailOption.value,
                            onChanged: (value) {
                              controller.detailOption.value = value.toString();
                            },
                          )),
                    ),
                    SizedBox(height: 16),
                    Text('Format:', style: AppTextStyle.textSubtitleStyle()),
                    ListTile(
                      title: Text('PDF', style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: 'PDF',
                            groupValue: controller.formatOption.value,
                            onChanged: (value) {
                              controller.formatOption.value = value.toString();
                            },
                          )),
                    ),
                    ListTile(
                      title: Text('EXCEL', style: AppTextStyle.textBodyStyle()),
                      leading: Obx(() => Radio(
                            value: 'EXCEL',
                            groupValue: controller.formatOption.value,
                            onChanged: (value) {
                              controller.formatOption.value = value.toString();
                            },
                          )),
                    ),
                    SizedBox(height: 24),
                    Center(
                        child: masterButton(() => handleLapPenjualan(context),
                            "Cetak", Icons.print)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
