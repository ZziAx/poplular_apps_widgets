import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class TelegramGlassyContainer extends StatelessWidget {
  double? width;
  double? height;
  Widget child;
  EdgeInsetsGeometry ?padding;
  Color backgroundColor;

  TelegramGlassyContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor = Colors.white10,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double borderWidth = 1;
    return Container(
      width: width,
      height: height,
      padding:padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border:  GradientBoxBorder(
          gradient: LinearGradient(colors: [Colors.white.withOpacity(0.05),Colors.white10,Colors.white.withOpacity(0.06)]),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: child,
    );
  }
}
