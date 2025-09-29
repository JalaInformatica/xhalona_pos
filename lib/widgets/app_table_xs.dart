import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_loading_indicator.dart';
import 'package:xhalona_pos/widgets/app_dropdown.dart';

enum ColumAlignment {left, center, right}

class ColumnDef {
  final String field;
  final String headerName;
  final double width;
  final String Function(dynamic) textFormatter;
  final ColumAlignment alignment;

  ColumnDef({
    required this.field,
    required this.headerName,
    this.width = 100,
    String Function(dynamic)? textFormatter,
    this.alignment = ColumAlignment.center
  }): textFormatter = textFormatter ?? ((val)=>val.toString());
}

class FooterDef {
  final String field;
  final String value;
  final int colSpan;
  final ColumAlignment columAlignment;

  FooterDef({
    required this.field,
    required this.value,
    this.colSpan = 1,
    this.columAlignment = ColumAlignment.center
  });
}

enum TableSize {small, normal}

class AppTableXs extends StatefulWidget {
  final List<ColumnDef> columnDefs;
  final List<Map<String, dynamic>> rowData;
  final bool isLoading;
  final Function(Map<String, dynamic>)? onRowClicked;
  final TableSize tableSize;
  final List<FooterDef>? footerDefs;
  final bool isPaginated;
  final Function(int)? onPageRowChanged;
  final Function(int)? onPageNoChanged;
  final int? pageNo;

  const AppTableXs({
    super.key,
    required this.columnDefs,
    required this.rowData,
    this.isLoading = false,
    this.onRowClicked,
    this.tableSize = TableSize.normal,
    this.footerDefs,
    this.isPaginated = true,
    this.onPageRowChanged,
    this.onPageNoChanged,
    this.pageNo
  });

  @override
  State<AppTableXs> createState() => _AppTableXsState();
}

class _AppTableXsState extends State<AppTableXs> {
  final ScrollController headerScroll = ScrollController();
  final ScrollController footerScroll = ScrollController();
  final ScrollController bodyScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  int pageRow = 10;

  Alignment getAlignment(ColumAlignment colAlignment){
    switch(colAlignment){
      case ColumAlignment.left:
      return Alignment.centerLeft;
      case ColumAlignment.center:
      return Alignment.center;
      case ColumAlignment.right:
      return Alignment.centerRight;
    }
  }

  @override
  void initState() {
    super.initState();

    // Sync header <-> body horizontal scroll
    headerScroll.addListener(() {
      if (bodyScroll.hasClients &&
          bodyScroll.offset != headerScroll.offset) {
        bodyScroll.jumpTo(headerScroll.offset);
      }
    });

    bodyScroll.addListener(() {
      if (headerScroll.hasClients &&
          headerScroll.offset != bodyScroll.offset) {
        headerScroll.jumpTo(bodyScroll.offset);
      }
    });

    footerScroll.addListener(() {
      if (headerScroll.hasClients &&
          headerScroll.offset != footerScroll.offset) {
        headerScroll.jumpTo(footerScroll.offset);
      }
    });

    headerScroll.addListener(() {
      if (footerScroll.hasClients &&
          footerScroll.offset != headerScroll.offset) {
        footerScroll.jumpTo(headerScroll.offset);
      }
    });

  }

  @override
  void dispose() {
    headerScroll.dispose();
    bodyScroll.dispose();
    verticalScroll.dispose();
    super.dispose();
  }

  // Widget  (ColumnDef firstCol, List<ColumnDef> restCols){

  // }

