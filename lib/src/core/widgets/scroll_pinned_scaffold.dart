import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold.dart';

class ScrollPinnedScaffold extends StatefulWidget {
  Widget fixed;
  Widget pinned;
  Widget? hiddenWhenScroll;
  Widget body;
  double threshold;
  ScrollController? scrollController;
  EdgeInsetsGeometry padding;
  Color backgroundColor;
  ScrollPinnedScaffoldController controller;
  ScrollPinnedScaffold({
    super.key,
    required this.body,
    required this.fixed,
    required this.pinned,
    required this.controller,
    this.hiddenWhenScroll,
    this.threshold = 35,
    this.scrollController,
    this.backgroundColor = Colors.white,
    EdgeInsetsGeometry? padding,
  }) : padding = padding ?? EdgeInsets.symmetric(horizontal: 10);

  @override
  State<ScrollPinnedScaffold> createState() => _ScrollPinnedScaffoldState();
}

class _ScrollPinnedScaffoldState extends State<ScrollPinnedScaffold>
    with SingleTickerProviderStateMixin {
  double get threshold => widget.threshold;
  Widget? get hiddenWhenScroll => widget.hiddenWhenScroll;
  Widget get fixed => widget.fixed;
  Widget get body => widget.body;
  EdgeInsetsGeometry get padding => widget.padding;
  Color get backgroundColor => widget.backgroundColor;

  late final AnimationController animationController;
  late final ScrollController scrollController;
  late double scrollStartedOffset;
  double scrollDelta = 0;
  bool get pinned =>scrollController.hasClients? scrollController.offset < threshold/2:true;
  // Color = 0;
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.addListener(() {
      setState(() {});
    });

    scrollController.addListener(() {
      scrollDelta = (scrollController.offset).clamp(0, threshold);
      widget.controller.fade((1 - (scrollDelta / threshold)).clamp(0, 1));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Stack(
          children: [
            Padding(
              padding: padding,
              child: Listener(
                onPointerDown: (_) {
                  scrollStartedOffset = scrollController.offset;
                },
                onPointerUp: (_) {
                  double offset = scrollController.offset;
                  final duration = ((offset / threshold) * 100).toInt();
              
                  if (offset < threshold / 2) {
                    scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: duration),
                      curve: Curves.linear,
                    );
                    widget.controller.pin();
                  } else if (offset > threshold / 2 && offset < threshold) {
                    scrollController.animateTo(
                      threshold,
                      duration: Duration(milliseconds: duration),
                      curve: Curves.linear,
                    );
                    widget.controller.unpin();
                  }
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    spacing: 4,
                    children: [
                      SizedBox(height: 10),
                      if (hiddenWhenScroll != null)
                        Padding(
                          padding: EdgeInsets.only(top: threshold - scrollDelta),
                          child: Opacity(
                            opacity: (1 - (scrollDelta / threshold)).clamp(0, 1),
                            child: hiddenWhenScroll!,
                          ),
                        ),
                  SizedBox(height: 40,),
                      body,
                    ],
                  ),
                ),
              ),
            ),
                Padding(
                        padding: EdgeInsets.only(top: threshold-scrollDelta+60),
                        child: widget.pinned,
                      ),
            Stack(children: [fixed]),
           
          ],
        ),
      ),
    );
  }
}
