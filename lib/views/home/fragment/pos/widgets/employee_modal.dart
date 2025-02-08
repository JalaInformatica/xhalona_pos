import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/employee.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

// ignore: must_be_immutable
class EmployeeModal extends StatelessWidget {
  final EmployeeModalController controller = Get.put(EmployeeModalController());
  String? selectedEmpName;
  Timer? _debounce;
  Function(EmployeeDAO) onEmployeeSelected;

  EmployeeModal({
    super.key, 
    this.selectedEmpName,
    required this.onEmployeeSelected
  });

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      controller.fetchEmployees(filter: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        Text("Terapis", style: AppTextStyle.textSubtitleStyle(),),
        AppTextField(
          textEditingController: TextEditingController()..text=selectedEmpName ?? "",
          context: context,
          hintText: "Cari Terapis",
          onChanged: _onChanged,
          autofocus: true,
        ),
        Expanded(child: 
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: controller.employees.length,
            itemBuilder: (context, index) {
              EmployeeDAO employee = controller.employees[index];
              return AppTextButton(
                foregroundColor: AppColor.blackColor,
                backgroundColor: AppColor.tertiaryColor,
                borderColor: Colors.transparent,
                onPressed: () {
                  onEmployeeSelected(employee);
                },
                alignment: Alignment.centerLeft,
                child: Text(
                  employee.fullName,
                  style: AppTextStyle.textBodyStyle(),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 5.h,),
          )
        ),
      ],
    ));
  }
  
}