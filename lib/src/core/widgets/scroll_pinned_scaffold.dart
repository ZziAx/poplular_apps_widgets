
import 'package:flutter/material.dart';
import 'package:popular_apps_widgets/src/controllers/scroll_pinned_scaffold_controller.dart';

/// A scaffold with a scrollable body and a header that can be pinned.
///
/// The widget provides three main visual sections:
/// - [fixed]: A widget that remains fixed on the screen.
/// - [pinned]: A widget that moves according to the scroll position.
/// - [hiddenWhenScroll]: An optional widget that fades out as the user scrolls.
///
/// When the scroll offset crosses [threshold], the scroll position can
/// automatically snap to either the expanded or collapsed position.
///
/// The [controller] allows external code to control the pinned state
/// and receive scroll-related opacity updates.
class ScrollPinnedScaffold extends StatefulWidget {
  /// The main scrollable content.
  final Widget body;

  /// A widget that remains fixed above the scrollable content.
  final Widget fixed;

  /// A widget positioned according to the current scroll offset.
  final Widget pinned;

  /// An optional widget that fades out while scrolling.
  final Widget? hiddenWhenScroll;

  /// The scroll offset at which the header is considered collapsed.
  ///
  /// Must be greater than zero.
  final double threshold;

  /// An optional externally managed scroll controller.
  ///
  /// If omitted, the widget creates and manages its own controller.
  final ScrollController? scrollController;

  /// Horizontal and vertical padding around the scrollable content.
  final EdgeInsetsGeometry padding;

  /// The scaffold's background color.
  final Color backgroundColor;

  /// Controller used to communicate pinning state and opacity.
  final ScrollPinnedScaffoldController controller;

  const ScrollPinnedScaffold({
    super.key,
    required this.body,
    required this.fixed,
    required this.pinned,
    required this.controller,
    this.hiddenWhenScroll,
    this.threshold = 35,
    this.scrollController,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
  }) : assert(threshold > 0, 'Threshold must be greater than zero.');

  @override
  State<ScrollPinnedScaffold> createState() =>
      _ScrollPinnedScaffoldState();
}

class _ScrollPinnedScaffoldState extends State<ScrollPinnedScaffold> {
  /// The scroll controller currently attached to the scroll view.
  late ScrollController _scrollController;

  /// Whether this state owns the scroll controller.
  ///
  /// Externally provided controllers must not be disposed here.
  late bool _ownsScrollController;

  /// Current scroll offset, clamped to the header's collapse range.
  double _scrollDelta = 0;

  /// Current opacity of the widget that hides during scrolling.
  double get _headerOpacity =>
      (1 - (_scrollDelta / widget.threshold)).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();

    _initializeScrollController();
  }

  /// Initializes the scroll controller and attaches its listener.
  void _initializeScrollController() {
    _ownsScrollController = widget.scrollController == null;

    _scrollController =
        widget.scrollController ?? ScrollController();

    _scrollController.addListener(_handleScroll);
  }

  /// Updates the scroll state and notifies the external controller.
  ///
  /// The scroll delta is clamped so that header animations remain
  /// within the range of zero to [ScrollPinnedScaffold.threshold].
  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;

    setState(() {
      _scrollDelta = offset.clamp(0.0, widget.threshold);
    });

    widget.controller.fade(_headerOpacity);
  }

  /// Animates the scroll view to the expanded or collapsed position.
  ///
  /// Called when the user releases a pointer after scrolling.
  void _snapScrollPosition() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final midpoint = widget.threshold / 2;

    // Ignore offsets outside the header's snapping range.
    if (offset >= widget.threshold) return;

    // Calculate a short animation duration proportional to the
    // current scroll position.
    final durationMs =
        ((offset / widget.threshold) * 100).round().clamp(1, 100);

    if (offset < midpoint) {
      // Expand the header.
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.linear,
      );

      widget.controller.pin();
    } else {
      // Collapse the header.
      _scrollController.animateTo(
        widget.threshold,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.linear,
      );

      widget.controller.unpin();
    }
  }

  @override
  void didUpdateWidget(covariant ScrollPinnedScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reattach the listener if the supplied scroll controller changes.
    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController.removeListener(_handleScroll);

      if (_ownsScrollController) {
        _scrollController.dispose();
      }

      _initializeScrollController();
      _handleScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaPadding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Padding(
        // Account for the system status bar and bottom safe area.
        padding: EdgeInsets.only(
          top: mediaPadding.top,
          bottom: mediaPadding.bottom,
        ),
        child: Stack(
          children: [
            // Main scrollable content.
            Padding(
              padding: widget.padding,
              child: Listener(
                // Detect when the user releases their pointer to
                // determine whether the header should snap.
                onPointerUp: (_) => _snapScrollPosition(),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    spacing: 4,
                    children: [
                      const SizedBox(height: 10),

                      // Optional header that fades and collapses
                      // as the user scrolls.
                      if (widget.hiddenWhenScroll != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.threshold - _scrollDelta,
                          ),
                          child: Opacity(
                            opacity: _headerOpacity,
                            child: widget.hiddenWhenScroll!,
                          ),
                        ),

                      const SizedBox(height: 40),

                      // Main page content.
                      widget.body,
                    ],
                  ),
                ),
              ),
            ),

            // Pinned content moves with the scroll position.
            Padding(
              padding: EdgeInsets.only(
                top: widget.threshold - _scrollDelta + 60,
              ),
              child: widget.pinned,
            ),

            // Fixed content stays above the other layers.
            Stack(
              children: [
                widget.fixed,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Always detach the listener before disposing the state.
    _scrollController.removeListener(_handleScroll);

    // Dispose only controllers created by this widget.
    if (_ownsScrollController) {
      _scrollController.dispose();
    }

    super.dispose();
  }
}