import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal_controller.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';

class MemberModal extends StatelessWidget{
  final MemberModalController controller = Get.put(MemberModalController());
  final _formkey = GlobalKey<FormState>();
  BuildContext memberContext;      
  Timer? _debounce;
  Function(KustomerDAO) onMemberSelected;

  MemberModal({
    super.key,
    required this.onMemberSelected,
    required this.memberContext
  });

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if(query.length>=2){
        controller.fetchMembers(filter: query);
      }
      else if(query.isEmpty){
        controller.members.clear();
      }
    });
  }

  TextEditingController memberNameController = TextEditingController(); 
  TextEditingController memberPhoneController = TextEditingController(); 
  TextEditingController memberEmailController = TextEditingController(); 
  TextEditingController memberAddressController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        // Text("Member", style: AppTextStyle.textSubtitleStyle(),),
        AppTextButton(
          onPressed: (){
            controller.isAddMember.value = !controller.isAddMember.value;
          }, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5.w,
            children: [
            Text(!controller.isAddMember.value? "Tambah Member" : "Cari Member", style: AppTextStyle.textBodyStyle(),),
            Icon(!controller.isAddMember.value? Icons.add : Icons.search, color: AppColor.primaryColor,)
          ],) 
        ),
        !controller.isAddMember.value?
        Expanded(child: Column(
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h,),
            Text("Daftar Member", style: AppTextStyle.textSubtitleStyle(),),
            AppTextField(
              context: context,
              hintText: "Cari",
              onChanged: _onChanged,
              autofocus: true,
              prefixIcon: Icon(Icons.search),
            ),
            Expanded(child: 
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: controller.members.length,
                itemBuilder: (context, index) {
                  KustomerDAO member = controller.members[index];
                  return AppTextButton(
                    foregroundColor: AppColor.blackColor,
                    onPressed: () {
                      onMemberSelected(member);
                    },
                    alignment: Alignment.centerLeft,
                    shape: BeveledRectangleBorder(
                      side: BorderSide(color: AppColor.grey100)
                    ),
                    child: Text(
                      member.suplierName,
                      style: AppTextStyle.textBodyStyle(),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 5.h,),
              )
            ),
          ],
        )):
        Expanded(child: Form(
      key: _formkey,
      child: Column(
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h,),
          Text("Member Baru", style: AppTextStyle.textSubtitleStyle(),),
          AppTextFormField(
            autofocus: true,
            textEditingController: memberNameController,
            context: memberContext, labelText: "Nama Member*",
            validator: (value) {
              if(value==''){
                return 'Nama Member Wajib diisi';
              }
              return null;
            },
          ),
          AppTextFormField(
            textEditingController: memberPhoneController,
            context: memberContext, labelText: "Nomor Handphone*",validator: (value) {
              if(value==''){
                return 'No. HP Member Wajib diisi';
              }
              return null;
            },
          ),
          AppTextFormField(
            textEditingController: memberEmailController,
            context: memberContext, labelText: "Email",),
          AppTextFormField(
            maxLines: 3,
            textEditingController: memberAddressController,
            context: memberContext, labelText: "Alamat",),
          Spacer(),
          SizedBox(
            width: double.maxFinite,
            child: AppElevatedButton(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: AppColor.whiteColor,
              onPressed: (){
                if(_formkey.currentState?.validate() ?? false){
                  controller.addMember(
                    KustomerDAO(
                      suplierId: memberPhoneController.text,
                      suplierName: memberNameController.text,
                      emailAdress: memberEmailController.text,
                      address1: memberAddressController.text
                    )
                  ).then(
                    onMemberSelected(
                      KustomerDAO(
                        suplierId: memberPhoneController.text,
                        suplierName: memberNameController.text,
                        emailAdress: memberEmailController.text,
                        address1: memberAddressController.text
                      )
                    )
                  );
                }
              }, 
              text: Text("Simpan")
            ),
          )

          ],
        )))
      ],
    ));
  }
}