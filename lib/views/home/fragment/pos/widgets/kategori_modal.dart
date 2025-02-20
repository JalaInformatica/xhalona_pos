import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/models/dao/kategori.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/kategori_modal_controller.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class KategoriModal extends StatelessWidget{
  final KategoriModalController controller = Get.put(KategoriModalController());
  String? selectedKategori;
  Timer? _debounce;
  Function(KategoriDAO) onKategoriSelected;

  KategoriModal({
    super.key,
    this.selectedKategori,
    required this.onKategoriSelected
  });

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      controller.fetchCategories(filter: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.h,
      children: [
        Text("Kategori", style: AppTextStyle.textSubtitleStyle(),),
        AppTextField(
          context: context,
          hintText: "Cari Kategori",
          onChanged: _onChanged,
          autofocus: true,
        ),
        Expanded(child: 
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              KategoriDAO kategori = controller.categories[index];
              return AppTextButton(
                foregroundColor: kategori.analisaId != selectedKategori? AppColor.blackColor : AppColor.whiteColor,
                backgroundColor: kategori.analisaId != selectedKategori? AppColor.tertiaryColor : AppColor.primaryColor,
                borderColor: Colors.transparent,
                onPressed: () {
                  onKategoriSelected(kategori);
                },
                alignment: Alignment.centerLeft,
                child: Text(
                  kategori.ketAnalisa,
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