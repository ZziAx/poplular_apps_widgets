class ImageSource {
  String source;
  ImageSource(this.source);
}

class LocalImageSource extends ImageSource {
  LocalImageSource(super.source);
}


class NetworkImageSource extends ImageSource {
  NetworkImageSource(super.source);
}
