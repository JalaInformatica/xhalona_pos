import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/full_screen_image.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// ignore: must_be_immutable
class AppTable extends StatefulWidget {
  final List<AppTableTitle> titles;
  final List<List<AppTableCell>> data;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final Function(String) onSearch;
  final Function(int) onChangePageRow;
  final Function(int) onChangePageNo;
  int pageNo;
  int pageRow;

  AppTable({
    super.key,
    required this.titles,
    required this.data,
    required this.onRefresh,
    required this.isRefreshing,
    required this.onSearch,
    required this.onChangePageRow,
    required this.onChangePageNo,
    this.pageNo = 1,
    this.pageRow = 10,
  });

  @override
  State<AppTable> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  final List<String> dropdownItems = [
    '10/page',
    '20/page',
    '50/page',
  ];

  void _onChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double totalColumnWidth = widget.titles.length * 100;
    double columnWidth = totalColumnWidth < screenWidth
        ? screenWidth / widget.titles.length
        : 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                  height: 42,
                  child: AppTextField(
                    context: context,
                    textEditingController: searchController,
                    hintText: "Cari",
                    onChanged: _onChanged,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(0),
                  )),
            ),
            // !widget.isRefreshing
            //     ? AppIconButton(
            //         backgroundColor: AppColor.doneColor,
            //         foregroundColor: AppColor.whiteColor,
            //         shape: CircleBorder(),
            //         onPressed: widget.onRefresh,
            //         icon: Icon(Icons.refresh))
            //     : Padding(
            //         padding: EdgeInsets.all(8),
            //         child: SizedBox(
            //             width: 24,
            //             height: 24,
            //             child: CircularProgressIndicator(
            //               color: AppColor.doneColor,
            //               strokeWidth: 4,
            //             ))),
          ],
        ),
        SizedBox(height: 5),
        !widget.isRefreshing
            ? Flexible(
                child: HorizontalDataTable(
                  leftHandSideColumnWidth: columnWidth,
                  rightHandSideColumnWidth:
                      columnWidth * (widget.titles.length - 1),
                  isFixedHeader: true,
                  headerWidgets: widget.titles
                      .map((title) => title.copyWithWidth(columnWidth))
                      .toList(),
                  leftSideItemBuilder: (context, index) {
                    return widget.data[index][0].copyWithWidth(columnWidth);
                  },
                  rightSideItemBuilder: (context, index) {
                    return Row(
                      children: widget.data[index]
                          .map<Widget>(
                            (cell) => cell.copyWithWidth(columnWidth),
                          )
                          .skip(1)
                          .toList(),
                    );
                  },
                  itemCount: widget.data.length,
                ),
              )
            : Flexible(child: _buildShimmerTable(columnWidth)),
        SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppIconButton(
              onPressed: () {
                widget.onChangePageNo(widget.pageNo - 1);
              },
              icon: Icon(Icons.arrow_back_ios_rounded),
            ),
            Container(
              width: 25,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Text(
                "${widget.pageNo}",
                style: AppTextStyle.textBodyStyle(),
                textAlign: TextAlign.center,
              ),
            ),
            AppIconButton(
              onPressed: () {
                widget.onChangePageNo(widget.pageNo + 1);
              },
              icon: Icon(Icons.arrow_forward_ios_rounded),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.grey500),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  value: "${widget.pageRow}/page",
                  onChanged: (String? newValue) {
                    widget.onChangePageRow(
                        int.parse((newValue ?? "10/page").split("/")[0]));
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isDense: true,
                  dropdownColor: AppColor.whiteColor,
                  items: dropdownItems
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTextStyle.textBodyStyle(),
                      ),
                    );
                  }).toList(),
                  elevation: 8,
                )),
          ],
        )
      ],
    );
  }

  Widget _buildShimmerTable(double columnWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: widget.titles.map((title) => title).toList()),
        SizedBox(height: 5),
        ...List.generate(
          2,
          (index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                  children: widget.titles.map((title) {
                return Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: title.copyWithWidth(columnWidth));
              }).toList()),
            );
          },
        ),
      ]),
    );
  }
}

