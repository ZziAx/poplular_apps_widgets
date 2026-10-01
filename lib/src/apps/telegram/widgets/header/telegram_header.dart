import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold.dart';

class TelegramHeader extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final List<Widget> actions;
  final List<Widget> pinnedActions;
  final Color backgroundColor;
  final ScrollPinnedScaffoldController controller;
  final EdgeInsetsGeometry? padding;
  TelegramHeader({
    super.key,
    required this.title,
    required this.controller,
    Color? backgroundColor,
    TextStyle? titleStyle,
    List<Widget>? actions,
    List<Widget>? pinnedActions,
    this.padding
  }) : backgroundColor = backgroundColor ?? HexColor("181818"),
       titleStyle =
           titleStyle ??
           TextStyle(
             color: Colors.white,
             fontSize: 23,
             fontWeight: FontWeight.bold,
           ),

       pinnedActions = pinnedActions ?? [],
       actions = actions ?? [];

  @override
  State<TelegramHeader> createState() => _TelegramHeaderState();
}

class _TelegramHeaderState extends State<TelegramHeader> {
  String get title => widget.title;
  TextStyle get titleStyle => widget.titleStyle;
  Color get backgroundColor => widget.backgroundColor;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.controller.fadeStream.stream,
      builder: (_, value) {
        final opacity = value.data ?? 1.0;
        return StreamBuilder(
          stream: widget.controller.pinStream.stream,
          builder: (_, value) {
            final pinned = value.data ?? false;
            return ClipRRect(
              child: Stack(
                children: [
                  // if (pinned)
                  Opacity(
                    opacity: 1 - opacity,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                      child: SizedBox(height: 50, width: double.infinity),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: widget.padding,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          backgroundColor,
                          backgroundColor.withOpacity(0.8),
                          backgroundColor.withOpacity(0.5),
                          backgroundColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: titleStyle),
                        Row(
                          children: [
                            ...widget.actions,
                            if (pinned) ...widget.pinnedActions,
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
