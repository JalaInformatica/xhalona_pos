import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_dialog.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/widgets/app_normal_button.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_widget.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_controller.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal.dart';
import 'package:xhalona_pos/views/home/fragment/pos/widgets/employee_modal_controller.dart';

class PosScreen extends StatelessWidget {
  final PosController controller = Get.put(PosController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  child: AppTextField(
                    context: context,
                    hintText: "Cari Produk",
                    onChanged: controller.updateProductFilterValue,
                  ),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchProducts(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                  controller.products.length,
                                  (index) {
                                    final product = controller.products[index];
                                    return GestureDetector(
                                        onTap: () {
                                          if (!controller
                                              .isAddingProductToTrx.value) {
                                            controller.addProductToTrx(product);
                                          }
                                        },
                                        child: Container(
                                          width: 115,
                                          height: 115,
                                          decoration: BoxDecoration(
                                            color: !controller
                                                        .isAddingProductToTrx
                                                        .value ||
                                                    controller
                                                            .selectedProductPartIdToTrx
                                                            .value ==
                                                        product.partId
                                                ? AppColor.tertiaryColor
                                                : AppColor.blackColor
                                                    .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Opacity(
                                                      opacity:
                                                          0.7, // Set opacity value here (0.0 to 1.0)
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://dreadnought.core-erp.com/XHALONA/${product.mainImage}",
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) {
                                                          // Shimmer effect when image is loading
                                                          return Shimmer
                                                              .fromColors(
                                                            baseColor: AppColor
                                                                .grey100,
                                                            highlightColor:
                                                                AppColor
                                                                    .grey200,
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              color: AppColor
                                                                  .grey300, // Color of the shimmer
                                                            ),
                                                          );
                                                        },
                                                        errorWidget: (context,
                                                            str, obj) {
                                                          return SvgPicture
                                                              .asset(
                                                            'assets/logo-only-pink.svg',
                                                            color: AppColor
                                                                .whiteColor,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ))),
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.w),
                                                      width: double.maxFinite,
                                                      color: AppColor.blackColor
                                                          .withOpacity(0.7),
                                                      child: Text(
                                                        product.partName,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTextStyle
                                                            .textBodyStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                color: AppColor
                                                                    .whiteColor),
                                                      )),
                                                  Container(
                                                      width: double.maxFinite,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: 5.w),
                                                      decoration: BoxDecoration(
                                                          color: AppColor
                                                              .whiteColor,
                                                          border: Border.all(
                                                              color: AppColor
                                                                  .primaryColor),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          5),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Text(
                                                        formatToRupiah(
                                                            product.unitPrice),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTextStyle
                                                            .textBodyStyle(
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible,
                                                                color: AppColor
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                              SizedBox(height: 115),
                            ],
                          ),
                        )
                      )
                    );
                  }
                }),
              ],
            ),
            Obx(()=> transaction(
              controller: controller, 
              onTerapisClicked: (String rowId){
                SmartDialog.show(
                  builder: (context) {
                  return AppDialog(
                    content: SizedBox(
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: EmployeeModal(
                        onEmployeeSelected: (selectedEmployee) {
                          controller.editTerapisOfTrx(rowId, selectedEmployee.empId);
                          SmartDialog.dismiss();
                        },
                      ),
                    ),
                  );
                }).then((_) => Get.delete<
                    EmployeeModalController>());
                }, 
                context: context,
                onCheckoutClicked: () async {
                  double a = 10, b = 20, c = 30, d = 40, e = 100;

                  TextEditingController aController = TextEditingController(text: a.toString());
                  TextEditingController bController = TextEditingController(text: b.toString());
                  TextEditingController cController = TextEditingController(text: c.toString());
                  TextEditingController dController = TextEditingController(text: d.toString());

                  void adjustValues(String variable, double newValue) {
                    Map<String, double> variables = {'a': a, 'b': b, 'c': c, 'd': d};
                    List<String> precedence = ['a', 'b', 'c', 'd'];
                    int index = precedence.indexOf(variable);
                    double difference = newValue - variables[variable]!;
                    variables[variable] = newValue;

                    if (difference > 0) {
                      // Increase logic
                      for (int i = index + 1; i < precedence.length; i++) {
                        String key = precedence[i];
                        if (variables[key]! >= difference) {
                          variables[key] = variables[key]! - difference;
                          difference = 0;
                          break;
                        } else {
                          difference -= variables[key]!;
                          variables[key] = 0;
                        }
                      }
                    } else if (difference < 0) {
                      // Decrease logic
                      difference = difference.abs();
                      for (int i = index - 1; i >= 0; i--) {
                        String key = precedence[i];
                        if (variables[key]! + difference <= e) {
                          variables[key] = variables[key]! + difference;
                          difference = 0;
                          break;
                        } else {
                          difference -= (e - variables[key]!);
                          variables[key] = e;
                        }
                      }
                    }

                    // If total > e, set others to 0
                    double total = variables.values.reduce((x, y) => x + y);
                    if (total > e) {
                      for (String key in precedence) {
                        variables[key] = (variables[key]! > e) ? e : 0;
                      }
                    }

                    a = variables['a']!;
                    b = variables['b']!;
                    c = variables['c']!;
                    d = variables['d']!;

                    // Update text fields
                    aController.text = a.toString();
                    bController.text = b.toString();
                    cController.text = c.toString();
                    dController.text = d.toString();
                  }

                  await SmartDialog.show(
                    builder: (_) => AlertDialog(
                      title: const Text("Adjust Values"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: aController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'a'),
                            onChanged: (value) {
                              double? newValue = double.tryParse(value);
                              if (newValue != null) adjustValues('a', newValue);
                            },
                          ),
                          TextField(
                            controller: bController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'b'),
                            onChanged: (value) {
                              double? newValue = double.tryParse(value);
                              if (newValue != null) adjustValues('b', newValue);
                            },
                          ),
                          TextField(
                            controller: cController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'c'),
                            onChanged: (value) {
                              double? newValue = double.tryParse(value);
                              if (newValue != null) adjustValues('c', newValue);
                            },
                          ),
                          TextField(
                            controller: dController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'd'),
                            onChanged: (value) {
                              double? newValue = double.tryParse(value);
                              if (newValue != null) adjustValues('d', newValue);
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => SmartDialog.dismiss(),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                }
              )
            )
          ]
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(() => !controller.isOpenTransaksi.value
            ? AppElevatedButton(
                onPressed: () {
                  controller.isOpenTransaksi.value = true;
                },
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                backgroundColor: AppColor.primaryColor,
                foregroundColor: AppColor.whiteColor,
                text: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5.w,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: AppColor.whiteColor,
                    ),
                    Text(
                      "Transaksi",
                      style: AppTextStyle.textSubtitleStyle(
                          color: AppColor.whiteColor),
                    ),
                  ],
                ))
            : SizedBox.shrink()));
  }
}
