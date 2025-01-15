import 'dart:async';

import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 42.h,
                child: AppTextField(
                  context: context,
                  textEditingController: searchController,
                  hintText: "Cari",
                  onChanged: _onChanged,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.all(0),
                )
              ),
            ),
            !widget.isRefreshing? 
              AppIconButton(
                backgroundColor: AppColor.doneColor,
                foregroundColor: AppColor.whiteColor,
                shape: CircleBorder(),
                onPressed: widget.onRefresh,
                icon: Icon(Icons.refresh)
              )
            : Padding(
                padding: EdgeInsets.all(8),
                  child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColor.doneColor,
                    strokeWidth: 4,
                  )
              )),
          ],
        ),
        SizedBox(height: 5.h,),
        !widget.isRefreshing
          ? Flexible(
              child: HorizontalDataTable(
              leftHandSideColumnWidth: 100,
              rightHandSideColumnWidth: (100*(widget.titles.length-1)).toDouble(),
              isFixedHeader: true,
              headerWidgets: widget.titles,
              leftSideItemBuilder: (context, index) {
                return widget.data[index][0];
              },
              rightSideItemBuilder: (context, index) {
                return Row(
                  children: widget.data[index].map<Widget>((cell) => cell).skip(1).toList(),
                );
              },
              itemCount: widget.data.length,
            ))
          : Flexible(child: _buildShimmerTable()),
        SizedBox(height: 5.h,),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppIconButton(
              onPressed: (){
                widget.onChangePageNo(widget.pageNo-1);
              }, 
              icon: Icon(Icons.arrow_back_ios_rounded),
              // padding: EdgeInsets.zero,
            ),
            Container(
              width: 25.w,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Text(
                "${widget.pageNo}", 
                style: AppTextStyle.textBodyStyle(),
                textAlign: TextAlign.center,
                ),
            ),
            AppIconButton(
              onPressed: (){
                widget.onChangePageNo(widget.pageNo+1);
              }, 
              icon: Icon(Icons.arrow_forward_ios_rounded),
              // padding: EdgeInsets.zero,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.grey500),
                borderRadius: BorderRadius.circular(5)
              ),
              child: DropdownButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  value: "${widget.pageRow}/page", // Set the currently selected value
                  onChanged: (String? newValue) {
                    widget.onChangePageRow(int.parse((newValue ?? "10/page").split("/")[0]));
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  isDense: true,
                  dropdownColor: AppColor.whiteColor,
                  items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: AppTextStyle.textBodyStyle(),),
                    );
                  }).toList(),
                  elevation: 8,
              )  
            ),
          ],
        )
        
      ],
    );
  }

  Widget _buildShimmerTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Row for titles
        Row(
          children: widget.titles,
        ),
        SizedBox(
          height: 5.h,
        ),
        ...List.generate(
          2,
          (index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: widget.titles.map((title){
                  return Padding(
                    padding: EdgeInsets.only(bottom: 5.w),
                    child: title);
                }).toList()
              ),
            );
          },
        ),
      ]),
    );
  }
}

class AppTableCell extends Container {
  AppTableCell({
    super.key,
    required int index,
    required String value,
    double? width,
    double? height})
    : super(
        width: width ?? 100,
        height: height ?? 56,
        alignment: Alignment.center,
        color: index % 2 == 0 ? AppColor.whiteColor : AppColor.tertiaryColor,
        child: Text(
          value,
          style: AppTextStyle.textBodyStyle(),
        ),
      );
}

class AppTableTitle extends Container {
  AppTableTitle({super.key, required value, double? width, double? height})
    : super(
        width: width ?? 100,
        height: height ?? 56,
        alignment: Alignment.center,
        color: AppColor.secondaryColor,
        child: Text(
          value,
          style: AppTextStyle.textSubtitleStyle(color: AppColor.whiteColor),
        ),
      );
}
