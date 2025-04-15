import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

Widget extendedImage({
  required String imagePath,
  double width = double.maxFinite,
  double height = double.maxFinite,
  BoxFit boxFit = BoxFit.cover,
  bool cache = true,
}) {
  if (imagePath.isEmpty) {
    return Image.asset('assets/images/placeholder.jpg', fit: boxFit, width: width, height: height);
  }

  return ExtendedImage.network(
    imagePath,
    width: width,
    height: height,
    cache: cache,
    fit: BoxFit.cover,
    loadStateChanged: (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.loading:
          return Image.asset('assets/images/placeholder.jpg', fit: boxFit, width: width, height: height);
        case LoadState.completed:
          return ExtendedRawImage(image: state.extendedImageInfo?.image, width: width, height: height, fit: boxFit);
        case LoadState.failed:
          return Image.asset('assets/images/placeholder.jpg', fit: boxFit, width: width, height: height);
      }
    },
  );
}
