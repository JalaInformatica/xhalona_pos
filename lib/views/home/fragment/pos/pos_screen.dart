import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/utils/app_navigator.dart';
import 'package:xhalona_pos/views/home/fragment/pos/pos_widget.dart';
import 'package:xhalona_pos/views/home/fragment/pos/viewmodels/pos_viewmodel.dart';
import 'package:xhalona_pos/widgets/app_dropdown.dart';
import 'package:xhalona_pos/widgets/app_table_xs.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

import 'features/transaction/transaction_pos_screen.dart';

class PosScreen extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posViewModelProvider);
    final notifier = ref.read(posViewModelProvider.notifier);
    final posWidget = PosWidget(state: state, notifier: notifier, context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Text("Transaksi hari ini", style: AppTextStyle.textNStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),),
            posWidget.filterStatusCategoryWidget(),
            Flexible(
              child: posWidget.todayTransactionTable(),
            )
          ],
        )),
      floatingActionButton: posWidget.addTransactionButton()
    );
  }
}
