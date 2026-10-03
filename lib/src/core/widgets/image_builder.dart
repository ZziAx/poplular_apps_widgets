import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/core/models/image_source.dart';

class ImageBuilder extends StatelessWidget {
  ImageSource image;
  double ?width;
  double ?height;
  ImageBuilder(this.image,{this.width, this.height});

  @override
  Widget build(BuildContext context) {
    if (image is LocalImageSource) {
      return Image.asset(image.source,width: width,height: height,);
    } else {
      return Image.network(image.source,width: width,height: height,);
    }
  }
}
