import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';

class PosScreen extends StatelessWidget {
  final PosController controller = Get.put(PosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.whiteColor,
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari Produk",
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10, // Adjust spacing as per your design
                        runSpacing: 10,
                        children: List.generate(
                          controller.products.length,
                          (index) {
                            final product = controller.products[index];
                            return Container(
                              width: 115,
                              height: 115,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.grey200,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    "https://dreadnought.core-erp.com/XHALONA/${product.mainImage}",
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, object, stackTrace) {
                                      return SvgPicture.asset(
                                        'assets/logo-only-pink.svg',
                                        color: AppColor.grey300,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.partName,
                                        style: AppTextStyle.textBodyStyle(
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                      Text(
                                        formatToRupiah(product.unitPrice),
                                        style: AppTextStyle.textBodyStyle(
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 115),
                    ],
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
