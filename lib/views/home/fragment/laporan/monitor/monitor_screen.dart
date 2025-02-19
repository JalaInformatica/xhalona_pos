import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/widgets/app_calendar.dart';
import 'package:xhalona_pos/widgets/app_checkbox.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_table.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/karyawan.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/produk_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/monitor/monitor_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/karyawan/karyawan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/product/kategori/kategori_controller.dart';
import 'package:xhalona_pos/views/home/fragment/laporan/penjualan/lap_penjualan_viewer_screen.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/supplier/supplier_kustomer_controller.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';

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
        controller.printLapPenjualan(
          template,
          'PDF',
          controller.type.value == 'Detail' ? '1' : '0')
        .then((url) async {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AppPDFViewer(pdfUrl: url)),
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
              Row(
                children: [
                  Expanded(
                      child: Obx(() => AppTextField(
                            context: context,
                            textEditingController: _startDateController
                              ..text = controller.startDate.value,
                            readOnly: true,
                            suffixIcon: Icon(Icons.calendar_today),
                            onTap: () => SmartDialog.show(builder: (context) {
                              return AppDialog(
                                  content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppCalendar(
                                              focusedDay:
                                                  DateFormat("dd-MM-yyyy")
                                                      .parse(controller
                                                          .startDate.value),
                                              onDaySelected: (selectedDay, _) {
                                                controller.startDate.value =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDay);
                                                controller.fetchData();
                                                SmartDialog.dismiss();
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
                            textEditingController: _endDateController
                              ..text = controller.endDate.value,
                            readOnly: true,
                            suffixIcon: Icon(Icons.calendar_today),
                            onTap: () => SmartDialog.show(builder: (context) {
                              return AppDialog(
                                  content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppCalendar(
                                              focusedDay: DateFormat(
                                                      "dd-MM-yyyy")
                                                  .parse(
                                                      controller.endDate.value),
                                              onDaySelected: (selectedDay, _) {
                                                controller.endDate.value =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDay);
                                                controller.fetchData();
                                                SmartDialog.dismiss();
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
                  border: Border.all(color: AppColor.grey300)
                ),
                child: Wrap(
                  spacing: 10.w,
                  runSpacing: 5.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                  Text("Filter By: ", style: AppTextStyle.textBodyStyle(),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Obx(()=> AppCheckbox(
                        value: controller.isFilterByTerapis.value, 
                        onChanged: (val){
                          controller.isFilterByTerapis.value=val!;
                        }
                      )),
                      Text("Terapis", style: AppTextStyle.textBodyStyle(),),
                    ],),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Obx(()=> AppCheckbox(
                        value: controller.isFilterByCustomer.value, 
                        onChanged: (val){
                          controller.isFilterByCustomer.value=val!;
                        }
                      )),
                      Text("Customer", style: AppTextStyle.textBodyStyle(),),
                    ],),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Obx(()=> AppCheckbox(
                        value: controller.isFilterByProduct.value, 
                        onChanged: (val){
                          controller.isFilterByProduct.value=val!;
                        }
                      )),
                      Text("Product", style: AppTextStyle.textBodyStyle(),),
                    ],),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Obx(()=> AppCheckbox(
                        value: controller.isFilterByKategori.value, 
                        onChanged: (val){
                          controller.isFilterByKategori.value=val!;
                        }
                      )),
                      Text("Kategori", style: AppTextStyle.textBodyStyle(),),
                    ],),
                ],)
              ),
              Column(children: [                
                Obx(()=> Visibility(
                    visible: controller.isFilterByTerapis.value,
                    child: AppTypeahead<EmployeeDAO>(
                      label: "Terapis", 
                      controller: controller.employeeController,
                      onSelected: (selectedPartId){
                        controller.filterTableByProduct.value = selectedPartId ?? "";
                        controller.productController.text = selectedPartId??"";
                      }, 
                      updateFilterValue: (newValue) async{
                        await controller.fetchTerapis(newValue);
                        return controller.terapisHeader;
                      }, 
                      displayText: (terapis)=>terapis.fullName, 
                      getId: (terapis)=>terapis.fullName
                    ),
                  )
                ),
                Obx(()=> Visibility(
                    visible: controller.isFilterByProduct.value,
                    child: AppTypeahead<ProductDAO>(
                      label: "Product", 
                      controller: controller.productController,
                      onSelected: (selectedPartId){
                        controller.filterTableByProduct.value = selectedPartId ?? "";
                        controller.productController.text = selectedPartId??"";
                      }, 
                      updateFilterValue: (newValue) async{
                        await controller.fetchProducts(newValue);
                        return controller.productHeader;
                      }, 
                      onTapOutside: (){
                        if(controller.productController.text!=controller.filterTableByProduct.value){
                          controller.filterTableByProduct.value="";
                          controller.productController.clear();
                          print('a');
                        }
                        print('b');
                      },
                      displayText: (product)=>product.partName, 
                      getId: (product)=>product.partName
                    ),
                  )
                ),
              ],),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Type'),
                      value: controller.type.value,
                      items: ['Detail', 'Rekap', 'Subtotal']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type,
                                    style: AppTextStyle.textBodyStyle()),
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
              Text('Format Penjualan By:', style: AppTextStyle.textBodyStyle()),
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title:
                            Text('Harian', style: AppTextStyle.textBodyStyle()),
                        value: 'SALES_DATE',
                        groupValue: controller.format.value,
                        onChanged: (value) {
                          controller.updateFormat(value.toString());
                        },
                      )),
                      Expanded(
                          child: RadioListTile(
                        contentPadding: EdgeInsets.all(0),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title:
                            Text('Kasir', style: AppTextStyle.textBodyStyle()),
                        value: 'SETTLE_BY, SALES_DATE',
                        groupValue: controller.format.value,
                        onChanged: (value) {
                          controller.updateFormat(value.toString());
                        },
                      )),
                      Expanded(
                          child: RadioListTile(
                        contentPadding: EdgeInsets.all(0),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        title: Text('Terapis',
                            style: AppTextStyle.textBodyStyle()),
                        value: 'EMPLOYEE_ID, SALES_DATE',
                        groupValue: controller.format.value,
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: controller.format.value,
                        onChanged: (value) {
                          controller.updateFormat(value.toString());
                        },
                      )),
                      Expanded(
                          child: RadioListTile(
                        title:
                            Text('Produk', style: AppTextStyle.textBodyStyle()),
                        value: 'PART_ID, SALES_DATE',
                        contentPadding: EdgeInsets.all(0),
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: controller.format.value,
                        onChanged: (value) {
                          controller.updateFormat(value.toString());
                        },
                      )),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  masterButton(() => handleMonitorPdf('Lap_Penjualan'),
                      "Laporan", Icons.book),
                  masterButton(() => handleMonitorPdf('Lap_Penjualan_Kasir'),
                      "Laporan Kasir", Icons.menu_book),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 500.h,
                child: Obx(
                  () => AppTable(
                    onSearch: (filterValue) =>
                      controller.updateFilterValue(filterValue),
                    onChangePageNo: (pageNo) => (){},
                    onChangePageRow: (pageRow) => (){},
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
                    data: List.generate(controller.monitorHeader.length, (i){
                      var monitor = controller.monitorHeader[i];
                      return [
                        AppTableCell(
                            value: monitor.createDate.split("T").first,
                            index: i),
                        AppTableCell(value: monitor.shiftId, index: i),
                        AppTableCell(value: monitor.salesId, index: i),
                        AppTableCell(value: monitor.supplierName, index: i),
                        AppTableCell(value: monitor.partName, index: i),
                        AppTableCell(value: monitor.ketAnalisa, index: i),
                        AppTableCell(value: monitor.qty.toString(), index: i),
                        AppTableCell(value: monitor.price.toString(), index: i),
                        AppTableCell(
                            value: monitor.totalPrice.toString(), index: i),
                        AppTableCell(
                            value: monitor.discVal.toString(), index: i),
                        AppTableCell(
                            value: monitor.totalCompliment.toString(),
                            index: i),
                        AppTableCell(
                            value: monitor.settlePaymentMethod, index: i),
                        AppTableCell(
                            value: monitor.feeEmpVal.toString(), index: i),
                        AppTableCell(
                            value: monitor.nettoValD.toString(), index: i),
                        AppTableCell(
                            value: monitor.totalCash.toString(), index: i),
                        AppTableCell(
                            value: monitor.totalNonCash.toString(), index: i),
                        AppTableCell(
                            value: monitor.totalHutang.toString(), index: i),
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
                          style: AppTextStyle.textSubtitleStyle(
                              color: Colors.white),
                        ),
                        const Divider(color: Colors.white54, thickness: 1),
                        _buildSummaryRow(
                            'Tagihan', controller.sumTagihan.value),
                        _buildSummaryRow('Penerimaan',
                            formatCurrency(controller.sumAcc.value)),
                        _buildSummaryRow(
                            'Cash', formatCurrency(controller.sumCash.value)),
                        _buildSummaryRow('Diskon', controller.sumDisc.value),
                        _buildSummaryRow('Hutang', controller.sumHutang.value),
                        _buildSummaryRow('Tf/Qris',
                            formatCurrency(controller.sumQris.value)),
                        _buildSummaryRow(
                            'Titipan', controller.sumTitipan.value),
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
            .where((item) =>
                item.suplierName.toLowerCase().contains(pattern.toLowerCase()))
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
        ;
      },
      itemBuilder: (context, KustomerDAO suggestion) {
        return ListTile(
          title: Text(suggestion.suplierName
              .toString()), // Tampilkan ID sebagai info tambahan
        );
      },
      onSelected: (KustomerDAO suggestion) {
        controller.text =
            suggestion.suplierName.toString(); // Tampilkan nama produk di field
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
        controller.text =
            suggestion.fullName.toString(); // Tampilkan nama produk di field
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
        controller.text =
            suggestion.partName.toString(); // Tampilkan nama produk di field
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
            .where((item) =>
                item.ketAnalisa.toLowerCase().contains(pattern.toLowerCase()))
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
          title: Text(suggestion.ketAnalisa
              .toString()), 
        );
      },
      onSelected: (KategoriDAO suggestion) {
        controller.text =
            suggestion.ketAnalisa.toString(); // Tampilkan nama produk di field
        onChanged(suggestion.ketAnalisa); // Simpan ID produk di _product
      },
    ));
  }
}
