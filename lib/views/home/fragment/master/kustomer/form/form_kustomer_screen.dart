import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kustomer.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/form/form_kustomer_controller.dart';
import 'package:xhalona_pos/views/home/fragment/master/kustomer/kustomer_controller.dart';
import 'package:xhalona_pos/views/home/home_screen.dart';
import 'package:xhalona_pos/widgets/app_bar_container.dart';
import 'package:xhalona_pos/widgets/app_bottombar.dart';
import 'package:xhalona_pos/widgets/app_form.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_input_formatter.dart';
import 'package:xhalona_pos/widgets/app_layout.dart';
import 'package:xhalona_pos/widgets/app_switch.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_text_form_field.dart';
import 'package:xhalona_pos/repositories/kustomer/kustomer_repository.dart';
import 'package:xhalona_pos/widgets/app_text_form_field2.dart';

class KustomerFormScreen extends StatelessWidget {
  final KustomerDAO? kustomer;
  KustomerFormScreen({super.key, this.kustomer});
  final _controller = Get.find<KustomerFormController>();
    
  @override
  Widget build(BuildContext context) {
    return AppLayout(children: [
      AppBarContainer(
        prefix: AppIconButton(
            foregroundColor: AppColor.whiteColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          "${kustomer==null? "Tambah":"Edit"} Kustomer",
          style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),
        ),
      ),
      Expanded(
        child: Obx(()=> AppFormLayout(
          onCancel: () {
            Navigator.of(context).pop();
          },
          onSubmit: () {
            _controller.handleAddEditKustomer();
            Navigator.of(context).pop();
          },
          fields: [
            if(kustomer!=null)
            AppTextField2(
              disabled: true,
              context: context,
              textEditingController: _controller.idController,
              labelText: "ID",
              inputAction: TextInputAction.next,
              errorText: _controller.errors["id"],
            ),
            // Field Nama
            AppTextField2(
              context: context,
              textEditingController: _controller.nameController,
              labelText: "Nama ",
              inputAction: TextInputAction.next,
              errorText: _controller.errors["name"],
            ),
            AppTextField2(
              context: context,
              textEditingController: _controller.telpController,
              labelText: "Telp",
              inputAction: TextInputAction.next,
              errorText: _controller.errors["telp"],
            ),
            AppTextField2(
              context: context,
              textEditingController: _controller.emailController,
              labelText: "Email",
              inputAction: TextInputAction.next,
            ),
            AppTextField2(
              maxLines: 3,
              context: context,
              textEditingController: _controller.addressController,
              labelText: "Alamat Lengkap",
              inputAction: TextInputAction.next,
            ),
            Row(
              spacing: 10.w,
              children: [
                Row(spacing: 5.w, children: [
                  Text("Hutang", style: AppTextStyle.textBodyStyle()),
                  Obx(() => AppSwitch(
                    value: _controller.isPayable.value,
                    onChanged: (val) => _controller.isPayable.value = val,
                  )),
                ]),
                Row(spacing: 5.w, children: [
                  Text("Komplimen", style: AppTextStyle.textBodyStyle()),
                  Obx(() => AppSwitch(
                    value: _controller.isCompliment.value,
                    onChanged: (val) => _controller.isCompliment.value = val,
                  )),
                ]),
              ],
            ),
          ],
        ),
      )),
    ]);
  }
}
