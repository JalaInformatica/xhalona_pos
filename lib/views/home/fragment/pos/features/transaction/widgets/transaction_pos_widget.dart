import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:intl/intl.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/models/response/shift.dart';
import 'package:xhalona_pos/widgets/app_dialog2.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_text_form_field2.dart';
import 'package:xhalona_pos/widgets/app_typeahead2.dart';

import '../state/transaction_pos_state.dart';
import '../viewmodel/transaction_pos_viewmodel.dart';

class TransactionPosWidget {
  final TransactionPosState state;
  final TransactionPosViewmodel notifier;

  TransactionPosWidget(
      {required this.state, required this.notifier});

  Widget mandatoryFieldError(){
    List<String> mandatoryField = [];
    if(state.transactionHeader.shiftId.isEmpty){
      mandatoryField.add("shift");
    }
    if(state.transactionDetailList.isEmpty){
      mandatoryField.add("layanan");
    }
    if(state.transactionHeader.supplierName.isEmpty){
      mandatoryField.add("pelanggan");
    }
    if(state.transactionDetailList.isNotEmpty && state.transactionDetailList.any((item)=>(item.employeeId.isEmpty && item.employeeId2.isEmpty && item.employeeId3.isEmpty && item.employeeId4.isEmpty)  && !item.isPacket)){
      mandatoryField.add("terapis");
    }
    if(mandatoryField.isNotEmpty){
      return Text("Informasi ${mandatoryField.join(", ")} wajib diisi", style: AppTextStyle.textXsStyle(color: AppColor.dangerColor),);
    }
    return SizedBox.shrink();
  }

