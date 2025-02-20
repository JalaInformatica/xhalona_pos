import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

Widget MonitorTable({
  required List <MonitorTableTitle> titles,
  required List<List<MonitorTableCell>> data,
  }){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columnSpacing: 0,
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
      columns: titles.map((title)=> DataColumn(
        label: title
      )).toList(), 
      rows: List.generate(data.length, 
        (index){
          return DataRow(
            cells: data[index].map((item)=>
            DataCell(item)).toList()
          );
        }
      ),
    )
  );
}

class MonitorTableCell extends StatelessWidget {
  final String? value;
  final double width;
  final Widget? customWidget;
  final TextAlign? textAlign;
  final VoidCallback? action;
  final Color? color;
  
  const MonitorTableCell({
    super.key,
    this.value,
    this.width = 100,
    this.customWidget,
    this.textAlign = TextAlign.center,
    this.action,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: width,
        color: color,
        child: customWidget==null && value!=null? Text(
            value!.isNotEmpty ? value! : "-",
            textAlign: textAlign,
            style: AppTextStyle.textBodyStyle(),
          ) : Center(child: customWidget,),
      )
    );
  }
}

class MonitorTableTitle extends StatelessWidget {
  final String value;
  final double width;
  final double height;
  final TextAlign? textAlign;

  MonitorTableTitle({
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