class AppTableCell extends StatelessWidget {
  final int index;
  final String value;
  final String? imageUrl;
  final double width;
  final double height;
  final bool isOpenPOS;
  final bool isEdit;
  final bool isDelete;
  final bool isPaket;
  final bool isBahan;
  final bool isModalPaket;
  final bool isModalBahan;
  final bool showOptionsOnTap;
  final bool showImgTap;
  final bool isVarian;
  final bool isRejectReschedule;
  final bool isAccReschedule;
  final bool isPrint;
  final bool isStatusOnline;
  final bool isOnFinishStore;
  final bool isOnWorkingStore;
  final bool isCancelTrx;
  final bool isOnDestination;
  final bool isOnArrived;
  final bool isCheckout;
  final bool isModalRejectReschedule;
  final bool isModalAccReschedule;
  final bool isModalPrint;
  final bool isModalStatusOnline;
  final bool isModalOnFinishStore;
  final bool isModalOnWorkingStore;
  final bool isModalCancelTrx;
  final bool isModalOnDestination;
  final bool isModalOnArrived;
  final bool isModalCheckout;
  final bool isTrxMenu;
  final bool isPost;
  final VoidCallback? onArrived;
  final VoidCallback? onCheckout;
  final VoidCallback? onDestination;
  final VoidCallback? onCancelTrx;
  final VoidCallback? onWorkingStore;
  final VoidCallback? onFinishStore;
  final VoidCallback? onStatusOnline;
  final VoidCallback? onPrint;
  final VoidCallback? onRejectReschedule;
  final VoidCallback? onAccReschedule;
  final VoidCallback? onPOS;
  final VoidCallback? onBahan;
  final VoidCallback? onVarian;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPaket;

  AppTableCell({
    Key? key,
    required this.index,
    required this.value,
    this.imageUrl,
    this.width = 100,
    this.height = 40,
    this.isOpenPOS = false,
    this.isEdit = false,
    this.isDelete = false,
    this.isPaket = false,
    this.isBahan = false,
    this.isModalPaket = false,
    this.isModalBahan = false,
    this.isVarian = false,
    this.isAccReschedule = false,
    this.isCancelTrx = false,
    this.isOnArrived = false,
    this.isOnDestination = false,
    this.isOnFinishStore = false,
    this.isOnWorkingStore = false,
    this.isTrxMenu = false,
    this.isPost = false,
    this.isPrint = false,
    this.isCheckout = false,
    this.isRejectReschedule = false,
    this.isStatusOnline = false,
    this.isModalAccReschedule = false,
    this.isModalCancelTrx = false,
    this.isModalOnArrived = false,
    this.isModalOnDestination = false,
    this.isModalOnFinishStore = false,
    this.isModalOnWorkingStore = false,
    this.isModalPrint = false,
    this.isModalCheckout = false,
    this.isModalRejectReschedule = false,
    this.isModalStatusOnline = false,
    this.showOptionsOnTap = false,
    this.showImgTap = false,
    this.onAccReschedule,
    this.onPOS,
    this.onBahan,
    this.onCheckout,
    this.onVarian,
    this.onEdit,
    this.onDelete,
    this.onPaket,
    this.onCancelTrx,
    this.onArrived,
    this.onDestination,
    this.onFinishStore,
    this.onWorkingStore,
    this.onPrint,
    this.onRejectReschedule,
    this.onStatusOnline,
  }) : super(key: key);

