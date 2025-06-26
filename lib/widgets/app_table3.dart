import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';

// ignore: must_be_immutable
class AppTable3 extends StatefulWidget {
  final List<AppTableTitle3> titles;
  final List<List<AppTableCell3>> data;
  final List<AppTableFooter>?footer;
  final VoidCallback onRefresh;
  final bool isRefreshing;
  final Function(String) onSearch;
  final Function(int) onChangePageRow;
  final Function(int) onChangePageNo;
  int pageNo;
  int pageRow;

  AppTable3({
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
    this.footer
  });

  @override
  State<AppTable3> createState() => _AppTableState();
}

class _AppTableState extends State<AppTable3> {
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

  ScrollController headerScrollController = ScrollController();
  ScrollController bodyScrollController = ScrollController();
  ScrollController bodyVerticalScrollController = ScrollController();
  ScrollController footerScrollController = ScrollController();

  @override
  initState(){
    super.initState();
    headerScrollController.addListener(() {
      if (bodyScrollController.hasClients && 
          bodyScrollController.offset != headerScrollController.offset) {
        bodyScrollController.jumpTo(headerScrollController.offset);
      }
    });

    bodyScrollController.addListener(() {
      if (headerScrollController.hasClients &&
          headerScrollController.offset != bodyScrollController.offset) {
        headerScrollController.jumpTo(bodyScrollController.offset);
      }
      if(footerScrollController.hasClients && 
        footerScrollController.offset != bodyScrollController.offset){
        footerScrollController.jumpTo(bodyScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  


  Widget customTable({
  required List<AppTableTitle3> titles,
  required List<List<AppTableCell3>> data,
  required int itemCount,
}) {

  return Flexible(
    child: Column(
      children: [
        // Sticky Header
        Row(
          children: [
            titles.first,
            Flexible(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                controller: headerScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: titles.skip(1).toList(),
                ),
              ),
            ),
          ],
        ),
        // Scrollable Body
        Flexible(
          child: Scrollbar(
            thumbVisibility: true,
            controller: bodyVerticalScrollController,
            child: SingleChildScrollView(
            controller: bodyVerticalScrollController,
            child: Row(
              children: [
                Column(children: 
                  List.generate(itemCount, (index) {
                    return Container(
                      alignment: Alignment.center,
                      color: index % 2 == 0
                        ? Colors.white
                        : AppColor.tertiaryColor,
                      height: 40,
                      child: data[index].first);}
                  )
                ),
                Flexible(
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: bodyScrollController,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      controller: bodyScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Column(children: 
                        List.generate(itemCount, (index) {
                          return Container(
                            height: 40,
                            alignment: Alignment.center,
                            color: index % 2 == 0
                                  ? Colors.white
                                  : AppColor.tertiaryColor,
                            child: Row(
                              children: data[index]
                                .skip(1)
                                .toList()
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
        if(widget.footer!=null)
        Row(
          children: [
            widget.footer!.first,
            Flexible(
              child: SingleChildScrollView(
                controller: footerScrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.footer!.skip(1).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
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
                  underline: SizedBox.shrink(),
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

class AppColumn {
  final AppTableTitle3 title;
  final List<AppTableCell3> data;

  AppColumn({
    required this.title,
    required this.data,
  });
}

class AppTableCell3 extends StatelessWidget {
  final String? value;
  final double width;
  final Widget? customWidget;
  final TextAlign? textAlign;
  final VoidCallback? action;
  
  const AppTableCell3({
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
      behavior: HitTestBehavior.opaque,
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

class AppTableTitle3 extends Container {
  final String value;

  AppTableTitle3({
    super.key, 
    required this.value, 
    super.width = 100, 
    super.height = 40,
    super.color = AppColor.primaryColor,
    super.alignment = Alignment.center,
  }) : super(
      child: Text(
        value.isNotEmpty? value : "-",
        style: AppTextStyle.textSubtitleStyle(
          color: Colors.white,
        ),
    ),
  );
}

class AppTableFooter extends Container {
  final String? value;
  final Widget? customWidget;

  AppTableFooter({
    super.key, 
    this.value, 
    super.width = 100, 
    super.height = 40,
    super.color = AppColor.purpleColor,
    super.alignment = Alignment.center,
    this.customWidget
  }) : super(
      child: value!=null? 
      Text(
        value,
        style: AppTextStyle.textBodyStyle(
          color: Colors.white,
        ),
      ):customWidget,
  );
}