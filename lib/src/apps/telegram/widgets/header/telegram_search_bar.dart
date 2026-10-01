import 'package:flutter/material.dart';

/// A Telegram-style search bar.
///
/// This widget is intentionally presentational. It does not handle search
/// input itself; it can be wrapped with a [GestureDetector] or replaced
/// with a [TextField] when interactive search is required.
class TelegramSearchBar extends StatelessWidget {
  /// Text displayed inside the search bar.
  final String hintText;

  /// Optional icon displayed before the hint text.
  final IconData? icon;

  /// Height of the search bar.
  final double height;

  /// Horizontal padding inside the search bar.
  final EdgeInsetsGeometry padding;

  /// Background color of the search bar.
  final Color backgroundColor;

  /// Color of the hint text.
  final Color hintColor;

  /// Text size of the hint.
  final double fontSize;

  /// Called when the search bar is tapped.
  final VoidCallback? onTap;

  const TelegramSearchBar({
    super.key,
    this.hintText = 'Search Chats',
    this.icon,
    this.height = 37,
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.backgroundColor = Colors.white12,
    this.hintColor = Colors.white30,
    this.fontSize = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final searchBar = Container(
      width: double.infinity,
      height: height,
      padding: padding,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: hintColor,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                color: hintColor,
              ),
            ),
          ),
        ],
      ),
    );

    // Avoid creating a GestureDetector when the search bar is not interactive.
    if (onTap == null) {
      return searchBar;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: searchBar,
    );
  }
}