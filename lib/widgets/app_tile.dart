  import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppTile extends InkWell{
  AppTile({
    Widget title = const SizedBox.shrink(),
    Widget subtitle = const SizedBox.shrink(),
    Widget trailing = const SizedBox.shrink(),
    Color? backgroundColor,
    EdgeInsets? padding,
    Function()? onTap,
    BoxBorder? border,
    double borderRadius = 0,
  }): super (
    onTap: onTap,
    child: Container(
      padding: padding?? EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: border!=null? BorderRadius.circular(borderRadius) : null,
        border: border
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              subtitle
            ]
          ),
          trailing
        ],
      )
    ));
  }