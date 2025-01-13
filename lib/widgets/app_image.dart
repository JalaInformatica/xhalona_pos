import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xhalona_pos/core/theme/theme.dart';

class AppImage extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final double? radius;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.width,
    required this.height,
    required this.imageUrl,
    this.radius,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
          color: AppColor.grey200,
          borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 0)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 0),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColor.grey300,
          highlightColor: AppColor.grey100,
          child: Container(
            decoration: BoxDecoration(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radius ?? 0),
                color: Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => SvgPicture.asset(
          'assets/logo-only-pink.svg',
          color: AppColor.grey300,
        ),
      ),
    );
  }
}
