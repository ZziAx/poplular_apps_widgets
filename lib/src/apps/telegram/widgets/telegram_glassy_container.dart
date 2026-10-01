import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

/// A reusable glass-style container inspired by Telegram's UI.
///
/// The container provides:
/// - A semi-transparent background.
/// - A subtle gradient border.
/// - Rounded corners.
/// - Optional width, height, and padding.
///
/// Example:
/// ```dart
/// TelegramGlassyContainer(
///   height: 40,
///   padding: const EdgeInsets.symmetric(horizontal: 12),
///   child: const Text(
///     'Telegram',
///     style: TextStyle(color: Colors.white),
///   ),
/// )
/// ```
class TelegramGlassyContainer extends StatelessWidget {
  /// Width of the container.
  final double? width;

  /// Height of the container.
  final double? height;

  /// Content displayed inside the container.
  final Widget child;

  /// Padding applied around [child].
  final EdgeInsetsGeometry? padding;

  /// Background color of the glass container.
  final Color backgroundColor;

  /// Radius of the container's corners.
  final double borderRadius;

  /// Width of the gradient border.
  final double borderWidth;

  /// Gradient used for the container's border.
  final Gradient? borderGradient;

  const TelegramGlassyContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor = Colors.white10,
    this.borderRadius = 50,
    this.borderWidth = 1,
    this.borderGradient,
  });

  /// Default subtle white gradient used for the glass border.
  Gradient get _defaultBorderGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: 0.05),
        Colors.white10,
        Colors.white.withValues(alpha: 0.06),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: GradientBoxBorder(
          gradient: borderGradient ?? _defaultBorderGradient,
          width: borderWidth,
        ),
      ),
      child: child,
    );
  }
}