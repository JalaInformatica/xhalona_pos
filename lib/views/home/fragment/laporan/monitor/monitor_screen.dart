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
import 'package:xhalona_pos/widgets/app_icon_button.dart';
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
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(top: 15, left: 15),
              child: Column(
                  spacing: 10.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 10.w,
                          children: [
                            AppTextButton(
                              onPressed: () {
                                controller.showFilters.value = true;
                              },
                              child: Text("Filter"),
                            ),
                            masterButton(
                                () => handleMonitorPdf('Lap_Penjualan'),
                                "Laporan",
                                Icons.book),
                            masterButton(
                                () => handleMonitorPdf('Lap_Penjualan_Kasir'),
                                "Laporan Kasir",
                                Icons.menu_book),
                          ],
                        )),
                    Obx(() => MonitorTable(
                        isLoading: controller.isLoading.value,
                        skippedRowIds: controller.formatId,
                        titles: [
                          MonitorTableTitle(value: "Tanggal "),
                          MonitorTableTitle(value: "Shift "),
                          MonitorTableTitle(value: "No Trx"),
                          MonitorTableTitle(value: "Customer"),
                          MonitorTableTitle(value: "Produk"),
                          MonitorTableTitle(value: "Kategori "),
                          MonitorTableTitle(
                            value: "Qty ",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Harga",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Total",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Diskon",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Tagihan ",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(value: "Metode Bayar "),
                          MonitorTableTitle(
                            value: "Komp/Vch",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Penerimaan",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Cash",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Trf/Qris ",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Hutang ",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(
                            value: "Titipan",
                            textAlign: TextAlign.end,
                          ),
                          MonitorTableTitle(value: "Terapis"),
                        ],
                        data:
                            controller.groupingData(controller.monitorHeader)))
                  ])),
          Obx(() => controller.showFilters.value
              ? SingleChildScrollView(
                  child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        border: Border(
                            bottom: BorderSide(
                                color: AppColor.primaryColor, width: 3.h))),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                        suffixIcon: Icon(Icons.calendar_today),
                                        onTap: () => SmartDialog.show(
                                            builder: (context) {
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
                                                              (selectedDay, _) {
                                                            controller.startDate
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
                                              ..text = controller.endDate.value,
                                        readOnly: true,
                                        suffixIcon: Icon(Icons.calendar_today),
                                        onTap: () => SmartDialog.show(
                                            builder: (context) {
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
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        AppCalendar(
                                                          focusedDay: DateFormat(
                                                                  "dd-MM-yyyy")
                                                              .parse(controller
                                                                  .endDate
                                                                  .value),
                                                          onDaySelected:
                                                              (selectedDay, _) {
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
                                  border: Border.all(color: AppColor.grey300)),
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
                                            controller.isFilterByTerapis.value =
                                                val!;
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
                                            controller.isFilterByProduct.value =
                                                val!;
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
                                    visible: controller.isFilterByProduct.value,
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: AppTypeahead<ProductDAO>(
                                            label: "Product",
                                            controller:
                                                controller.productController,
                                            onSelected: (selectedPartId) {
                                              controller.filterTableByProduct
                                                  .value = selectedPartId ?? "";
                                              controller.fetchData();
                                              controller.productController
                                                  .text = selectedPartId ?? "";
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
                                                controller.filterTableByProduct
                                                    .value = "";
                                                controller.productController
                                                    .clear();
                                                controller.fetchData();
                                              }
                                            })),
                                  )),
                              Obx(() => Visibility(
                                  visible: controller.isFilterByCustomer.value,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: AppTypeahead<KustomerDAO>(
                                      label: "Customer",
                                      controller: controller.customerController,
                                      onSelected: (selectedPartId) {
                                        controller.filterTableByCustomer.value =
                                            selectedPartId ?? "";
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
                                            controller
                                                    .customerController.text !=
                                                controller.filterTableByCustomer
                                                    .value) {
                                          controller
                                              .filterTableByCustomer.value = "";
                                          controller.customerController.clear();
                                          controller.fetchData();
                                        }
                                      },
                                    ),
                                  ))),
                              Obx(() => Visibility(
                                    visible:
                                        controller.isFilterByKategori.value,
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: AppTypeahead<KategoriDAO>(
                                          label: "Kategori",
                                          controller:
                                              controller.categoryController,
                                          onSelected: (selectedPartId) {
                                            controller.filterTableByKategori
                                                .value = selectedPartId ?? "";
                                            controller.fetchData();
                                            controller.categoryController.text =
                                                selectedPartId ?? "";
                                          },
                                          updateFilterValue: (newValue) async {
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
                                      controller.updateFormat(value.toString());
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
                                      controller.updateFormat(value.toString());
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
                                      controller.updateFormat(value.toString());
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
                                      controller.updateFormat(value.toString());
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
                                      controller.updateFormat(value.toString());
                                    },
                                  )),
                                ],
                              )
                            ],
                          ),
                        ]),
                  ),
                  AppIconButton(
                      shape: CircleBorder(),
                      backgroundColor: AppColor.grey500,
                      foregroundColor: AppColor.whiteColor,
                      onPressed: () {
                        controller.showFilters.value = false;
                      },
                      icon: Icon(Icons.close_rounded))
                ]))
              : SizedBox.shrink())
        ],
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
