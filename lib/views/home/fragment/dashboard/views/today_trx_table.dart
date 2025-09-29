import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xhalona_pos/core/helper/global_helper.dart';
import 'package:xhalona_pos/views/home/fragment/dashboard/states/dashboard_state.dart';
import 'package:xhalona_pos/widgets/app_table_xs.dart';

Widget renderTodayTrxTable({
  required DashboardState state,
}) {
  final transactions = state.todayTransaction.asData?.value ?? [];

  return AppTableXs(
    isPaginated: false,
    tableSize: TableSize.small,
    isLoading: state.todayTransaction.isLoading,
    columnDefs: [
      ColumnDef(
        field: 'trx',
        headerName: 'Trx',
        width: 60,
        textFormatter: (val) =>
            val.toString().substring(val.toString().length - 4),
      ),
      ColumnDef(
        field: 'pelanggan',
        headerName: 'Pelanggan',
        width: 100,
        alignment: ColumAlignment.left,
      ),
      ColumnDef(
          field: 'settle_payment_method', headerName: 'Pembayaran', width: 110),
      ColumnDef(
        field: 'payment_val',
        headerName: 'Total Bayar',
        width: 100,
        alignment: ColumAlignment.right,
        textFormatter: (val) => formatThousands(val.toString()),
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
        textFormatter: (val) => formatThousands(val.toString()),
      ),
    ],
    rowData: transactions.map((item) {
      return {
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
    }).toList()
  );
}
