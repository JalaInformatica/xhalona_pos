import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppBarContainer extends StatelessWidget {
  final Widget? title;
  final Widget? prefix;
  final Widget? searchWidget;
  final List<Widget>? actions;
  final Color? color;
  final bool isBottomBordered;

  const AppBarContainer({
    super.key, 
    this.searchWidget,
    this.title,
    this.prefix,
    this.actions,
    this.color,
    this.isBottomBordered = false
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: prefix==null? 10.w : 0, right: actions!=null? 5.w : 10.w, bottom: 10.h),
      decoration: BoxDecoration(
        color: color ?? AppColor.primaryColor, 
        border: !isBottomBordered? null : const Border(bottom: BorderSide(width: 0.5, color: AppColor.grey300))
      ),
      child: Row(
        children: [
          prefix ?? const SizedBox.shrink(),
          title ?? const SizedBox.shrink(),
          Expanded(
              child: searchWidget ?? const SizedBox.shrink()
          ),
          ...actions ?? []
        ],
      ),
    );
  }
}
