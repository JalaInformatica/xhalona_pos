import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';

// ignore: must_be_immutable
class AppTable2 extends StatefulWidget {
  final List<AppTableTitle2> titles;
  final List<List<AppTableCell2>> data;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final Function(String) onSearch;
  final Function(int) onChangePageRow;
  final Function(int) onChangePageNo;
  int pageNo;
  int pageRow;

  AppTable2({
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
  State<AppTable2> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable2> {
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

  Widget customTable({
    required List<AppTableTitle2> titles,
    required List<List<AppTableCell2>> data,
    required int itemCount,
  }) {
    return Flexible(
        child: SingleChildScrollView(
            child: Row(
      children: [
        DataTable(
          columnSpacing: 5,
          horizontalMargin: 0,
          dividerThickness: 0.01,
          headingRowHeight: 40,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 40,
          headingRowColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return AppColor.primaryColor;
            },
          ),
          columns: [
            DataColumn(label: titles.first)
          ],
          rows: List.generate(itemCount, 
            (index){
              return DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return index % 2 == 0 ? Colors.white : AppColor.tertiaryColor;
                  },
                ),
                cells: [
                  DataCell(
                    data[index].first
                  )
                ]
              );
            }),
        ),
        Flexible(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: ScrollController(),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 5,
              horizontalMargin: 0,
              dividerThickness: 0.01,
              headingRowHeight: 40,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 40,
              headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return AppColor.primaryColor;
                },
              ),
              columns:
                titles.map(
                  (columns) => DataColumn(label: columns),
                ).skip(1).toList(),
              rows: List.generate(itemCount, 
                (index){
                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      return index % 2 == 0 ? Colors.white : AppColor.tertiaryColor;
                      },
                    ),
                    cells: data[index].skip(1).map((item)=>DataCell(
                      item,
                    )).toList()
                  );
                }
              ),
            )
          )
        )),
      ],
    )));
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
          ],
        ),
        SizedBox(height: 5),
        !widget.isRefreshing
            ? customTable(
              itemCount: widget.data.length,
                titles: widget.titles,
                data: widget.data
              )
            : Flexible(child: _buildShimmerTable(100)),
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
        Container(
        height: 40,
          color: AppColor.primaryColor,
          child: Row(children: widget.titles.map((title) => title).toList())),
        SizedBox(height: 5),
        ...List.generate(
          2,
          (index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                  height: 40,
                  margin: EdgeInsets.only(bottom: 5),
                  color: AppColor.whiteColor, 
                  child: Row(
                    children: widget.titles.map((title) {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: title);
                  }).toList()),
            ));
          },
        ),
      ]),
    );
  }
}

class AppTableCell2 extends StatelessWidget {
  final String? value;
  final double width;
  final Widget? customWidget;
  final TextAlign? textAlign;
  final VoidCallback? action;
  
  const AppTableCell2({
    super.key,
    this.value,
    this.width = 100,
    this.customWidget,
    this.textAlign = TextAlign.center,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: SizedBox(
        width: width,
        child: customWidget==null && value!=null? Text(
            value!.isNotEmpty ? value! : "-",
            textAlign: textAlign,
            style: AppTextStyle.textBodyStyle(),
          ) : Center(child: customWidget,),
      )
    );
  }
}

class AppTableTitle2 extends StatelessWidget {
  final String value;
  final double width;
  final double height;
  final TextAlign? textAlign;

  AppTableTitle2({
    Key? key, 
    required this.value, 
    this.width = 100, 
    this.height = 35,
    this.textAlign = TextAlign.center
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        value.isNotEmpty? value : "-",
        textAlign: textAlign,
        style: AppTextStyle.textSubtitleStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}