  Widget shiftContainer(){
    final isEditing = useState(false);

    return !isEditing.value || state.transactionHeader.statusCategory != "PROGRESS"? AppTextButton(
      backgroundColor: AppColor.tertiaryColor,
      foregroundColor: AppColor.primaryColor,
      onPressed: (){
        isEditing.value = true;
      },
      child: Text("Shift: ${state.transactionHeader.shiftId.isNotEmpty? state.transactionHeader.shiftId : "-"}", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),),
    ) : AppTypeahead2<ShiftDAO>(
      label: "Shift", 
      autofocus: true,
      displayWidget: (val)=>Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val.shiftId, style: AppTextStyle.textNStyle(),),
          Text("${DateFormat("hh:mm").format(DateTime.parse(val.timeStart))} - ${DateFormat("hh:mm").format(DateTime.parse(val.timeEnd))}", style: AppTextStyle.textSmStyle(
            color: AppColor.grey800
          ),),
        ],
      ),
      onSelected: (val) async {
        await notifier.editTransactionHeader(
          shiftId: val.shiftId
        );
        await notifier.getTransaction();
      },
      updateFilterValue: (val) async {
        return await notifier.getShifts(filterValue: val);
      }, 
      onTapOutside: (){
        isEditing.value = false;
      },
      onClear: (val)=>{}
    );
  }

  Future<void> showMemberDialog() async {
    SmartDialog.show(builder: (context){
      TextEditingController memberNameController = TextEditingController();
      TextEditingController memberPhoneController = TextEditingController();
      TextEditingController memberEmailController = TextEditingController();
      TextEditingController memberAddressController = TextEditingController();
      
      return AppDialog2(
        title: Text("Member Baru"),
        child: Flexible(
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
          children: [
          AppTextField2(
            unfocusWhenTapOutside: false,
            textEditingController: memberNameController,
            context: context,
            autofocus: true,
            labelText: "Nama Member*",
            inputAction: TextInputAction.next,
          ),
          AppTextField2(
            unfocusWhenTapOutside: false,
            textEditingController: memberPhoneController,
            inputAction: TextInputAction.next,
            context: context,
            labelText: "Nomor Handphone*",
          ),
          AppTextField2(
            unfocusWhenTapOutside: false,
            textEditingController: memberEmailController,
            inputAction: TextInputAction.next,
            context: context,
            labelText: "Email",
          ),
          AppTextField2(
            unfocusWhenTapOutside: false,
            maxLines: 3,
            textEditingController: memberAddressController,
            inputAction: TextInputAction.done,
            context: context,
            labelText: "Alamat",
          ),
          SizedBox(
            width: double.infinity,
            child: AppTextButton(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: AppColor.whiteColor,
              onPressed: () async {
                if(memberPhoneController.text.isNotEmpty && memberNameController.text.isNotEmpty){
                  await notifier.addCustomer(customer: KustomerDAO(
                    telp: memberPhoneController.text,
                    suplierName: memberNameController.text,
                    emailAdress: memberEmailController.text,
                    address1: memberAddressController.text,
                  ));
                  await notifier.editTransactionHeader(
                    suplierId: memberPhoneController.text,
                    guestName: '',
                    guestPhone: ''
                  );
                  SmartDialog.dismiss();
                  await notifier.getTransaction();
                }
              }, 
              child: Text("Simpan")
            )
          )
        ],),
      )));
    });
  }

  Widget memberAppTypeAhead(){
    final isEditing = useState(false);
    return (!isEditing.value && state.transactionHeader.supplierId.isNotEmpty) ? ListTile(
      onTap: () {
        if(state.transactionHeader.statusCategory == "PROGRESS"){
          isEditing.value = true;
        }
      }, 
      dense: true,
      isThreeLine: false,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.grey300),
        borderRadius: BorderRadius.circular(5),
      ),
      title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0, 
          children: [
            Text("${state.transactionHeader.supplierName}", style: AppTextStyle.textSmStyle(fontWeight: FontWeight.w500),),
            Text("${state.transactionHeader.telp}", style: AppTextStyle.textXsStyle(),),
        ]),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.primaryColor),            
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text("Ubah", style: AppTextStyle.textSmStyle(color: AppColor.primaryColor),),
        )
    ])) : AppTypeahead2<KustomerDAO>(
        label: 'Pelanggan', 
        controller: notifier.customerController,
        onSelected: (val) async {
          if(state.customerType==CustomerType.member){
            await notifier.editTransactionHeader(suplierId: val.suplierId);
          }
          notifier.getTransaction();
        }, 
        customSuffixIcon: AppTextButton(
          padding: EdgeInsets.zero,
          borderColor: AppColor.transparentColor,
          backgroundColor: AppColor.transparentColor,
          onPressed: (){
            showMemberDialog();
          }, 
          child: Text("Baru", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),),),
        autofocus: true,
        debounceDuration: Duration(seconds: 1),
        updateFilterValue: (val) async {
          return val.isNotEmpty? await notifier.getMemberList(filter: val) : [];
        }, 
        displayWidget: (val)=> Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${val.suplierName}", style: AppTextStyle.textNStyle(),),
                Text("${val.telp}", style: AppTextStyle.textSmStyle(color: AppColor.grey500),)
              ],
            ),
          ],), 
        onTapOutside: ()=>isEditing.value = false,
        onClear: (val) async {
          if(val){
            notifier.customerController.clear();
          }
        },
        emptyBuilder: (context){
          if(notifier.customerController.text.isEmpty){
            return SizedBox.shrink();
          }
          return ListTile(
            title: AppTextButton(
              borderColor: AppColor.grey300,
              foregroundColor: AppColor.grey800,
              onPressed: (){
              showMemberDialog();
            }, child: Text("Tambah ${notifier.customerController.text}")),
          );
        },
      );
  }

  Widget guestAppTypeAhead(BuildContext context){
    final isEditing = useState(false);
    if(!isEditing.value && state.transactionHeader.guestPhone.isNotEmpty){
      return ListTile(
        onTap: () {
          if(state.transactionHeader.statusCategory == "PROGRESS"){
            isEditing.value = true;
          }
        }, 
        dense: true,
        isThreeLine: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.grey300),
          borderRadius: BorderRadius.circular(5),
        ),
        title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 0, 
            children: [
              Text("${state.transactionHeader.supplierName}", style: AppTextStyle.textSmStyle(fontWeight: FontWeight.w500),),
              Text("${state.transactionHeader.telp}", style: AppTextStyle.textXsStyle(),),
          ]),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.primaryColor),            
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text("Ubah", style: AppTextStyle.textSmStyle(color: AppColor.primaryColor),),
          )
      ]));
    }
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppTextField2(
          labelText: 'No HP',
          context: context,
          textEditingController: notifier.guestPhoneController,
          autofocus: true,
        ),
        AppTextField2(
          labelText: 'Nama',
          context: context,
          textEditingController: notifier.guestNameController,
        ),
        AppTextButton(
          onPressed: () async{
            if(notifier.guestNameController.text.isNotEmpty &&
            notifier.guestPhoneController.text.isNotEmpty){
              await notifier.editTransactionHeader(
                  guestPhone: notifier.guestPhoneController.text,
                  guestName: notifier.guestNameController.text
              );
              await notifier.getTransaction();
            }
          }, 
          child: Text("Simpan")
        )
      ]
    );
  }
  
}
