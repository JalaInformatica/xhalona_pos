import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/core/utils/app_navigator.dart';
import 'package:xhalona_pos/views/home/fragment/pos/features/transaction/transaction_pos_screen.dart';
import 'package:xhalona_pos/widgets/app_dropdown.dart' as t;
import 'package:xhalona_pos/widgets/app_loading_indicator.dart';
import 'package:xhalona_pos/widgets/app_table_xs.dart';
import 'states/pos_state.dart';
import 'viewmodels/pos_viewmodel.dart';

class PosWidget {
  final PosState state;
  final PosViewmodel notifier;
  final BuildContext context;

  PosWidget({
    required this.state,
    required this.notifier,
    required this.context
  });

  Widget filterStatusCategoryWidget(){
    return Row(
      spacing: 5,
      children: [ 
        Text("Status:", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),),
        t.AppTextDropdown(
        value: state.filterTransactionCategory, 
        backgroundColor: AppColor.tertiaryColor,
        borderColor: AppColor.primaryColor,
        items: [
          DropdownMenuItem(
            value: "",
            child: Text("Semua", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
          ),
          DropdownMenuItem(
            value: "PROGRESS",
            child: Text("Berjalan", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
          ),
          DropdownMenuItem(
            value: "FINISH",
            child: Text("Berhasil", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
          ),
          DropdownMenuItem(
            value: "CANCEL",
            child: Text("Batal", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
          ),
          DropdownMenuItem(
            value: "RESCHEDULE",
            child: Text("Penjadwalan Ulang", style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),)
          ),
        ], 
        onChanged: (val){
          notifier.setFilterStatusCategory(filterStatusCategory: val!);
        }
      )]
    );
  }

  Widget todayTransactionTable(){
    return AppTableXs(
      isLoading: state.isLoadingTodayTransaction,
      isPaginated: true,
      pageNo: state.pageNo,
      onPageNoChanged: (val){
        notifier.onPageNoChanged(val);
      },
      onPageRowChanged: (val){
        notifier.onPageRowChanged(val);
      },
      columnDefs: [
        ColumnDef(
          field: 'trx', 
          headerName: 'Trx', 
          width: 60,
          textFormatter: (val)=>val.toString().substring(val.toString().length-4)
        ),
        ColumnDef(
          field: 'pelanggan', 
          headerName: 'Pelanggan', 
          width: 100, 
          alignment: ColumAlignment.left
        ),
        ColumnDef(field: 'settle_payment_method', headerName: 'Pembayaran', width: 110),
        ColumnDef(
          field: 'payment_val', 
          headerName: 'Total Bayar', 
          width: 100,
          alignment: ColumAlignment.right,
          textFormatter: (val)=>formatThousands(val.toString())
        ),
        ColumnDef(field: 'queue', headerName: 'Antrian', width: 90),
        ColumnDef(field: 'create_by', headerName: 'Kasir', width: 90),
        ColumnDef(field: 'status', headerName: 'Status', width: 90),
        ColumnDef(field: 'keterangan', headerName: 'Keterangan', width: 90),
        ColumnDef(
          field: 'total', 
          headerName: 'Total', 
          width: 90, 
          alignment: ColumAlignment.right,
          textFormatter: (val)=>formatThousands(val.toString())
        ),
        // ColumnDef(field: 'aksi', headerName: 'Aksi', width: 60,),
      ],
      onRowClicked: (transaction){
        AppNavigator.navigatePush(context, TransactionPosScreen(salesId: transaction['trx'])).then((_)=>notifier.initialize());
      },
      rowData: state.todayTransaction.map((item){
        return 
          {
            'trx': item.salesId,
            'pelanggan': item.supplierName,
            'settle_payment_method': item.settlePaymentMethod,
            'payment_val': item.paymentVal,
            'queue': item.queueNumber,
            'create_by': item.createBy,
            'status': item.sourceId,
            'keterangan': item.statusDesc,
            'total': item.nettoVal,
          };
        }).toList(),
        footerDefs: [
          FooterDef(
            field: 'trx',
            value: 'Total', 
          ),
          FooterDef(
            field: 'payment_val',
            value: formatThousands(state.todayTransaction.fold(0, (sum, c)=>sum+c.paymentVal).toString()),
            columAlignment: ColumAlignment.right
          ),
          FooterDef(
            field: 'total',
            value: formatThousands(state.todayTransaction.fold(0, (sum, c)=>sum+c.nettoVal).toString()),
          ),
        ],
    );
  }

  Widget addTransactionButton(){
    final isLoading = useState(false);
    return FloatingActionButton(
      backgroundColor: AppColor.primaryColor,
      foregroundColor: AppColor.whiteColor,
      child: !isLoading.value ? Icon(Icons.add) : AppLoadingIndicator(color: AppColor.whiteColor,),
      onPressed: () async {
        isLoading.value = true;
        String salesId = await notifier.createTransaction();
        isLoading.value = false;
        
        if (salesId.isNotEmpty && context.mounted) {
          AppNavigator.navigatePush(
            context,
            TransactionPosScreen(salesId: salesId),
          ).then((_) async {
            await notifier.initialize();
          });
        }
      },
    );
  }
}