import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/apps/dgkala/widgets/amazing_offer.dart';
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
      home: AmazingOffer(
        title: 'شگفت انگیز',
        height: 350,
        items: [
          AmazingOfferItem(cover: '', name: 'همزن تک الکتریک مدل bm1108-30bs',offer: 10, price: 11,onTap: (){}),
          AmazingOfferItem(cover: '', name: 'ساندویچ ساز ۴ خانه میلر مدل ME-31', price: 11,onTap: (){}),
          AmazingOfferItem(cover: '', name: 'ساندویچ ساز پارس خزر مدل SM-850P', price: 11,onTap: (){}),
          AmazingOfferItem(cover: '', name: 'خردکن ۲ لیتری نوتریکوک مدل NC-CH2000', price: 11,onTap: (){}),
          AmazingOfferItem(cover: '', name: 'دسته بازی فیلیپس مدل ۵۰۱۰', price: 11,onTap: (){}),
      
        ],
      ),
    //  home: TelegramHomeView(),
    );
  }
}

