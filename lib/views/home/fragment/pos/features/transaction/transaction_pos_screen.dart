import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/utils/app_navigator.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/models/dao/product.dart';
import 'package:xhalona_pos/views/home/fragment/pos/checkout_screen.dart';
import 'package:xhalona_pos/views/home/fragment/pos/features/transaction/state/transaction_pos_state.dart';
import 'package:xhalona_pos/views/home/fragment/pos/features/transaction/viewmodel/transaction_pos_viewmodel.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_screen.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_dropdown.dart';
import 'package:xhalona_pos/widgets/app_pdf_viewer.dart';
import 'package:xhalona_pos/widgets/app_text_form_field2.dart';
import 'package:xhalona_pos/widgets/app_typeahead.dart';
import 'package:xhalona_pos/widgets/app_typeahead2.dart';
import 'package:xhalona_pos/widgets/app_typeahead_custom.dart';

import 'widgets/transaction_pos_widget.dart';

class Terapis {
  int index;
  String id;
  String name;

  Terapis({
    required this.index,
    required this.id, 
    required this.name
  });
}

class TransactionPosScreen extends HookConsumerWidget {
  final String salesId;

  const TransactionPosScreen({
    super.key, 
    required this.salesId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final state = ref.watch(transactionPosViewModelProvider(salesId));
    final notifier = ref.read(transactionPosViewModelProvider(salesId).notifier);
    final widget = TransactionPosWidget(state: state, notifier: notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
              spacing: 8,
              children: [
                AppIconButton(
                  shape: CircleBorder(),
                  backgroundColor: AppColor.transparentColor,
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    AppNavigator.navigateBack(context);
                  }, 
                  icon: Icon(Icons.arrow_back)
                ),
                Text(state.transactionHeader.salesId, style: AppTextStyle.textMdStyle(),),
                Spacer(),
                AppTextButton(
                  onPressed: () async {
                    String newSalesId = await notifier.createTransaction();
                    if(context.mounted){
                      AppNavigator.navigatePushReplace(context, TransactionPosScreen(salesId: newSalesId));
                    }
                  }, 
                  child: Text("Baru"))
              ],
            )),
            state.isLoadingTransaction?
            Expanded(child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                  AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                  AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                ],
              )
            )) :
            Expanded(
              child: Scrollbar(child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.shiftContainer(),
                  SizedBox(height: 8,),
                  Text("Informasi Pelanggan", style: AppTextStyle.textNStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  Row(
                    spacing: 5,
                    children: [
                      AppTextButton(
                        borderColor: state.customerType == CustomerType.member? 
                          AppColor.primaryColor : AppColor.grey300,
                        foregroundColor: state.customerType == CustomerType.member?
                          AppColor.primaryColor : AppColor.grey800,
                        onPressed: (){
                          if(state.transactionHeader.statusCategory == "PROGRESS"){
                            notifier.setCustomerType(CustomerType.member);
                          }
                        },
                        child: Text("Member", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
                      ),
                      AppTextButton(
                        borderColor: state.customerType == CustomerType.tamu? 
                          AppColor.primaryColor : AppColor.grey300,
                        foregroundColor: state.customerType == CustomerType.tamu?
                          AppColor.primaryColor : AppColor.grey800,
                        onPressed: (){
                          if(state.transactionHeader.statusCategory == "PROGRESS"){
                            notifier.setCustomerType(CustomerType.tamu);
                          }
                        },
                        child: Text("Tamu", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
                      ),
                    ]
                  ),
                  SizedBox(height: 8,),
                  state.customerType == CustomerType.member?
                    widget.memberAppTypeAhead()
                     : widget.guestAppTypeAhead(context),
                    
                  SizedBox(height: 8,),
                  Text("Layanan", style: AppTextStyle.textNStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),),
                  SizedBox(height: 8,),
                  if(state.transactionHeader.statusCategory == "PROGRESS")
                  AppTypeahead2<ProductDAO>(
                    label: 'Cari Layanan', 
                    controller: notifier.productController,
                    onSelected: (val) async {
                      await notifier.addTransactionDetail(partId: val.partId);
                      notifier.productController.clear();
                      await notifier.initialize();
                    }, 
                    debounceDuration: Duration(seconds: 1),
                    updateFilterValue: (val) async {
                      return val.isNotEmpty? await notifier.getProductList(filter: val) : [];
                    }, 
                    displayWidget: (val)=>Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [ 
                        Container(
                          padding: EdgeInsets.all(2),
                          color: AppColor.grey100,
                          child: Icon(Icons.spa, color: AppColor.grey300,)
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(val.partName, style: AppTextStyle.textNStyle(),),
                            Row(children: [ 
                              Text(formatToRupiah(val.unitPrice), style: AppTextStyle.textXsStyle(color: AppColor.doneColor),)
                            ])
                          ]
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              val.isPacket? "Paket" : val.isFixQty? "Jasa": "Barang", 
                              style: AppTextStyle.textXsStyle(),
                            ),
                          ],
                        )
                      ]
                    ), 
                    onClear: (val) async {
                      notifier.productController.clear();
                    },
                    emptyBuilder: (context){
                      return SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 8,),
                  state.isLoadingTransactionDetail?
                  Column(
                    spacing: 8,
                    children: [
                      AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                      AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                      AppShimmer.fromColors(child: Container(color: AppColor.whiteColor, width: double.maxFinite, height: 25,)),
                    ],
                  ):
                  Column(
                    spacing: 8,
                    children: List.generate(state.transactionDetailList.length, (index) {
                    final detail = state.transactionDetailList[index];

                    final terapisList = [ Terapis(index: 1, id: detail.employeeId, name: detail.fullName), Terapis(index: 2, id: detail.employeeId2, name: detail.employeeName2), Terapis(index: 3, id: detail.employeeId3, name: detail.employeeName3), Terapis(index: 4, id: detail.employeeId4, name: detail.employeeName4)].where((item)=>item.name.isNotEmpty).toList();
                    return Container(
                    margin: detail.parentPartId.isNotEmpty? EdgeInsets.only(left: 12):null,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.grey300),
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(                      
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(detail.partName, style: AppTextStyle.textNStyle(fontWeight: FontWeight.bold),) 
                            ),
                            if(state.transactionHeader.statusCategory == "PROGRESS" && detail.parentPartId.isEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              AppIconButton(
                                onPressed: () {
                                  TextEditingController noteController = TextEditingController()..text=detail.detNote;
                                  showModalBottomSheet(
                                  context: context, 
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  backgroundColor: AppColor.whiteColor,
                                  isScrollControlled: true,
                                  builder: (context){
                                    return Container(
                                      width: double.maxFinite,
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                                      ),
                                      child: Column(
                                        spacing: 5,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              AppIconButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                              }, 
                                              icon: Icon(Icons.close)
                                              ),
                                              Text("Catatan", style: AppTextStyle.textMdStyle(
                                                color: AppColor.blackColor
                                              ),)
                                            ],
                                          ),
                                          AppTextField(
                                            textEditingController: noteController,
                                            context: context,
                                            maxLines: 3,
                                            inputAction: TextInputAction.newline,
                                          ),
                                          SizedBox(
                                            width: double.maxFinite,
                                            child:AppTextButton(
                                            backgroundColor: AppColor.primaryColor,
                                            foregroundColor: AppColor.whiteColor,
                                            onPressed: () async {
                                              await notifier.editTransactionDetail(
                                                detail: detail, 
                                                partId: detail.partId, 
                                                rowId: detail.rowId,
                                                detNote: noteController.text
                                              );
                                              await notifier.getTransactionDetail();
                                              Navigator.pop(context);
                                            }, 
                                            child: Text("Simpan", style: AppTextStyle.textMdStyle(),)
                                          ))
                                        ],
                                      ),
                                    );
                                  });
                                },
                                icon: detail.detNote.isNotEmpty? Badge(
                                  backgroundColor: AppColor.blueColor,
                                  padding: EdgeInsets.zero,
                                  label: Text('i', style: AppTextStyle.textXsStyle(color: AppColor.whiteColor),),
                                  child: Icon(
                                    Icons.note_add_outlined,
                                    size: 20,
                                    color: AppColor.grey800,
                                  ),
                                ) : Icon(
                                    Icons.note_add_outlined,
                                    size: 20,
                                    color: AppColor.grey800,
                                  ),
                              ),
                              AppIconButton(
                                onPressed: () async {
                                  await notifier.deleteTransactionDetail(rowId: detail.rowId);
                                  await notifier.initialize();
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                  color: AppColor.dangerColor,
                                ),
                              ),
                            ])
                          ],
                        ),
                        if(!detail.isPacket)
                        Column(children: [
                        SizedBox(height: 8,),
                        TextButton(
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            shape: BeveledRectangleBorder()
                          ),
                          onPressed: (){
                            if(state.transactionHeader.statusCategory != "PROGRESS"){
                              return;
                            }
                            SmartDialog.show(builder: (context){
                              return AppDialog2(
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Tambah Terapis", style: AppTextStyle.textNStyle(fontWeight: FontWeight.bold),),
                                      Text("Cari Terapis Untuk ${detail.partName}", style: AppTextStyle.textXsStyle(color: AppColor.grey500),)
                                    ])
                                  ),
                                child: Column(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(terapisList.isNotEmpty)
                                    Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: List.generate(terapisList.length, (indexTerapis) {
                                        return IntrinsicWidth( 
                                          child: AppTextButton(
                                            borderColor: AppColor.transparentColor,
                                            backgroundColor: AppColor.grey100,
                                            foregroundColor: AppColor.blackColor,
                                            onPressed: () {
                                              switch (terapisList[indexTerapis].index) {
                                                case 1:
                                                  notifier.editTransactionDetail(
                                                      detail: detail,
                                                      partId: detail.partId,
                                                      rowId: detail.rowId,
                                                      employeId: '');
                                                  break;
                                                case 2:
                                                  notifier.editTransactionDetail(
                                                      detail: detail,
                                                      partId: detail.partId,
                                                      rowId: detail.rowId,
                                                      employeId2: '');
                                                  break;
                                                case 3:
                                                  notifier.editTransactionDetail(
                                                      detail: detail,
                                                      partId: detail.partId,
                                                      rowId: detail.rowId,
                                                      employeId3: '');
                                                  break;
                                                case 4:
                                                  notifier.editTransactionDetail(
                                                      detail: detail,
                                                      partId: detail.partId,
                                                      rowId: detail.rowId,
                                                      employeId4: '');
                                                  break;
                                              }
                                              SmartDialog.dismiss();
                                              notifier.getTransactionDetail();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  terapisList[indexTerapis].name,
                                                  style: AppTextStyle.textSmStyle(),
                                                ),
                                                Icon(Icons.close, color: AppColor.blackColor),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    AppTypeahead2<EmployeeDAO>(
                                      label: "Terapis", 
                                      autofocus: true,
                                      updateFilterValue: (val) async {
                                        return val.isNotEmpty? await notifier.getEmployeeList(filter: val) : [];
                                      }, 
                                      onSelected: (val){
                                        if(terapisList.any((item)=> item.id == (val.empId))){
                                          return;
                                        }
                                        switch(terapisList.length){
                                          case 0:
                                            notifier.editTransactionDetail(
                                            detail: detail,
                                            partId: detail.partId,
                                            rowId: detail.rowId,
                                            employeId: val.empId
                                            );
                                          break;
                                          case 1:
                                            notifier.editTransactionDetail(
                                            detail: detail,
                                            partId: detail.partId,
                                            rowId: detail.rowId,
                                            employeId2: val.empId
                                            );
                                          break;
                                          case 2:
                                            notifier.editTransactionDetail(
                                            detail: detail,
                                            partId: detail.partId,
                                            rowId: detail.rowId,
                                            employeId3: val.empId
                                            );
                                          break;
                                          case 3:
                                            notifier.editTransactionDetail(
                                            detail: detail,
                                            partId: detail.partId,
                                            rowId: detail.rowId,
                                            employeId4: val.empId
                                            );
                                          break;
                                          case 4:
                                            notifier.editTransactionDetail(
                                            detail: detail,
                                            partId: detail.partId,
                                            rowId: detail.rowId,
                                            employeId4: val.empId
                                            );
                                          break;
                                        }
                                        notifier.getTransactionDetail();
                                        SmartDialog.dismiss();
                                      },
                                      displayWidget: (val){
                                        return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(val.fullName, style: AppTextStyle.textNStyle(),)
                                        ]);
                                      },
                                      onClear: (val){},
                                      emptyBuilder: (context){
                                        return SizedBox.shrink();
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                          },
                          child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: terapisList.isNotEmpty? 'Terapis' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.grey300),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.grey300),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColor.grey300),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          ),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (terapisList.isNotEmpty)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: List.generate(terapisList.length, (indexTerapis) {
                                      return IntrinsicWidth( 
                                        child: AppTextButton(
                                          borderColor: AppColor.transparentColor,
                                          backgroundColor: AppColor.grey100,
                                          foregroundColor: AppColor.blackColor,
                                          onPressed: () {
                                            switch (terapisList[indexTerapis].index) {
                                              case 1:
                                                notifier.editTransactionDetail(
                                                    detail: detail,
                                                    partId: detail.partId,
                                                    rowId: detail.rowId,
                                                    employeId: '');
                                                break;
                                              case 2:
                                                notifier.editTransactionDetail(
                                                    detail: detail,
                                                    partId: detail.partId,
                                                    rowId: detail.rowId,
                                                    employeId2: '');
                                                break;
                                              case 3:
                                                notifier.editTransactionDetail(
                                                    detail: detail,
                                                    partId: detail.partId,
                                                    rowId: detail.rowId,
                                                    employeId3: '');
                                                break;
                                              case 4:
                                                notifier.editTransactionDetail(
                                                    detail: detail,
                                                    partId: detail.partId,
                                                    rowId: detail.rowId,
                                                    employeId4: '');
                                                break;
                                            }
                                            notifier.getTransactionDetail();
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                terapisList[indexTerapis].name,
                                                style: AppTextStyle.textSmStyle(),
                                              ),
                                              Icon(Icons.close, color: AppColor.blackColor),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            if (terapisList.isEmpty)
                              Text("Terapis", style: AppTextStyle.textNStyle(color: AppColor.grey500)),
                            Icon(Icons.search, color: AppColor.grey500),
                          ],
                        )

                          ),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: AppTextField2(
                                context: context,
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                textEditingController: TextEditingController()..text = formatThousands(detail.price.toString()),
                                textAlign: TextAlign.right,
                                readOnly: true,//detail.isFixPrice,
                                labelText: "Harga",
                                disabled: state.transactionHeader.statusCategory != "PROGRESS",
                              )
                            ),
                            Expanded(
                              child: AppTextField2(
                                context: context,
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                textEditingController: TextEditingController()..text = formatThousands(detail.deductionVal.toString()),
                                labelText: "Diskon",
                                textAlign: TextAlign.right,
                                readOnly: true,
                                onTap: (){
                                  SmartDialog.show(builder: (scontext){
                                    final discountController = TextEditingController();
                                    return AppDialog2(
                                      title: Align(alignment: Alignment.topLeft, child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Ubah Diskon", style: AppTextStyle.textNStyle(fontWeight: FontWeight.bold),),
                                          Text("Ubah diskon untuk ${detail.partName}", style: AppTextStyle.textXsStyle(color: AppColor.grey500),)
                                        ])),
                                      child: AppTextField2(
                                        context: context,
                                        textEditingController: discountController..text = formatThousands(detail.deductionVal.toString()),
                                        textAlign: TextAlign.right,
                                        isThousand: true,
                                        inputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                      ),
                                      actions: [
                                        AppTextButton(
                                          onPressed: () async {
                                            await notifier.editTransactionDetail(
                                              detail: detail, 
                                              partId: detail.partId, 
                                              rowId: detail.rowId,
                                              deductionVal: unFormatThousands(discountController.text)
                                            );
                                            SmartDialog.dismiss();
                                            await notifier.initialize();
                                          }, 
                                          child: Text("Simpan", style: AppTextStyle.textNStyle(),),
                                        )
                                      ],
                                    );
                                  });
                                },
                                disabled: state.transactionHeader.statusCategory != "PROGRESS",
                              )
                            ),
                          ],
                        )
                        ])
                      ],
                    ),
                  );
                    }),
                  ),
                  
                ]
              )
            ))),
            if(!isKeyboardVisible && !state.isLoadingTransaction)
             Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                border: Border(top: BorderSide(color: AppColor.grey300))
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal: ", style: AppTextStyle.textNStyle(),),
                      Text("${formatToRupiah(state.transactionHeader.brutoVal)}", style: AppTextStyle.textNStyle(),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Diskon: ", style: AppTextStyle.textNStyle(),),
                      Text("${formatToRupiah(state.transactionHeader.discVal)}", style: AppTextStyle.textNStyle(),),
                    ],
                  ),
                  Divider(height: 0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: ", style: AppTextStyle.textMdStyle(),),
                      Text("${formatToRupiah(state.transactionHeader.nettoVal)}", style: AppTextStyle.textMdStyle(),),
                    ],
                  ),
                  IntrinsicHeight(
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Expanded(
                        child: AppTextButton(
                          size: AppTextButtonSize.big,
                          icon: Icons.people,
                          borderColor: AppColor.grey300,
                          foregroundColor: AppColor.blackColor,
                          onPressed: () async {
                            final antrianPdf = await notifier.generateQueuePDF();
                            if(context.mounted){
                              AppNavigator.navigatePush(context, AppPDFViewer(pdfDocument: antrianPdf,));
                            }
                          }, 
                          child: Text("Antrian", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
                        ),
                      ),
                      Expanded(
                        child: AppTextButton(
                          size: AppTextButtonSize.big,
                          icon: Icons.receipt,
                          borderColor: AppColor.grey300,
                          foregroundColor: AppColor.blackColor,
                          onPressed: () async {
                            final url = await notifier.printNota();
                            AppNavigator.navigatePush(context, AppPDFViewer(pdfUrl: url,));
                          }, 
                          child: Text("Nota", style: AppTextStyle.textNStyle(),)
                        ),
                      ),
                      if(state.transactionHeader.statusCategory=="PROGRESS")
                      PopupMenuButton<String>(
                      popUpAnimationStyle: AnimationStyle.noAnimation,
                      position: PopupMenuPosition.over,
                      offset: const Offset(0, -48),
                      color: AppColor.whiteColor,
                      onSelected: (value) {
                        if (value == 'edit') {
                          
                        } else if (value == 'delete') {
                          SmartDialog.show(builder: (scontext){
                            return AppDialog2(
                              title: Text("Batalkan transaksi?", style: AppTextStyle.textNStyle(),),
                              actions: [
                                AppTextButton(onPressed: (){
                                  SmartDialog.dismiss();
                                }, 
                                child: Text("Tidak", style: AppTextStyle.textNStyle(),)
                                ),
                                AppTextButton(onPressed: () async {
                                  await notifier.cancelTransaction();
                                  SmartDialog.dismiss();
                                  if(context.mounted){
                                    AppNavigator.navigatePushReplace(context, HomeScreen());
                                  }
                                }, 
                                child: Text("Ya", style: AppTextStyle.textNStyle(),)
                                ),
                              ],
                            );
                          });
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        // PopupMenuItem<String>(
                        //   value: 'edit',
                        //   child: Row(
                        //     spacing: 5,
                        //     children: [
                        //       Icon(Icons.discount_outlined),
                        //       Text('Diskon', style: AppTextStyle.textNStyle(),),
                        //     ]
                        //   ),
                        // ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(Icons.delete_outline),
                              Text('Batalkan', style: AppTextStyle.textNStyle(),),
                            ]
                          ),
                        ),
                      ],
                      child: SizedBox(
                        height: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColor.grey300),
                          ),
                          child: const Icon(Icons.more_horiz, size: 20),
                        ),
                      ),)
                    ],
                  )),
                  SizedBox(
                    width: double.maxFinite,
                    child: AppTextButton(
                      size: AppTextButtonSize.big,
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: AppColor.whiteColor,
                      disabled: 
                        state.transactionHeader.statusCategory != "PROGRESS" ||
                        state.transactionDetailList.isEmpty || 
                        state.transactionHeader.shiftId.isEmpty || 
                        state.transactionHeader.supplierName.isEmpty || 
                        state.transactionDetailList.any((item)=>(item.employeeId.isEmpty && item.employeeId2.isEmpty && item.employeeId3.isEmpty && item.employeeId4.isEmpty) && !item.isPacket),
                      onPressed: (){
                        AppNavigator.navigatePush(context, CheckoutScreen(
                          salesId: salesId, 
                          brutoVal: state.transactionHeader.brutoVal, 
                          discVal: state.transactionHeader.discVal, 
                          nettoVal: state.transactionHeader.nettoVal)
                        ).then((_){
                          if(context.mounted){
                            AppNavigator.navigateBack(context);
                          }
                        });
                      },
                      child: Text("Checkout", style: AppTextStyle.textNStyle(
                      fontWeight: FontWeight.bold
                    )),
                  )),
                  widget.mandatoryFieldError()
                ]
              )
            ),
            
          ]
        ),
        
      )
    );
  }
  
}