  @override
  Widget build(BuildContext context) {
    final firstCol = widget.columnDefs.first;
    final restCols = widget.columnDefs.sublist(1);
    final double colHeight = widget.tableSize == TableSize.normal ? 35 : 30;
    final double colPadding = widget.tableSize == TableSize.normal ? 8 : 4;
    
    return Column(
      children: [
        // Header
        if(widget.isPaginated)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide(color: AppColor.grey100))
          ),
          child: Row(
          spacing: 5,
          children: [
            AppTextDropdown<int>(
              value: pageRow,
              items: [
                DropdownMenuItem(
                  value: 10,
                  child: Text("10 / Halaman", style: AppTextStyle.textNStyle())
                ),
                DropdownMenuItem(
                  value: 20,
                  child: Text("20 / Halaman", style: AppTextStyle.textNStyle())
                ),
                DropdownMenuItem(
                  value: 50,
                  child: Text("50 / Halaman", style: AppTextStyle.textNStyle())
                ),
              ],
              onChanged: (val){
                setState(() {
                  pageRow = val!;
                  if(widget.onPageRowChanged!=null){
                    widget.onPageRowChanged!(val);
                  }
                });
              }
            ),
            Spacer(),
            AppIconButton(
              foregroundColor: AppColor.grey300,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: AppColor.grey300)),
              onPressed: (){}, 
              icon: Icon(Icons.chevron_left)
            ),
            AppIconButton(
              onPressed: (){
                if(widget.onPageNoChanged!=null){
                  widget.onPageNoChanged!(widget.pageNo??1-1);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: AppColor.grey300)),
              icon: Text("${widget.pageNo}", style: AppTextStyle.textNStyle(),),
            ),
            AppIconButton(
              foregroundColor: AppColor.grey300,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: AppColor.grey300)),
              onPressed: (){
                if(widget.onPageNoChanged!=null){
                  widget.onPageNoChanged!(widget.pageNo??1+1);
                }
              }, 
              icon: Icon(Icons.chevron_right)
            )
          ],
        )),
        Row(
          children: [
            // Fixed first column
            Container(
              width: firstCol.width,
              height: colHeight,
              color: AppColor.whiteColor,
              padding: EdgeInsets.symmetric(horizontal: colPadding),
              alignment: getAlignment(firstCol.alignment),
              child: Text(
                firstCol.headerName,
                style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500, color: AppColor.grey800),
              ),
            ),
            // Scrollable header
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: headerScroll,
                child: Row(
                  children: restCols.map((col) {
                    return Container(
                      width: col.width,
                    height: colHeight,
                      color: AppColor.whiteColor,
                      padding: EdgeInsets.symmetric(horizontal: colPadding),
                      alignment: getAlignment(col.alignment),
                      child: Text(
                        col.headerName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.grey800
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),

        Divider(height: 0, color: AppColor.grey300,),

        // Body
        widget.isLoading?
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              AppLoadingIndicator(),
              Text("Memuat data", style: AppTextStyle.textNStyle(color: AppColor.grey500),),
            ],
          )
        ) :
        widget.rowData.isEmpty? 
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8
          ),
          child: Text("Tidak ada data", style: AppTextStyle.textNStyle(color: AppColor.grey500),),
        ) :
        Flexible(
          child: Scrollbar(
            thumbVisibility: true,
            controller: verticalScroll,
            child: SingleChildScrollView(
              controller: verticalScroll,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed first column data
                  Column(
                    children: List.generate(widget.rowData.length, (index) {
                      final row = widget.rowData[index];
                      return TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          foregroundColor: AppColor.blackColor
                        ),
                        onPressed: (){
                          if(widget.onRowClicked!=null){
                            widget.onRowClicked!(row);
                          }
                        }, 
                        child: Container(
                          width: firstCol.width,
                          height: colHeight,
                          alignment: getAlignment(firstCol.alignment),
                          color: index % 2 == 0
                              ? Colors.white
                              : AppColor.grey100,
                          padding: EdgeInsets.all(colPadding),
                          child: Text(
                            (firstCol.textFormatter(row[firstCol.field] ?? '')),
                            style: AppTextStyle.textNStyle(color: AppColor.blackColor),
                            
                          ),
                      ));
                    }),
                  ),
                  // Scrollable row data
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: bodyScroll,
                      child: Column(
                        children: List.generate(widget.rowData.length, (index) {
                          final row = widget.rowData[index];
                          return TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              foregroundColor: AppColor.blackColor
                            ),
                            onPressed: (){
                              if(widget.onRowClicked!=null){
                                widget.onRowClicked!(row);
                              }
                            }, 
                            child: Row(
                            children: restCols.map((col) {
                              return Container(
                                width: col.width,
                                height: colHeight,
                                alignment:  getAlignment(col.alignment),
                                color: index % 2 == 0
                                    ? Colors.white
                                    : AppColor.grey100,
                                padding: EdgeInsets.all(colPadding),
                                child: Text(
                                  col.textFormatter(row[col.field] ?? ''),
                                  style: AppTextStyle.textNStyle(),
                                ),
                              );
                            }).toList(),
                          ));
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        if (widget.footerDefs != null && widget.footerDefs!.isNotEmpty && !widget.isLoading)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
            Divider(height: 0, color: AppColor.grey100,),
            Row(
            children: [
              // Fixed first column footer
              Builder(builder: (_) {
                final matchingFooter = widget.footerDefs!.firstWhere(
                  (f) => f.field == firstCol.field,
                  orElse: () => FooterDef(field: '', value: ''),
                );

                return Container(
                  width: firstCol.width,
                  height: colHeight,
                  alignment: getAlignment(firstCol.alignment),
                  padding: EdgeInsets.symmetric(horizontal: colPadding),
                  child: Text(
                    matchingFooter.value,
                    style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }),

              // Scrollable footer cells
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: footerScroll,
                  child: Row(
                    children: restCols.map((col) {
                      final matchingFooter = widget.footerDefs!.firstWhere(
                        (f) => f.field == col.field,
                        orElse: () => FooterDef(field: '', value: ''),
                      );

                      return Container(
                width: col.width,
                height: colHeight,
                alignment: getAlignment(col.alignment),
                padding: EdgeInsets.symmetric(horizontal: colPadding),
                child: Text(
                  matchingFooter.value,
                  style: AppTextStyle.textNStyle(fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ],
  ),])


      ],
    );
  }
}
