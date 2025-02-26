import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

// Flexible(child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Enables horizontal scrolling
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical, // Enables vertical scrolling
//         child: Table(
//           columnWidths: {
//             for (int i = 0; i < titles.length; i++) i: IntrinsicColumnWidth()
//           },
//           children: data
//               .where((row) => !skippedRowIds.contains(row.first.value))
//               .map((row) => TableRow(
//                     children: row.skip(1).toList(),
//                   ))
//               .toList(),
//         ),
//       ),
//     ))
class MonitorTable extends StatefulWidget {
  final List<MonitorTableTitle> titles;
  final List<List<MonitorTableCell>> data;
  final RxList<String> skippedRowIds;
  bool isLoading;

  MonitorTable({
    required this.titles,
    required this.data,
    required this.skippedRowIds,
    required this.isLoading,
    Key? key,
  }) : super(key: key);

  @override
  _MonitorTableState createState() => _MonitorTableState();
}

class _MonitorTableState extends State<MonitorTable> {
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyHScrollController = ScrollController();
  final ScrollController _bodyVScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Sync horizontal scrolling of header with body
    _bodyHScrollController.addListener(() {
      _headerScrollController.jumpTo(_bodyHScrollController.offset);
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyHScrollController.dispose();
    _bodyVScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Table Header
          SingleChildScrollView(
            controller: _headerScrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 40,
              color: AppColor.primaryColor,
              child: Row(
                children: widget.titles,
              ),
            ),
          ),

          // Table Body (with both horizontal & vertical scrolling)
          Expanded(
            child: SingleChildScrollView(
              controller: _bodyVScrollController,
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: _bodyHScrollController,
                scrollDirection: Axis.horizontal,
                child: 
                widget.isLoading?
                  SizedBox():
                  Table(
                    columnWidths: {
                      for (int i = 0; i < widget.titles.length; i++)
                        i: IntrinsicColumnWidth()
                    },
                    children: widget.data
                        .where((row) =>
                            !widget.skippedRowIds.contains(row.first.value))
                        .map((row) => TableRow(
                              children: row.skip(1).toList(),
                            ))
                        .toList(),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonitorTableCell extends StatelessWidget {
  final String? value;
  final double width;
  final Widget? customWidget;
  final TextAlign? textAlign;
  final Alignment? alignment;
  final Color? color;
  final Color? fontColor;
  final FontWeight? fontWeight;

  const MonitorTableCell({
    super.key,
    this.value,
    this.width = 100,
    this.customWidget,
    this.textAlign = TextAlign.center,
    this.color,
    this.alignment,
    this.fontWeight,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      alignment: alignment ?? Alignment.center,
      color: color,
      child: customWidget == null && value != null
          ? Text(
              value ?? "",
              textAlign: textAlign,
              style: AppTextStyle.textBodyStyle(
                  fontWeight: fontWeight, color: fontColor),
            )
          : Center(
              child: customWidget,
            ),
    );
  }
}

class MonitorTableTitle extends StatelessWidget {
  final String value;
  final double width;
  final double height;
  final TextAlign? textAlign;

  MonitorTableTitle(
      {Key? key,
      required this.value,
      this.width = 100,
      this.height = 35,
      this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        value.isNotEmpty ? value : "-",
        textAlign: textAlign,
        style: AppTextStyle.textSubtitleStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
