import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_header.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_search_bar.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_tab_bar.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold_controller.dart';
import 'package:popular_apps_widgets/src/core/widgets/scroll_pinned_scaffold.dart';

/// Main home screen for the Telegram-style UI.
///
/// This page demonstrates the interaction between:
///
/// - [ScrollPinnedScaffold]
/// - [TelegramHeader]
/// - [TelegramSearchBar]
/// - [TelegramTabBar]
/// - [ScrollPinnedScaffoldController]
///
/// The controller is owned by this page and therefore disposed when
/// the page is removed from the widget tree.
class TelegramHomeView extends StatefulWidget {
  const TelegramHomeView({
    super.key,
  });

  @override
  State<TelegramHomeView> createState() => _TelegramHomeViewState();
}

class _TelegramHomeViewState extends State<TelegramHomeView> {
  /// Controller responsible for coordinating the header and scroll state.
  late final ScrollPinnedScaffoldController _controller;

  /// Shared horizontal padding used by the header components.
  static const EdgeInsets _padding = EdgeInsets.symmetric(
    horizontal: 10,
  );

  /// Main background color used throughout the Telegram UI.
  static final Color _backgroundColor = HexColor('181818');

  /// Background color used by the tab bar.
  static final Color _tabBackgroundColor = HexColor('232425');

  @override
  void initState() {
    super.initState();

    _controller = ScrollPinnedScaffoldController();
  }

  @override
  void dispose() {
    // This page owns the controller, so it is responsible for
    // releasing its stream resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollPinnedScaffold(
      controller: _controller,
      threshold: 50,
      padding: _padding,
      backgroundColor: _backgroundColor,

      // The header remains fixed at the top of the screen.
      fixed: _buildHeader(),

      // The tab bar becomes part of the pinned header state.
      pinned: _buildTabBar(),

      // The search bar participates in the collapsible header.
      hiddenWhenScroll: const TelegramSearchBar(),

      // Main scrollable page content.
      body: _buildBody(),
    );
  }

  /// Builds the fixed Telegram header.
  Widget _buildHeader() {
    return TelegramHeader(
      padding: _padding,
      controller: _controller,
      title: 'Telegram',
    );
  }

  /// Builds the tab bar displayed below the header.
  Widget _buildTabBar() {
    return TelegramTabBar(
      padding: _padding,
      backgroundColor: _tabBackgroundColor,
      tabs: const [
        TelegramTab('All Chats'),
        TelegramTab('Universe'),
      ],
    );
  }

  /// Builds the main scrollable content.
  ///
  /// This is currently placeholder content. In a real application,
  /// this could be replaced with a ListView or a list of chat items.
  Widget _buildBody() {
    return Column(
      children: List.generate(
        100,
        _buildListItem,
      ),
    );
  }

  /// Builds a single placeholder list item.
  Widget _buildListItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tile $index',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
