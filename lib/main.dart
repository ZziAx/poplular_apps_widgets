import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:popular_apps_widgets/src/apps/dgkala/widgets/amazing_offer.dart';
import 'package:popular_apps_widgets/src/core/models/image_source.dart';
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
        titleWidget: Image.asset('assets/dgkala/amazing_offer.png', width: 120),
        remainingDuration: 500,
        height: 400,
        priceBuilder: (v) {
          return v.toString().toPersianDigit();
        },
        items: [
          AmazingOfferItem(
            cover: LocalImageSource('assets/dgkala/filips.jpg'),
            name: 'همزن تک الکتریک مدل bm1108-30bs',
            offer: 10,
            price: 10000,
            onTap: () {},
          ),
          AmazingOfferItem(
            cover: LocalImageSource('assets/dgkala/filips.jpg'),
            name: 'ساندویچ ساز ۴ خانه میلر مدل ME-31',
            price: 10000,
            onTap: () {},
          ),
          AmazingOfferItem(
            cover: LocalImageSource('assets/dgkala/filips.jpg'),
            name: 'ساندویچ ساز پارس خزر مدل SM-850P',
            price: 10000,
            onTap: () {},
          ),
          AmazingOfferItem(
            cover: LocalImageSource('assets/dgkala/filips.jpg'),
            name: 'خردکن ۲ لیتری نوتریکوک مدل NC-CH2000',
            price: 10000,
            onTap: () {},
          ),
          AmazingOfferItem(
            cover: LocalImageSource('assets/dgkala/filips.jpg'),
            name: 'دسته بازی فیلیپس مدل ۵۰۱۰',
            price: 10000,
            onTap: () {},
          ),
        ],
      ),
      //  home: TelegramHomeView(),
    );
  }
}
