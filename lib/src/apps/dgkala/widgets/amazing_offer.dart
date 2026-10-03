import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:popular_apps_widgets/src/core/models/image_source.dart';
import 'package:popular_apps_widgets/src/core/utils/format_duration.dart';
import 'package:popular_apps_widgets/src/core/widgets/image_builder.dart';

/// Represents a single product displayed inside [AmazingOffer].
///
/// The model is immutable so that an offer item cannot accidentally be
/// modified while the widget is being rendered.
class AmazingOfferItem {
  final ImageSource cover;
  final String name;
  final int price;
  final int? offer;

  final TextStyle nameStyle;
  final TextStyle priceStyle;
  final TextStyle offerStyle;

  final VoidCallback onTap;

  AmazingOfferItem({
    required this.cover,
    required this.name,
    required this.price,
    required this.onTap,
    this.offer,
    TextStyle? nameStyle,
    TextStyle? priceStyle,
    TextStyle? offerStyle,
  })  : nameStyle = nameStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
        priceStyle = priceStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
        offerStyle = offerStyle ??
            const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              decoration: TextDecoration.lineThrough,
            );
}

/// Displays a horizontally scrollable list of promotional products.
///
/// The widget supports:
/// - Custom title/header
/// - Countdown timer
/// - Custom item/image builders
/// - Custom price/offer formatting
/// - Custom styling and decoration
/// - "See all" action
class AmazingOffer extends StatefulWidget {
  final double height;

  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;

  final BoxDecoration decoration;

  final String? title;
  final Widget? titleWidget;
  final Widget? icon;

  final TextStyle? titleStyle;
  final TextStyle? moreStyle;
  final TextStyle? timerStyle;

  final List<AmazingOfferItem> items;

  final double itemAspect;
  final double radius;

  final String Function(int)? priceBuilder;
  final String Function(int)? offerBuilder;
  final Widget Function(ImageSource)? coverBuilder;

  final BoxDecoration? timerBoxDecoration;

  final VoidCallback? onEnd;
  final VoidCallback? onMoreTap;

  /// Initial countdown duration in seconds.
  final int? remainingDuration;

  const AmazingOffer({
    super.key,
    required this.items,
    this.height = 250,
    this.padding,
    this.contentPadding,
    this.title,
    this.titleWidget,
    this.icon,
    this.titleStyle,
    this.moreStyle,
    this.timerStyle,
    this.itemAspect = 4 / 7,
    this.radius = 10,
    this.priceBuilder,
    this.offerBuilder,
    this.coverBuilder,
    this.timerBoxDecoration,
    this.onEnd,
    this.onMoreTap,
    this.remainingDuration,
    BoxDecoration? decoration,
  }) : decoration = decoration ??
            const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red,
                  Colors.redAccent,
                ],
              ),
            );

  @override
  State<AmazingOffer> createState() => _AmazingOfferState();
}

class _AmazingOfferState extends State<AmazingOffer> {
  Timer? _timer;
  late final ValueNotifier<String> _formattedDuration;

  int? _remainingSeconds;

  EdgeInsetsGeometry get _padding =>
      widget.padding ?? EdgeInsets.zero;

  EdgeInsetsGeometry get _contentPadding =>
      widget.contentPadding ?? const EdgeInsets.all(10);