  AppTableCell copyWithWidth(double newWidth) {
    return AppTableCell(
      index: index,
      value: value,
      imageUrl: imageUrl,
      width: newWidth,
      height: height,
      isOpenPOS: isOpenPOS,
      isEdit: isEdit,
      isDelete: isDelete,
      isPaket: isPaket,
      isBahan: isBahan,
      isTrxMenu: isTrxMenu,
      isModalPaket: isModalPaket,
      isModalBahan: isModalBahan,
      isVarian: isVarian,
      isAccReschedule: isAccReschedule,
      isCancelTrx: isCancelTrx,
      isCheckout: isCheckout,
      isPost: isPost,
      isOnArrived: isOnArrived,
      isOnDestination: isOnDestination,
      isOnFinishStore: isOnFinishStore,
      isOnWorkingStore: isOnWorkingStore,
      isPrint: isPrint,
      isRejectReschedule: isRejectReschedule,
      isStatusOnline: isStatusOnline,
      isModalAccReschedule: isModalAccReschedule,
      isModalCancelTrx: isModalCancelTrx,
      isModalCheckout: isModalCheckout,
      isModalOnArrived: isModalOnArrived,
      isModalOnDestination: isModalOnDestination,
      isModalOnFinishStore: isModalOnFinishStore,
      isModalOnWorkingStore: isModalOnWorkingStore,
      isModalPrint: isModalPrint,
      isModalRejectReschedule: isModalRejectReschedule,
      isModalStatusOnline: isModalStatusOnline,
      onAccReschedule: onAccReschedule,
      onArrived: onArrived,
      onCancelTrx: onCancelTrx,
      onCheckout: onCheckout,
      onDestination: onDestination,
      onFinishStore: onFinishStore,
      onPrint: onPrint,
      onRejectReschedule: onRejectReschedule,
      onStatusOnline: onStatusOnline,
      onWorkingStore: onWorkingStore,
      showOptionsOnTap: showOptionsOnTap,
      showImgTap: showImgTap,
      onBahan: onBahan,
      onVarian: onVarian,
      onEdit: onEdit,
      onDelete: onDelete,
      onPaket: onPaket,
      onPOS: onPOS,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        index % 2 == 0 ? Colors.white : Colors.grey.shade200;

    return GestureDetector(
      onTap: showOptionsOnTap
          ? () => _showOptions(context)
          : showImgTap
              ? () {
                  showFullScreenImage(
                    context,
                    imageUrl.toString(),
                  );
                }
              : null,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        color: backgroundColor,
        child: Stack(
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: width * 0.8,
                height: height * 0.8,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, color: Colors.grey, size: 24);
                },
              )
            else if (isPost)
              Checkbox(
                value: isPost,
                onChanged: (bool? newValue) {
                  // Tambahkan logika jika ada aksi saat checkbox diubah
                },
              )
            else
              Center(
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            if (isEdit ||
                isDelete ||
                isPaket ||
                isBahan ||
                isVarian ||
                isAccReschedule ||
                isCancelTrx ||
                isOnArrived ||
                isOnDestination ||
                isOnFinishStore ||
                isOnWorkingStore ||
                isCheckout ||
                isPrint ||
                isRejectReschedule ||
                isStatusOnline)
              Positioned(
                right: 0,
                top: 0,
                child: Wrap(
                  spacing: 2.0,
                  runSpacing: 2.0,
                  children: _buildIcons(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIcons() {
    return [
      if (isCheckout)
        (_buildIconContainer(
            icon: Icons.payment, // Ikon pembayaran
            color: AppColor.primaryColor,
            tooltip: 'Pembayaran/Checkout',
            onPressed: onCheckout,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isOnArrived)
        (_buildIconContainer(
            icon: Icons.location_on, // Ikon tiba di lokasi
            color: AppColor.primaryColor,
            tooltip: 'Tiba di Lokasi',
            onPressed: onArrived,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isOnDestination)
        (_buildIconContainer(
            icon: Icons.directions, // Ikon menuju lokasi
            color: AppColor.primaryColor,
            tooltip: 'Menuju Lokasi',
            onPressed: onDestination,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isCancelTrx)
        (_buildIconContainer(
            icon: Icons.cancel, // Ikon batal transaksi
            color: AppColor.primaryColor,
            tooltip: 'Membatalkan Transaksi',
            onPressed: onCancelTrx,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isOnWorkingStore)
        (_buildIconContainer(
            icon: Icons.hourglass_empty, // Ikon mengerjakan pesanan
            color: AppColor.primaryColor,
            tooltip: 'Kerjakan Pesanan',
            onPressed: onWorkingStore,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isOnFinishStore)
        (_buildIconContainer(
            icon: Icons.flag, // Ikon pesanan selesai
            color: AppColor.primaryColor,
            tooltip: 'Pesanan Selesai',
            onPressed: onFinishStore,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isStatusOnline)
        (_buildIconContainer(
            icon: Icons.check, // Ikon konfirmasi pesanan
            color: AppColor.primaryColor,
            tooltip: 'Konfirmasi Pesanan',
            onPressed: onStatusOnline,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isAccReschedule)
        (_buildIconContainer(
            icon: Icons.event_available, // Ikon setuju penjadwalan ulang
            color: AppColor.primaryColor,
            tooltip: 'Setujui Penjadwalan Ulang',
            onPressed: onAccReschedule,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isRejectReschedule)
        (_buildIconContainer(
            icon: Icons.event_busy, // Ikon tolak penjadwalan ulang
            color: AppColor.primaryColor,
            tooltip: 'Tolak Penjadwalan Ulang',
            onPressed: onRejectReschedule,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isPrint)
        (_buildIconContainer(
            icon: Icons.print, // Ikon cetak tetap sama
            color: AppColor.primaryColor,
            tooltip: 'Print',
            onPressed: onPrint,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isOpenPOS)
        (_buildIconContainer(
            icon: Icons.open_in_new,
            color: AppColor.primaryColor,
            tooltip: 'Buka di POS',
            onPressed: onPOS,
            backgroundColor: AppColor.primaryColor.withAlpha(100))),
      if (isEdit)
        _buildIconContainer(
          icon: Icons.edit,
          color: Colors.blue,
          tooltip: 'Edit',
          onPressed: onEdit,
          backgroundColor: Colors.blue.withOpacity(0.1),
        ),
      if (isDelete)
        _buildIconContainer(
          icon: Icons.delete,
          color: Colors.red,
          tooltip: 'Delete',
          onPressed: onDelete,
          backgroundColor: Colors.red.withOpacity(0.1),
        ),
      if (isPaket)
        _buildIconContainer(
          icon: Icons.local_offer,
          color: Colors.green,
          tooltip: 'Paket',
          onPressed: onPaket,
          backgroundColor: Colors.green.withOpacity(0.1),
        ),
      if (isBahan)
        _buildIconContainer(
          icon: Icons.kitchen,
          color: Colors.green,
          tooltip: 'Bahan',
          onPressed: onBahan,
          backgroundColor: Colors.green.withOpacity(0.1),
        ),
      if (isVarian)
        _buildIconContainer(
          icon: Icons.arrow_circle_right_outlined,
          color: Colors.green,
          tooltip: 'Varian',
          onPressed: onVarian,
          backgroundColor: Colors.green.withOpacity(0.1),
        ),
    ];
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback? onPressed,
    required Color backgroundColor,
  }) {
    return Container(
      width: 35, // Ukuran container diperkecil
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 15), // Ukuran ikon diperkecil
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero, // Mengurangi padding bawaan IconButton
        constraints:
            const BoxConstraints(), // Menghindari ukuran default yang lebih besar
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        // Mengumpulkan semua opsi yang akan ditampilkan
        List<Widget> options = [];

        if (isTrxMenu) {
          options.add(_buildBottomSheetOption(
            icon: Icons.open_in_new,
            text: 'Buka di POS',
            onTap: () {
              Navigator.pop(context);
              if (onPOS != null) onPOS!();
            },
          ));
        }
        options.add(_buildBottomSheetOption(
          icon: Icons.edit,
          text: 'Edit',
          onTap: () {
            Navigator.pop(context);
            if (onEdit != null) onEdit!();
          },
        ));
        options.add(_buildBottomSheetOption(
          icon: Icons.delete,
          text: 'Delete',
          color: Colors.red,
          onTap: () {
            Navigator.pop(context);
            if (onDelete != null) onDelete!();
          },
        ));
        if (isModalPaket) {
          options.add(_buildBottomSheetOption(
            icon: Icons.local_offer,
            text: 'Paket',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              if (onPaket != null) onPaket!();
            },
          ));
        }
        if (isModalBahan) {
          options.add(_buildBottomSheetOption(
            icon: Icons.kitchen,
            text: 'Bahan',
            color: Colors.green,
            onTap: () {
              Navigator.pop(context);
              if (onBahan != null) onBahan!();
            },
          ));
        }
        if (isModalCheckout) {
          options.add(_buildBottomSheetOption(
            icon: Icons.payment,
            text: 'Pembayaran/Checkout',
            onTap: () {
              Navigator.pop(context);
              if (onCheckout != null) onCheckout!();
            },
          ));
        }
        if (isModalOnArrived) {
          options.add(_buildBottomSheetOption(
            icon: Icons.location_on,
            text: 'Tiba di Lokasi',
            onTap: () {
              Navigator.pop(context);
              if (onArrived != null) onArrived!();
            },
          ));
        }
        if (isModalOnDestination) {
          options.add(_buildBottomSheetOption(
            icon: Icons.directions,
            text: 'Menuju Lokasi',
            onTap: () {
              Navigator.pop(context);
              if (onDestination != null) onDestination!();
            },
          ));
        }
        if (isModalCancelTrx) {
          options.add(_buildBottomSheetOption(
            icon: Icons.cancel,
            text: 'Membatalkan Transaksi',
            onTap: () {
              Navigator.pop(context);
              if (onCancelTrx != null) onCancelTrx!();
            },
          ));
        }
        if (isModalOnWorkingStore) {
          options.add(_buildBottomSheetOption(
            icon: Icons.hourglass_empty,
            text: 'Kerjakan Pesanan',
            onTap: () {
              Navigator.pop(context);
              if (onWorkingStore != null) onWorkingStore!();
            },
          ));
        }
        if (isModalOnFinishStore) {
          options.add(_buildBottomSheetOption(
            icon: Icons.flag,
            text: 'Pesanan Selesai',
            onTap: () {
              Navigator.pop(context);
              if (onFinishStore != null) onFinishStore!();
            },
          ));
        }
        if (isModalStatusOnline) {
          options.add(_buildBottomSheetOption(
            icon: Icons.check,
            text: 'Konfirmasi Pesanan',
            onTap: () {
              Navigator.pop(context);
              if (onStatusOnline != null) onStatusOnline!();
            },
          ));
        }
        if (isModalAccReschedule) {
          options.add(_buildBottomSheetOption(
            icon: Icons.event_available,
            text: 'Setujui Penjadwalan Ulang',
            onTap: () {
              Navigator.pop(context);
              if (onAccReschedule != null) onAccReschedule!();
            },
          ));
        }
        if (isModalRejectReschedule) {
          options.add(_buildBottomSheetOption(
            icon: Icons.event_busy,
            text: 'Tolak Penjadwalan Ulang',
            onTap: () {
              Navigator.pop(context);
              if (onRejectReschedule != null) onRejectReschedule!();
            },
          ));
        }
        if (isModalPrint) {
          options.add(_buildBottomSheetOption(
            icon: Icons.print,
            text: 'Print Nota',
            onTap: () {
              Navigator.pop(context);
              if (onPrint != null) onPrint!();
            },
          ));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: options.length > 5
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    Color color = Colors.blue,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}

class AppTableTitle extends StatelessWidget {
  final String value;
  final double width;
  final double height;

  AppTableTitle(
      {Key? key, required this.value, this.width = 100, this.height = 35})
      : super(key: key);

  AppTableTitle copyWithWidth(double newWidth) {
    return AppTableTitle(value: value, width: newWidth, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: AppColor.primaryColor,
      child: Text(
        value,
        style: AppTextStyle.textSubtitleStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

String formatCurrency(num? amount,
    {String locale = 'id_ID', String symbol = 'Rp'}) {
  if (amount == null || amount == 0) return '0';
  final format =
      NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);
  return format.format(amount);
}
