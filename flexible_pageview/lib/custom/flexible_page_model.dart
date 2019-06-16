import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

class FlexiblePageModel {
  String image_link = "";

  // derivatives
  Completer<ui.Image> completer = new Completer<ui.Image>();
  Image image;
  double height = 200.0;

  FlexiblePageModel({this.image_link}) {
    if (image_link != null) {
      image = new Image.network(image_link);
      image.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image);
        },
      );
    }
  }
}