  TextStyle get _titleStyle =>
      widget.titleStyle ??
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 19,
      );

  TextStyle get _moreStyle =>
      widget.moreStyle ??
      const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      );

  TextStyle get _timerStyle =>
      widget.timerStyle ??
      const TextStyle(
        color: Colors.black,
      );

  BoxDecoration get _timerBoxDecoration =>
      widget.timerBoxDecoration ??
      BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      );

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.remainingDuration;

    _formattedDuration = ValueNotifier(
      formatDuration(_remainingSeconds ?? 0),
    );

    if (_remainingSeconds != null) {
      _startTimer();
    }
  }

  /// Starts the countdown from the configured duration.
  ///
  /// The remaining value is stored locally rather than reading
  /// `widget.remainingDuration` on every tick. This keeps the timer
  /// independent from the immutable widget configuration.
  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTimerTick(),
    );
  }

  void _handleTimerTick() {
    final remaining = _remainingSeconds;

    if (remaining == null) {
      return;
    }

    if (remaining <= 1) {
      _remainingSeconds = 0;
      _formattedDuration.value = formatDuration(0);

      _timer?.cancel();
      _timer = null;

      widget.onEnd?.call();
      return;
    }

    _remainingSeconds = remaining - 1;
    _formattedDuration.value = formatDuration(_remainingSeconds!);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _formattedDuration.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: _padding,
            child: Container(
              height: widget.height,
              width: double.infinity,
              decoration: widget.decoration,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildItems(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Padding(
        padding: _contentPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 10,
              children: [
                if (widget.icon != null) widget.icon!,
                _buildTitle(),
                if (widget.remainingDuration != null)
                  _buildTimer(),
              ],
            ),
            _buildMoreButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (widget.titleWidget != null) {
      return widget.titleWidget!;
    }

    if (widget.title == null) {
      return const SizedBox.shrink();
    }

    return Text(
      widget.title!,
      style: _titleStyle,
    );
  }

  Widget _buildMoreButton() {
    return InkWell(
      onTap: widget.onMoreTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Text(
          'همه',
          style: _moreStyle,
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return ValueListenableBuilder<String>(
      valueListenable: _formattedDuration,
      builder: (_, duration, __) {
        final parts = duration.split(':');

        if (parts.length != 3) {
          return const SizedBox.shrink();
        }

        return Row(
          spacing: 5,
          children: [
            _buildTimerBox(
              value: parts[2],
              separator: ':',
            ),
            _buildTimerBox(
              value: parts[1],
              separator: ':',
            ),
            _buildTimerBox(
              value: parts[0],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimerBox({
    required String value,
    String? separator,
  }) {
    return Row(
      spacing: 5,
      children: [
        SizedBox.square(
          dimension: 30,
          child: DecoratedBox(
            decoration: _timerBoxDecoration,
            child: Center(
              child: Text(
                value.toPersianDigit(),
                style: _timerStyle,
              ),
            ),
          ),
        ),
        if (separator != null)
          Text(
            separator,
            style: TextStyle(
              color: Colors.white,
              fontFamily: _timerStyle.fontFamily,
            ),
          ),
      ],
    );
  }

  Widget _buildItems() {
    return Padding(
      padding: 
        EdgeInsets.only(
          bottom: _contentPadding.vertical / 2,
        ),
      
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        padding: EdgeInsets.symmetric(horizontal: _contentPadding.horizontal / 2),
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: index == 0?BorderRadius.horizontal(right: Radius.circular(widget.radius)):index ==widget.items.length-1?BorderRadius.horizontal(left: Radius.circular(widget.radius)):BorderRadius.zero ,
            child: _buildAmazingOfferItem(
              widget.items[index],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmazingOfferItem(AmazingOfferItem item) {
    return InkWell(
      onTap: item.onTap,
      child: AspectRatio(
        aspectRatio: widget.itemAspect,
        child: Container(
          padding: const EdgeInsets.all(6),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              _buildCover(item),
              _buildItemName(item),
              _buildOffer(item),
              _buildPrice(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(AmazingOfferItem item) {
    return AspectRatio(
      aspectRatio: 1,
      child: widget.coverBuilder?.call(item.cover) ??
          ImageBuilder(item.cover),
    );
  }

  Widget _buildItemName(AmazingOfferItem item) {
    return Expanded(
      flex: 2,
      child: Text(
        item.name,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: item.nameStyle,
      ),
    );
  }

  Widget _buildOffer(AmazingOfferItem item) {
    return Expanded(
      child: Text(
        item.offer == null
            ? ''
            : widget.offerBuilder?.call(item.offer!) ??
                item.offer.toString(),
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: item.offerStyle,
      ),
    );
  }

  Widget _buildPrice(AmazingOfferItem item) {
    return Expanded(
      child: Text(
        widget.priceBuilder?.call(item.price) ??
            item.price.toString(),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: item.priceStyle,
      ),
    );
  }
}
