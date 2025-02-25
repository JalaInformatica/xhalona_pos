import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/widgets/app_checkbox.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_widget.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_controller.dart';

class MonitorScreen extends StatelessWidget {
  final MonitorController controller = Get.put(MonitorController());
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController productController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> handleMonitorPdf(String template) async {
      if (_formKey.currentState!.validate()) {
        controller
            .printLapPenjualan(
                template, 'PDF', controller.type.value == 'Detail' ? '1' : '0')
            .then((url) async {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppPDFViewer(pdfUrl: url)),
          );
        });
      }
    }

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 10.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    AppTextButton(
                      onPressed: () {
                        controller.showFilters.value =
                            !controller.showFilters.value;
                      },
                      child: Text(
                          "${controller.showFilters.value ? "Sembunyikan" : "Tampilkan"} Filter"),
                    ),
                    if (controller.showFilters.value)
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10.h,
                          children: [
                            Row(
                              spacing: 5.w,
                              children: [
                                Expanded(
                                    child: Obx(() => AppTextField(
                                          context: context,
                                          textEditingController:
                                              _startDateController
                                                ..text =
                                                    controller.startDate.value,
                                          readOnly: true,
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
                                          onTap: () => SmartDialog.show(
                                              builder: (context) {
                                            return AppDialog(
                                                content: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          AppCalendar(
                                                            focusedDay: DateFormat(
                                                                    "dd-MM-yyyy")
                                                                .parse(controller
                                                                    .startDate
                                                                    .value),
                                                            onDaySelected:
                                                                (selectedDay,
                                                                    _) {
                                                              controller
                                                                  .startDate
                                                                  .value = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      selectedDay);
                                                              controller
                                                                  .fetchData();
                                                              SmartDialog
                                                                  .dismiss();
                                                            },
                                                          ),
                                                        ])));
                                          }),
                                          labelText: "Tanggal Dari",
                                          style: AppTextStyle.textBodyStyle(),
                                        ))),
                                Expanded(
                                    child: Obx(() => AppTextField(
                                          context: context,
                                          textEditingController:
                                              _endDateController
                                                ..text =
                                                    controller.endDate.value,
                                          readOnly: true,
                                          suffixIcon:
                                              Icon(Icons.calendar_today),
                                          onTap: () => SmartDialog.show(
                                              builder: (context) {
                                            return AppDialog(
                                                content: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          AppCalendar(
                                                            focusedDay: DateFormat(
                                                                    "dd-MM-yyyy")
                                                                .parse(
                                                                    controller
                                                                        .endDate
                                                                        .value),
                                                            onDaySelected:
                                                                (selectedDay,
                                                                    _) {
                                                              controller.endDate
                                                                  .value = DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      selectedDay);
                                                              controller
                                                                  .fetchData();
                                                              SmartDialog
                                                                  .dismiss();
                                                            },
                                                          ),
                                                        ])));
                                          }),
                                          labelText: "Tanggal Sampai",
                                          style: AppTextStyle.textBodyStyle(),
                                        ))),
                              ],
                            ),
                            Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.w),
                                    border:
                                        Border.all(color: AppColor.grey300)),
                                child: Wrap(
                                  spacing: 10.w,
                                  runSpacing: 5.h,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Filter By: ",
                                      style: AppTextStyle.textBodyStyle(),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(() => AppCheckbox(
                                            value: controller
                                                .isFilterByTerapis.value,
                                            onChanged: (val) {
                                              controller.isFilterByTerapis
                                                  .value = val!;
                                            })),
                                        Text(
                                          "Terapis",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(() => AppCheckbox(
                                            value: controller
                                                .isFilterByCustomer.value,
                                            onChanged: (val) {
                                              controller.isFilterByCustomer
                                                  .value = val!;
                                            })),
                                        Text(
                                          "Customer",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(() => AppCheckbox(
                                            value: controller
                                                .isFilterByProduct.value,
                                            onChanged: (val) {
                                              controller.isFilterByProduct
                                                  .value = val!;
                                            })),
                                        Text(
                                          "Product",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Obx(() => AppCheckbox(
                                            value: controller
                                                .isFilterByKategori.value,
                                            onChanged: (val) {
                                              controller.isFilterByKategori
                                                  .value = val!;
                                            })),
                                        Text(
                                          "Kategori",
                                          style: AppTextStyle.textBodyStyle(),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => Visibility(
                                    visible: controller.isFilterByTerapis.value,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: AppTypeahead<EmployeeDAO>(
                                          label: "Terapis",
                                          controller:
                                              controller.employeeController,
                                          onSelected: (selectedPartId) {
                                            controller.filterTableByTerapis
                                                .value = selectedPartId ?? "";
                                            controller.fetchData();
                                            controller.employeeController.text =
                                                selectedPartId ?? "";
                                          },
                                          updateFilterValue: (newValue) async {
                                            await controller
                                                .fetchTerapis(newValue);
                                            return controller.terapisHeader;
                                          },
                                          displayText: (terapis) =>
                                              terapis.fullName,
                                          getId: (terapis) => terapis.fullName,
                                          onClear: (forceClear) {
                                            if (forceClear ||
                                                controller.employeeController
                                                        .text !=
                                                    controller
                                                        .filterTableByTerapis
                                                        .value) {
                                              controller.filterTableByTerapis
                                                  .value = "";
                                              controller.employeeController
                                                  .clear();
                                              controller.fetchData();
                                            }
                                          }),
                                    ))),
                                Obx(() => Visibility(
                                      visible:
                                          controller.isFilterByProduct.value,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.h),
                                          child: AppTypeahead<ProductDAO>(
                                              label: "Product",
                                              controller:
                                                  controller.productController,
                                              onSelected: (selectedPartId) {
                                                controller.filterTableByProduct
                                                        .value =
                                                    selectedPartId ?? "";
                                                controller.fetchData();
                                                controller.productController
                                                        .text =
                                                    selectedPartId ?? "";
                                              },
                                              updateFilterValue:
                                                  (newValue) async {
                                                await controller
                                                    .fetchProducts(newValue);
                                                return controller.productHeader;
                                              },
                                              displayText: (product) =>
                                                  product.partName,
                                              getId: (product) =>
                                                  product.partName,
                                              onClear: (forceClear) {
                                                if (forceClear ||
                                                    controller.productController
                                                            .text !=
                                                        controller
                                                            .filterTableByProduct
                                                            .value) {
                                                  controller
                                                      .filterTableByProduct
                                                      .value = "";
                                                  controller.productController
                                                      .clear();
                                                  controller.fetchData();
                                                }
                                              })),
                                    )),
                                Obx(() => Visibility(
                                    visible:
                                        controller.isFilterByCustomer.value,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: AppTypeahead<KustomerDAO>(
                                        label: "Customer",
                                        controller:
                                            controller.customerController,
                                        onSelected: (selectedPartId) {
                                          controller.filterTableByCustomer
                                              .value = selectedPartId ?? "";
                                          controller.fetchData();
                                          controller.customerController.text =
                                              selectedPartId ?? "";
                                        },
                                        updateFilterValue: (newValue) async {
                                          await controller
                                              .fetchKustomer(newValue);
                                          return controller.kustomerHeader;
                                        },
                                        displayText: (product) =>
                                            product.suplierName,
                                        getId: (product) => product.suplierName,
                                        onClear: (forceClear) {
                                          if (forceClear ||
                                              controller.customerController
                                                      .text !=
                                                  controller
                                                      .filterTableByCustomer
                                                      .value) {
                                            controller.filterTableByCustomer
                                                .value = "";
                                            controller.customerController
                                                .clear();
                                            controller.fetchData();
                                          }
                                        },
                                      ),
                                    ))),
                                Obx(() => Visibility(
                                      visible:
                                          controller.isFilterByKategori.value,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.h),
                                          child: AppTypeahead<KategoriDAO>(
                                            label: "Kategori",
                                            controller:
                                                controller.categoryController,
                                            onSelected: (selectedPartId) {
                                              controller.filterTableByKategori
                                                  .value = selectedPartId ?? "";
                                              controller.fetchData();
                                              controller.categoryController
                                                  .text = selectedPartId ?? "";
                                            },
                                            updateFilterValue:
                                                (newValue) async {
                                              await controller
                                                  .fetchKategori(newValue);
                                              return controller.kategoriHeader;
                                            },
                                            displayText: (product) =>
                                                product.ketAnalisa,
                                            getId: (product) =>
                                                product.ketAnalisa,
                                            onClear: (forceClear) {
                                              if (forceClear ||
                                                  controller.categoryController
                                                          .text !=
                                                      controller
                                                          .filterTableByKategori
                                                          .value) {
                                                controller.filterTableByKategori
                                                    .value = "";
                                                controller.categoryController
                                                    .clear();
                                                controller.fetchData();
                                              }
                                            },
                                          )),
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration:
                                        InputDecoration(labelText: 'Type'),
                                    value: controller.type.value,
                                    items: ['Detail', 'Rekap', 'Subtotal']
                                        .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type,
                                                  style: AppTextStyle
                                                      .textBodyStyle()),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      controller.type.value = value!;
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                // Expanded(
                                //   child: DropdownButtonFormField<String>(
                                //     decoration: InputDecoration(labelText: 'Shift'),
                                //     value: controller.shift.value,
                                //     items: ['SEMUA', 'PAGI', 'SIANG']
                                //         .map((shift) => DropdownMenuItem(
                                //               value: shift,
                                //               child: Text(shift,
                                //                   style: AppTextStyle.textBodyStyle()),
                                //             ))
                                //         .toList(),
                                //     onChanged: (value) {
                                //         controller.shift.value = value!;
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                            Text('Format Penjualan By:',
                                style: AppTextStyle.textBodyStyle()),
                            Column(
                              spacing: 10.w,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: RadioListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      title: Text('Harian',
                                          style: AppTextStyle.textBodyStyle()),
                                      value: 'SALES_DATE',
                                      groupValue: controller.sortBy.value,
                                      onChanged: (value) {
                                        controller
                                            .updateFormat(value.toString());
                                      },
                                    )),
                                    Expanded(
                                        child: RadioListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      title: Text('Kasir',
                                          style: AppTextStyle.textBodyStyle()),
                                      value: 'SETTLE_BY, SALES_DATE',
                                      groupValue: controller.sortBy.value,
                                      onChanged: (value) {
                                        controller
                                            .updateFormat(value.toString());
                                      },
                                    )),
                                    Expanded(
                                        child: RadioListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      title: Text('Terapis',
                                          style: AppTextStyle.textBodyStyle()),
                                      value: 'EMPLOYEE_ID, SALES_DATE',
                                      groupValue: controller.sortBy.value,
                                      onChanged: (value) {
                                        controller
                                            .updateFormat(value.toString());
                                      },
                                    )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: RadioListTile(
                                      title: Text('Customer',
                                          style: AppTextStyle.textBodyStyle()),
                                      value: 'SUPPLIER_ID, SALES_DATE',
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: controller.sortBy.value,
                                      onChanged: (value) {
                                        controller
                                            .updateFormat(value.toString());
                                      },
                                    )),
                                    Expanded(
                                        child: RadioListTile(
                                      title: Text('Produk',
                                          style: AppTextStyle.textBodyStyle()),
                                      value: 'PART_ID, SALES_DATE',
                                      contentPadding: EdgeInsets.all(0),
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: controller.sortBy.value,
                                      onChanged: (value) {
                                        controller
                                            .updateFormat(value.toString());
                                      },
                                    )),
                                  ],
                                )
                              ],
                            ),
                          ]),
                  ],
                )),
            Row(
              spacing: 10.w,
              children: [
                masterButton(() => handleMonitorPdf('Lap_Penjualan'), "Laporan",
                    Icons.book),
                masterButton(() => handleMonitorPdf('Lap_Penjualan_Kasir'),
                    "Laporan Kasir", Icons.menu_book),
              ],
            ),
            // AppTextButton(
            //   onPressed: (){
            //     controller.fetchData();
            //   },
            //   child: Text("Lihat Monitor")
            // ),
            Obx(() => MonitorTable(titles: [
                  MonitorTableTitle(value: "Tanggal "),
                  MonitorTableTitle(value: "Shift "),
                  MonitorTableTitle(value: "No Trx"),
                  MonitorTableTitle(value: "Customer"),
                  MonitorTableTitle(value: "Produk"),
                  MonitorTableTitle(value: "Kategori "),
                  MonitorTableTitle(value: "Qty "),
                  MonitorTableTitle(value: "Harga"),
                  MonitorTableTitle(value: "Total"),
                  MonitorTableTitle(value: "Diskon"),
                  MonitorTableTitle(value: "Tagihan "),
                  MonitorTableTitle(value: "Metode Bayar "),
                  MonitorTableTitle(value: "Komp/Vch"),
                  MonitorTableTitle(value: "Penerimaan"),
                  MonitorTableTitle(value: "Cash"),
                  MonitorTableTitle(value: "Trf/Qris "),
                  MonitorTableTitle(value: "Hutang "),
                  MonitorTableTitle(value: "Titipan"),
                  MonitorTableTitle(value: "Terapis"),
                ], data: controller.groupingData(controller.monitorHeader))),
            SizedBox(
              width: double.infinity,
              height: 500.h,
              child: Obx(
                () => AppTable(
                  onSearch: (filterValue) =>
                      controller.updateFilterValue(filterValue),
                  onChangePageNo: (pageNo) => () {},
                  onChangePageRow: (pageRow) => () {},
                  pageNo: controller.pageNo.value,
                  pageRow: controller.pageRow.value,
                  titles: [
                    AppTableTitle(value: "Tanggal "),
                    AppTableTitle(value: "Shift "),
                    AppTableTitle(value: "No Trx"),
                    AppTableTitle(value: "Customer"),
                    AppTableTitle(value: "Produk"),
                    AppTableTitle(value: "Kategori "),
                    AppTableTitle(value: "Qty "),
                    AppTableTitle(value: "Harga"),
                    AppTableTitle(value: "Total"),
                    AppTableTitle(value: "Diskon"),
                    AppTableTitle(value: "Tagihan "),
                    AppTableTitle(value: "Metode Bayar "),
                    AppTableTitle(value: "Komp/Vch"),
                    AppTableTitle(value: "Penerimaan"),
                    AppTableTitle(value: "Cash"),
                    AppTableTitle(value: "Trf/Qris "),
                    AppTableTitle(value: "Hutang "),
                    AppTableTitle(value: "Titipan"),
                    AppTableTitle(value: "Terapis"),
                  ],
                  data: List.generate(controller.monitorHeader.length, (i) {
                    var monitor = controller.monitorHeader[i];
                    return [
                      AppTableCell(
                          value: monitor.createDate.split("T").first, index: i),
                      AppTableCell(value: monitor.shiftId, index: i),
                      AppTableCell(
                          value: shortenTrxId(monitor.salesId), index: i),
                      AppTableCell(value: monitor.supplierName, index: i),
                      AppTableCell(value: monitor.partName, index: i),
                      AppTableCell(value: monitor.ketAnalisa, index: i),
                      AppTableCell(value: monitor.qty.toString(), index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.price), index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.totalPrice), index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.discVal), index: i),
                      AppTableCell(
                          value: monitor.totalCompliment.toString(), index: i),
                      AppTableCell(
                          value: monitor.settlePaymentMethod, index: i),
                      AppTableCell(
                          value: monitor.feeEmpVal.toString(), index: i),
                      AppTableCell(
                          value: formatThousands(monitor.nettoValD.toString()),
                          index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.totalCash), index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.totalNonCash),
                          index: i),
                      AppTableCell(
                          value: formatCurrency(monitor.totalHutang), index: i),
                      AppTableCell(
                          value: monitor.addCostVal.toString(), index: i),
                      AppTableCell(value: monitor.fullName, index: i),
                    ];
                  }),
                  onRefresh: () => controller.fetchData(),
                  isRefreshing: controller.isLoading.value,
                ),
              ),
            ),
            Obx(() {
              if (controller.monitorHeader.isEmpty) {
                return SizedBox(); // Jika tidak ada data, tidak perlu menampilkan card
              }
              return Card(
                color: AppColor.primaryColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grand Total',
                        style:
                            AppTextStyle.textSubtitleStyle(color: Colors.white),
                      ),
                      const Divider(color: Colors.white54, thickness: 1),
                      _buildSummaryRow('Tagihan',
                          formatCurrency(controller.sumTagihan.value)),
                      _buildSummaryRow('Penerimaan',
                          formatCurrency(controller.sumAcc.value)),
                      _buildSummaryRow(
                          'Cash', formatCurrency(controller.sumCash.value)),
                      _buildSummaryRow(
                          'Diskon', formatCurrency(controller.sumDisc.value)),
                      _buildSummaryRow(
                          'Hutang', formatCurrency(controller.sumHutang.value)),
                      _buildSummaryRow(
                          'Tf/Qris', formatCurrency(controller.sumQris.value)),
                      _buildSummaryRow('Titipan', controller.sumTitipan.value),
                      _buildSummaryRow('Komp/Vch', controller.sumVch.value),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.textSubtitleStyle(
              color: Colors.white70,
            ),
          ),
          Text(
            value.toString(),
            style: AppTextStyle.textSubtitleStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTypeAheadFieldCustomer(
    String label,
    List<KustomerDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: TypeAheadField<KustomerDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) => item.suplierName
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return AppTextField(
              context: context,
              textEditingController: controller,
              focusNode: focusNode,
              labelText: label,
            );
          },
          itemBuilder: (context, KustomerDAO suggestion) {
            return ListTile(
              title: Text(suggestion.suplierName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KustomerDAO suggestion) {
            controller.text = suggestion.suplierName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.suplierId); // Simpan ID produk di _product
          },
        ));
  }

  Widget buildTypeAheadFieldTerapis(
    String label,
    List<KaryawanDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: TypeAheadField<KaryawanDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) =>
                    item.fullName.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;
            return AppTextField(
              context: context,
              textEditingController: controller,
              focusNode: focusNode,
              labelText: label,
            );
          },
          itemBuilder: (context, KaryawanDAO suggestion) {
            return ListTile(
              title: Text(suggestion.fullName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (KaryawanDAO suggestion) {
            controller.text = suggestion.fullName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.empId); // Simpan ID produk di _product
          },
        ));
  }

  Widget buildTypeAheadFieldProduct(
    String label,
    List<ProductDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: TypeAheadField<ProductDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern);
            return items
                .where((item) =>
                    item.partName.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return AppTextField(
              context: context,
              textEditingController: controller,
              focusNode: focusNode,
              labelText: label,
            );
          },
          itemBuilder: (context, ProductDAO suggestion) {
            return ListTile(
              title: Text(suggestion.partName
                  .toString()), // Tampilkan ID sebagai info tambahan
            );
          },
          onSelected: (ProductDAO suggestion) {
            controller.text = suggestion.partName
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.partId); // Simpan ID produk di _product
          },
        ));
  }

  Widget buildTypeAheadFieldKategori(
    String label,
    List<KategoriDAO> items,
    ValueChanged<String?> onChanged,
    void Function(String newFilterValue) updateFilterValue,
  ) {
    TextEditingController controller = TextEditingController();

    return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: TypeAheadField<KategoriDAO>(
          suggestionsCallback: (pattern) async {
            updateFilterValue(pattern); // Update filter
            return items
                .where((item) => item.ketAnalisa
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
                .toList(); // Pencarian berdasarkan nama
          },
          builder: (context, textEditingController, focusNode) {
            controller = textEditingController;

            return AppTextField(
              context: context,
              textEditingController: controller,
              focusNode: focusNode,
              labelText: label,
            );
          },
          itemBuilder: (context, KategoriDAO suggestion) {
            return ListTile(
              title: Text(suggestion.ketAnalisa.toString()),
            );
          },
          onSelected: (KategoriDAO suggestion) {
            controller.text = suggestion.ketAnalisa
                .toString(); // Tampilkan nama produk di field
            onChanged(suggestion.ketAnalisa); // Simpan ID produk di _product
          },
        ));
  }
}
