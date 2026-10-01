
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold_controller.dart';

/// A Telegram-style header that adapts its appearance to scroll state.
///
/// The header supports:
/// - A configurable title and text style.
/// - A gradient background.
/// - A blurred background effect controlled by the fade stream.
/// - Additional actions that appear when the header is pinned.
///
/// The [controller] provides the current opacity and pinned state.
class TelegramHeader extends StatefulWidget {
  /// The header's title.
  final String title;

  /// The text style used for the title.
  final TextStyle titleStyle;

  /// Actions that are always visible.
  final List<Widget> actions;

  /// Actions displayed when the header is pinned.
  final List<Widget> pinnedActions;

  /// The base background color used by the gradient.
  final Color backgroundColor;

  /// Controller providing scroll and pin state.
  final ScrollPinnedScaffoldController controller;

  /// Padding applied inside the header.
  final EdgeInsetsGeometry? padding;

  TelegramHeader({
    super.key,
    required this.title,
    required this.controller,
    Color? backgroundColor,
    TextStyle? titleStyle,
    List<Widget>? actions,
    List<Widget>? pinnedActions,
    this.padding,
  }) : backgroundColor = backgroundColor ?? HexColor('181818'),
       titleStyle = titleStyle ??
           const TextStyle(
             color: Colors.white,
             fontSize: 23,
             fontWeight: FontWeight.bold,
           ),
       actions = actions ?? const [],
       pinnedActions = pinnedActions ?? const [];

  @override
  State<TelegramHeader> createState() => _TelegramHeaderState();
}

class _TelegramHeaderState extends State<TelegramHeader> {
  late StreamSubscription<double> _fadeSubscription;
  late StreamSubscription<bool> _pinSubscription;

  /// Current fade opacity received from the controller.
  double _opacity = 1.0;

  /// Whether the header is currently pinned.
  bool _pinned = false;

  @override
  void initState() {
    super.initState();
    _subscribeToController();
  }

  /// Subscribes to changes from the scroll controller.
  void _subscribeToController() {
    _opacity = widget.controller.opacity;
    _pinned = widget.controller.pinned;

    _fadeSubscription = widget.controller.fadeStream.listen((opacity) {
      if (!mounted) return;

      setState(() {
        _opacity = opacity;
      });
    });

    _pinSubscription = widget.controller.pinStream.listen((pinned) {
      if (!mounted) return;

      setState(() {
        _pinned = pinned;
      });
    });
  }

  @override
  void didUpdateWidget(covariant TelegramHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-subscribe when a different controller is provided.
    if (oldWidget.controller != widget.controller) {
      _fadeSubscription.cancel();
      _pinSubscription.cancel();
      _subscribeToController();
    }
  }

  @override
  void dispose() {
    // The header owns its subscriptions, not the controller.
    _fadeSubscription.cancel();
    _pinSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          // Blurred background, revealed as the header fades.
          _buildBlurredBackground(),

          // Main header content and gradient.
          _buildHeaderContent(),
        ],
      ),
    );
  }

  /// Builds the background blur effect.
  Widget _buildBlurredBackground() {
    return Opacity(
      opacity: (1.0 - _opacity).clamp(0.0, 1.0),
      child:  BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: SizedBox(
          height: 50,
          width: double.infinity,
        ),
      ),
    );
  }

  /// Builds the header's title and action buttons.
  Widget _buildHeaderContent() {
    return Container(
      width: double.infinity,
      height: 50,
      padding: widget.padding,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.backgroundColor,
            widget.backgroundColor.withValues(alpha: 0.8),
            widget.backgroundColor.withValues(alpha: 0.5),
            widget.backgroundColor.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header title.
          Text(
            widget.title,
            style: widget.titleStyle,
          ),

          // Persistent actions and conditional pinned actions.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.actions,
              if (_pinned) ...widget.pinnedActions,
            ],
          ),
        ],
      ),
    );
  }
}