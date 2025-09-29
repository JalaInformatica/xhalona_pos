import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/response/kustomer.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/member_modal_controller.dart';

// ignore: must_be_immutable
class MemberModal extends StatelessWidget {
  final MemberModalController controller = Get.put(MemberModalController());
  // BuildContext context;
  Timer? _debounce;
  Function(KustomerDAO) onMemberSelected;

  MemberModal({
    super.key,
    required this.onMemberSelected,
    // required this.context
  });

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (query.length >= 2) {
        controller.fetchMembers(filter: query);
      } else if (query.isEmpty) {
        controller.members.clear();
      }
    });
  }

  TextEditingController searchController = TextEditingController();

  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberPhoneController = TextEditingController();
  TextEditingController memberEmailController = TextEditingController();
  TextEditingController memberAddressController = TextEditingController();

  bool validateFormMember() {
    controller.errors.clear();
    if (memberNameController.text.isEmpty) {
      controller.errors['name'] = "Nama Member Wajib diisi";
    }
    if (memberPhoneController.text.isEmpty) {
      controller.errors['phone'] = "No. HP Member Wajib diisi";
    }
    if (controller.errors.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 5.h,
          children: [
            AppTextButton(
                onPressed: () {
                  controller.isAddMember.value = !controller.isAddMember.value;
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.w,
                  children: [
                    Text(
                      !controller.isAddMember.value
                          ? "Tambah Member"
                          : "Cari Member",
                      style: AppTextStyle.textBodyStyle(),
                    ),
                    Icon(
                      !controller.isAddMember.value ? Icons.add : Icons.search,
                      color: AppColor.primaryColor,
                    )
                  ],
                )),
            !controller.isAddMember.value
                ? Expanded(
                    child: Column(
                    spacing: 5.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Daftar Member",
                        style: AppTextStyle.textSubtitleStyle(),
                      ),
                      AppTextField(
                        textEditingController: searchController,
                        context: context,
                        hintText: "Cari",
                        onChanged: _onChanged,
                        autofocus: true,
                        prefixIcon: Icon(Icons.search),
                      ),
                      controller.members.isNotEmpty
                          ? Expanded(
                              child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: controller.members.length,
                              itemBuilder: (context, index) {
                                KustomerDAO member = controller.members[index];
                                return AppTextButton(
                                  foregroundColor: AppColor.blackColor,
                                  backgroundColor: AppColor.tertiaryColor,
                                  borderColor: Colors.transparent,
                                  onPressed: () {
                                    onMemberSelected(member);
                                  },
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    member.suplierName,
                                    style: AppTextStyle.textBodyStyle(),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: 5.h,
                              ),
                            ))
                          : Text("*Gunakan Nama Member Yang Sesuai", style: AppTextStyle.textBodyStyle(color: AppColor.dangerColor),),
                    ],
                  ))
                : Expanded(
                    child: Column(
                    spacing: 5.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Member Baru",
                        style: AppTextStyle.textSubtitleStyle(),
                      ),
                      AppTextField(
                        unfocusWhenTapOutside: false,
                        textEditingController: memberNameController,
                        context: context,
                        labelText: "Nama Member*",
                        inputAction: TextInputAction.next,
                      ),
                      if (controller.errors['name'] != null)
                        Text(
                          "Nama Member wajib diisi",
                          style: AppTextStyle.textBodyStyle(
                              color: AppColor.dangerColor),
                        ),
                      AppTextField(
                        unfocusWhenTapOutside: false,
                        textEditingController: memberPhoneController,
                        inputAction: TextInputAction.next,
                        context: context,
                        labelText: "Nomor Handphone*",
                      ),
                      if (controller.errors['phone'] != null)
                        Text(
                          "No. HP wajib diisi",
                          style: AppTextStyle.textBodyStyle(
                              color: AppColor.dangerColor),
                        ),
                      AppTextField(
                        unfocusWhenTapOutside: false,
                        textEditingController: memberEmailController,
                        inputAction: TextInputAction.next,
                        context: context,
                        labelText: "Email",
                      ),
                      AppTextField(
                        unfocusWhenTapOutside: false,
                        maxLines: 3,
                        textEditingController: memberAddressController,
                        inputAction: TextInputAction.done,
                        context: context,
                        labelText: "Alamat",
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: AppElevatedButton(
                            backgroundColor: AppColor.primaryColor,
                            foregroundColor: AppColor.whiteColor,
                            onPressed: () {
                              if (validateFormMember()) {
                                controller
                                    .addMember(KustomerDAO(
                                        suplierId: memberPhoneController.text,
                                        suplierName: memberNameController.text,
                                        telp: memberPhoneController.text,
                                        emailAdress: memberEmailController.text,
                                        address1: memberAddressController.text))
                                    .then((val) {
                                  if (val) {
                                    onMemberSelected(KustomerDAO(
                                        suplierId: memberPhoneController.text,
                                        suplierName: memberNameController.text,
                                        emailAdress: memberEmailController.text,
                                        address1:
                                            memberAddressController.text));
                                  }
                                });
                              }
                            },
                            child: Text("Simpan")),
                      )
                    ],
                  ))
          ],
        ));
  }
}
