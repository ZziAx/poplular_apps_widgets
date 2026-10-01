import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/core/widgets/scroll_pinned_scaffold.dart';
import 'package:popular_apps_widgets/src/apps/telegram/telegram_home_view.dart';
import 'package:popular_apps_widgets/src/apps/telegram/widgets/header/telegram_header.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: TelegramHomeView(),
   
    );
  }
}

