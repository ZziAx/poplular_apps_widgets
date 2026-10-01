import 'package:flutter/material.dart';

import 'package:popular_apps_widgets/src/apps/telegram/widgets/telegram_glassy_container.dart';

/// Represents a single tab in a [TelegramTabBar].
///
/// [title] is the text displayed inside the tab.
class TelegramTab {
  /// The text displayed by the tab.
  final String title;

  const TelegramTab(this.title);
}

/// A Telegram-style segmented tab bar.
///
/// Each tab takes an equal amount of horizontal space. The selected tab is
/// highlighted and its index can be observed through [onChanged].
///
/// Example:
/// ```dart
/// TelegramTabBar(
///   tabs: const [
///     TelegramTab('Chats'),
///     TelegramTab('Groups'),
///     TelegramTab('Channels'),
///   ],
///   onChanged: (index) {
///     debugPrint('Selected tab: $index');
///   },
/// )
/// ```
class TelegramTabBar extends StatefulWidget {
  /// Tabs displayed by the tab bar.
  final List<TelegramTab> tabs;

  /// Background color of the glass container.
  final Color backgroundColor;

  /// Padding around the tab bar.
  final EdgeInsetsGeometry? padding;

  /// Height of the tab bar.
  final double height;

  /// Called when the selected tab changes.
  final ValueChanged<int>? onChanged;

  /// Initially selected tab index.
  final int initialIndex;

  const TelegramTabBar({
    super.key,
    required this.tabs,
    this.padding,
    this.backgroundColor = Colors.black54,
    this.height = 40,
    this.onChanged,
    this.initialIndex = 0,
  });

  @override
  State<TelegramTabBar> createState() => _TelegramTabBarState();
}

class _TelegramTabBarState extends State<TelegramTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();

    _selectedIndex = _getValidInitialIndex();
  }

  /// Returns a valid initial index.
  ///
  /// This prevents an invalid index when [initialIndex] is outside
  /// the range of the provided tabs.
  int _getValidInitialIndex() {
    if (widget.tabs.isEmpty) {
      return 0;
    }

    return widget.initialIndex.clamp(0, widget.tabs.length - 1);
  }

  @override
  void didUpdateWidget(covariant TelegramTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Make sure the selected index remains valid if the number of
    // tabs changes after the widget has been created.
    if (_selectedIndex >= widget.tabs.length) {
      setState(() {
        _selectedIndex = _getValidInitialIndex();
      });
    }
  }

  /// Selects a tab and notifies the parent.
  void _selectTab(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: TelegramGlassyContainer(
        width: double.infinity,
        height: widget.height,
        backgroundColor: widget.backgroundColor,
        padding: const EdgeInsets.all(3),
        child: Row(
          children: List.generate(
            widget.tabs.length,
            (index) => _buildTab(
              widget.tabs[index],
              selected: index == _selectedIndex,
              onTap: () => _selectTab(index),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds an individual tab.
  Widget _buildTab(
    TelegramTab tab, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? Colors.blue.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            tab.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.lightBlueAccent
                  : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}