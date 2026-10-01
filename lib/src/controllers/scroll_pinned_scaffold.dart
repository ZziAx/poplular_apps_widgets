import 'dart:async';

import 'package:flutter/material.dart';

class ScrollPinnedScaffoldController {
  StreamController<bool> pinStream = StreamController.broadcast();
  StreamController<double> fadeStream = StreamController.broadcast();

  bool pinned = false;

  void fade(double opacity) {
    fadeStream.add(opacity);
  }

  void pin() {
    pinned = true;
    pinStream.add(pinned);
  }

  void unpin() {
    pinned = false;
    pinStream.add(pinned);
  }
}
