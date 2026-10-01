import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_tab_bar.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold.dart';
import 'package:popular_apps_widgets/src/core/widgets/scroll_pinned_scaffold.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_header.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_search_bar.dart';

class TelegramHomeView extends StatefulWidget {
  const TelegramHomeView({super.key});

  @override
  State<TelegramHomeView> createState() => _TelegramHomePageState();
}

class _TelegramHomePageState extends State<TelegramHomeView> {
  ScrollPinnedScaffoldController controller = ScrollPinnedScaffoldController();
  static final padding = EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    return ScrollPinnedScaffold(
      controller: controller,
      threshold: 50,
      padding: padding,
      backgroundColor: HexColor("181818"),
      fixed: TelegramHeader(
        padding: padding,
        controller: controller,
        title: 'Telegram',
      ),
      pinned: TelegramTabBar(
        padding: padding,
        tabs: [TelegramTab('All Chats'), TelegramTab('Universe')],
        backgroundColor: HexColor('232425'),
      ),

      hiddenWhenScroll: TelegramSearchBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: List.generate(100, (i) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Text("Tile", style: TextStyle(color: Colors.white)),
          ),
        );
      }),
    );
  }
}
