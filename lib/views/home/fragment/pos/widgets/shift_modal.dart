import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/shift.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/shift_modal_controller.dart';

// ignore: must_be_immutable
class ShiftModal extends StatelessWidget {
  final ShiftModalController controller = Get.put(ShiftModalController());
  // Timer? _debounce;
  Function(ShiftDAO) onShiftSelected;

  ShiftModal({super.key, required this.onShiftSelected});

  // void _onChanged(String query) {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(seconds: 1), () {
  //     controller.fetchEmployees(filter: query);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5.h,
          children: [
            Text(
              "Shift",
              style: AppTextStyle.textSubtitleStyle(),
            ),
            // AppTextField(
            //   context: context,
            //   hintText: "Cari Terapis",
            //   onChanged: _onChanged,
            //   autofocus: true,
            // ),
            Expanded(
                child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.shifts.length,
              itemBuilder: (context, index) {
                ShiftDAO shift = controller.shifts[index];
                return AppTextButton(
                  foregroundColor: AppColor.blackColor,
                  onPressed: () {
                    onShiftSelected(shift);
                  },
                  alignment: Alignment.centerLeft,
                  child: Text(
                    shift.shiftName,
                    style: AppTextStyle.textBodyStyle(),
                  ),
                  shape: BeveledRectangleBorder(
                      side: BorderSide(color: AppColor.grey100)),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 5.h,
              ),
            )),
          ],
        ));
  }
}
