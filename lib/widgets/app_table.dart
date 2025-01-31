import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

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
  final bool isEdit;
  final bool isDelete;
  final bool isPaket;
  final bool isBahan;
  final bool isVarian;
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
    this.isEdit = false,
    this.isDelete = false,
    this.isPaket = false,
    this.isBahan = false,
    this.isVarian = false,
    this.onVarian,
    this.onBahan,
    this.onEdit,
    this.onDelete,
    this.onPaket,
  }) : super(key: key);

  AppTableCell copyWithWidth(double newWidth) {
    return AppTableCell(
      index: index,
      value: value,
      imageUrl: imageUrl,
      width: newWidth,
      height: height,
      isEdit: isEdit,
      isDelete: isDelete,
      isPaket: isPaket,
      isBahan: isBahan,
      isVarian: isVarian,
      onBahan: onBahan,
      onVarian: onVarian,
      onEdit: onEdit,
      onDelete: onDelete,
      onPaket: onPaket,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        index % 2 == 0 ? Colors.white : AppColor.tertiaryColor;

    return Container(
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
          else
            Text(
              value,
              style: AppTextStyle.textBodyStyle(),
            ),
          if (isEdit || isDelete || isPaket || isBahan || isVarian)
            Positioned(
              right: 0,
              top: 0,
              child: Row(
                children: [
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
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback? onPressed,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 16),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
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
      color: AppColor.secondaryColor,
      child: Text(
        value,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

String formatCurrency(num? amount,
    {String locale = 'id_ID', String symbol = 'Rp'}) {
  final format =
      NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);
  return format.format(amount ?? 0); // Gunakan 0 jika amount bernilai null
}
