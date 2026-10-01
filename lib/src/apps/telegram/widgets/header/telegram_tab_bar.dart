import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/telegram_glassy_container.dart';

class TelegramTab {
  String title;
  TelegramTab(this.title);
}

class TelegramTabBar extends StatefulWidget {
  List<TelegramTab> tabs;
  Color backgroundColor;
  EdgeInsetsGeometry ?padding;
  TelegramTabBar({
    super.key,
    required this.tabs,
    this.padding,
    this.backgroundColor = Colors.black54,
  });

  @override
  State<TelegramTabBar> createState() => _TelegramTabBarState();
}

class _TelegramTabBarState extends State<TelegramTabBar> {
  Color get backgroundColor => widget.backgroundColor;
  List<TelegramTab> get tabs => widget.tabs;
  int selectedTab = 0;
  void _selectTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      return Container();
    }
    return Padding(
      padding: widget.padding??EdgeInsets.zero,
      child: TelegramGlassyContainer(
        width: double.infinity,
        backgroundColor: backgroundColor,
        height: 40,
        padding: EdgeInsets.all(3),
        child: Row(
          children: List.generate(tabs.length, (i) {
            return _buildTab(
              tabs[i],
              selected: i == selectedTab,
              onTap: () {
                _selectTab(i);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTab(
    TelegramTab tab, {
    required bool selected,
    required Function onTap,
  }) {
    return Flexible(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.blue.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(50),
          ),
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            tab.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.lightBlueAccent : Colors.white54,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
