
import 'dart:async';

/// Controls the pinned state and fade opacity of a [ScrollPinnedScaffold].
///
/// This controller exposes streams that allow widgets to react to changes
/// in the pinned state and header opacity.
///
/// Example:
/// ```dart
/// final controller = ScrollPinnedScaffoldController();
///
/// controller.pinStream.listen((pinned) {
///   debugPrint('Pinned: $pinned');
/// });
///
/// controller.fadeStream.listen((opacity) {
///   debugPrint('Opacity: $opacity');
/// });
///
/// // Release resources when no longer needed.
/// controller.dispose();
/// ```
class ScrollPinnedScaffoldController {
  /// Internal stream controller for pin state changes.
  final StreamController<bool> _pinController =
      StreamController<bool>.broadcast();

  /// Internal stream controller for fade opacity changes.
  final StreamController<double> _fadeController =
      StreamController<double>.broadcast();

  /// Current pinned state.
  bool _pinned = false;

  /// Current fade opacity, ranging from 0.0 to 1.0.
  double _opacity = 1.0;

  /// Whether this controller has been disposed.
  bool _disposed = false;

  /// Read-only stream of pin state changes.
  ///
  /// Emits `true` when pinned and `false` when unpinned.
  Stream<bool> get pinStream => _pinController.stream;

  /// Read-only stream of opacity changes.
  ///
  /// Values are clamped between `0.0` and `1.0`.
  Stream<double> get fadeStream => _fadeController.stream;

  /// Returns whether the scaffold is currently pinned.
  bool get pinned => _pinned;

  /// Returns the current opacity.
  double get opacity => _opacity;

  /// Returns whether the controller has been disposed.
  bool get isDisposed => _disposed;

  /// Updates the fade opacity and notifies listeners.
  ///
  /// Values outside the valid opacity range are clamped.
  /// Repeated values are ignored to avoid unnecessary events.
  void fade(double opacity) {
    if (_disposed) return;

    final newOpacity = opacity.clamp(0.0, 1.0);

    if (_opacity == newOpacity) return;

    _opacity = newOpacity;
    _fadeController.add(_opacity);
  }

  /// Sets the pinned state to `true` and notifies listeners.
  ///
  /// Does nothing if the scaffold is already pinned.
  void pin() {
    _setPinned(true);
  }

  /// Sets the pinned state to `false` and notifies listeners.
  ///
  /// Does nothing if the scaffold is already unpinned.
  void unpin() {
    _setPinned(false);
  }

  /// Updates the pinned state and emits an event only when it changes.
  void _setPinned(bool value) {
    if (_disposed || _pinned == value) return;

    _pinned = value;
    _pinController.add(_pinned);
  }

  /// Closes the internal stream controllers and releases resources.
  ///
  /// After disposal, further updates are ignored.
  /// This method is safe to call more than once.
  Future<void> dispose() async {
    if (_disposed) return;

    _disposed = true;

    await Future.wait([
      _pinController.close(),
      _fadeController.close(),
    ]);
  }
}