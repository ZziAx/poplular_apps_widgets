import 'package:flutter/material.dart';

class AmazingOfferItem {
  String cover;
  String name;
  int price;
  int? offer;
  TextStyle nameStyle;
  TextStyle priceStyle;
  TextStyle offserStyle;

  VoidCallback onTap;
  AmazingOfferItem({
    required this.cover,
    required this.name,
    required this.price,
    required this.onTap,
    TextStyle? nameStyle,
    TextStyle? priceStyle,
    TextStyle? offserStyle,
    this.offer,
  }) : nameStyle = nameStyle ?? TextStyle(color: Colors.black, fontSize: 15),
       priceStyle =
           priceStyle ??
           TextStyle(
             color: Colors.black,
             fontWeight: FontWeight.bold,
             fontSize: 15,
           ),
       offserStyle =
           offserStyle ??
           TextStyle(
             fontSize: 14,
             color: Colors.black87,
             decoration: TextDecoration.lineThrough,
           );
}

class AmazingOffer extends StatefulWidget {
  double height;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? contentPadding;
  BoxDecoration decoration;
  String? title;
  TextStyle? titleStyle;
  TextStyle? moreStyle;
  Widget? icon;
  List<AmazingOfferItem> items;
  double itemAspect;
  double radius;
  String Function(int) ?priceBuilder;
  String Function(int) ?offerBuilder;
  Widget Function(String) ?coverBuilder;


  void Function()? onMoreTap;
  AmazingOffer({
    super.key,
    this.height = 250,
    this.padding,
    this.contentPadding,
    this.title,
    this.icon,
    this.titleStyle,
    this.moreStyle,
    this.itemAspect = 4 / 7,
    this.radius = 10,
    this.onMoreTap,
    this.priceBuilder,
    this.offerBuilder,
    this.coverBuilder,
    required this.items,
    BoxDecoration? decoration,
  }) : decoration =
           decoration ??
           BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
               colors: [Colors.red, Colors.redAccent],
             ),
           );

  @override
  State<AmazingOffer> createState() => _AmazingOfferState();
}

class _AmazingOfferState extends State<AmazingOffer> {
  double get height => widget.height;
  EdgeInsetsGeometry get padding => widget.padding ?? EdgeInsets.zero;
  EdgeInsetsGeometry get contentPadding =>
      widget.contentPadding ?? EdgeInsets.all(10);

  BoxDecoration get decoration => widget.decoration;
  String? get title => widget.title;
  Widget? get icon => widget.icon;
  TextStyle get titleStyle =>
      widget.titleStyle ??
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19);

  TextStyle get moreStyle =>
      widget.moreStyle ??
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: padding,
          alignment: Alignment.center,
          child: Container(
            decoration: decoration,
            height: height,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: contentPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (icon != null) icon!,
                          if (title != null) Text(title!, style: titleStyle),
                        ],
                      ),

                      GestureDetector(
                        onTap: () {
                          widget.onMoreTap?.call();
                        },
                        child: Text("همه", style: moreStyle),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: Padding(
                        padding: contentPadding,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(widget.radius),
                          child: Row(
                            spacing: 2,
                            children: [
                              ...widget.items.map((item) {
                                return _buildAmazingOfferItem(item);
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmazingOfferItem(AmazingOfferItem item) {
    return GestureDetector(
      onTap: () {
        item.onTap();
      },
      child: AspectRatio(
        aspectRatio: widget.itemAspect,
        child: Container(
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  
                  child: widget.coverBuilder?.call(item.cover),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(
                  item.name,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: item.nameStyle,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                 item.offer == null?'':widget.offerBuilder?.call(item.offer!) ?? item.offer!.toString(),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: item.offserStyle,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                 widget.priceBuilder?.call(item.price) ?? item.price.toString(),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: item.priceStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
