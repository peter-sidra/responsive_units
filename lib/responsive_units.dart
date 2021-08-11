library responsive_units;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A utility class that abstracts media queries
class _ResponsiveUnitsUtil {
  static MediaQueryData mediaQueryData = const MediaQueryData();

  static double get width => mediaQueryData.size.width;

  static double get height => mediaQueryData.size.height;

  static double get diagonal => sqrt(width * width + height * height);

  static double get safeWidth =>
      mediaQueryData.size.width -
      (mediaQueryData.padding.left + mediaQueryData.padding.right);

  static double get safeHeight =>
      mediaQueryData.size.height -
      (mediaQueryData.padding.top + mediaQueryData.padding.bottom);

  static double get safeDiagonal =>
      sqrt(safeWidth * safeWidth + safeHeight * safeHeight);

  static double get textScaleFactor => mediaQueryData.textScaleFactor;
}

/// This widget is intended to be inserted above the Navigator of
/// the WidgetsApp widget. This is typically accomplished by setting
/// the WidgetsApp's builder function as follows
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => AppSizer(
///     child: child,
///   ),
/// );
/// ```
class AppSizer extends StatelessWidget {
  /// The child widget that AppSizer will display
  final Widget? child;

  /// This flag informs [AppSizer] whether it should force a rebuild
  /// of the widget when the app's media query data changes
  ///
  /// If this flag is set to false, widgets that don't depend on media
  /// query in their build methods might not rebuild on size change events.
  /// However, calling the extension methods on num [.h, .w, .dg, etc.]
  /// would still return correct values
  final bool rebuildTree;

  const AppSizer({Key? key, this.child, this.rebuildTree = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    if (rebuildTree && mediaQueryData != _ResponsiveUnitsUtil.mediaQueryData) {
      _rebuildAllChildren(context);
    }

    _ResponsiveUnitsUtil.mediaQueryData = mediaQueryData;

    return child ?? const SizedBox();
  }
}

extension ResponsiveUnitsX on num {
  /// Returns height in pixels calculated as a percentage of the
  /// screen's height
  ///
  /// ex: ```50.h``` returns 50% of the screen's height
  double get h => this / 100 * _ResponsiveUnitsUtil.height;

  /// Returns width in pixels calculated as a percentage of the
  /// screen's width
  ///
  /// ex: ```50.w``` returns 50% of the screen's width
  double get w => this / 100 * _ResponsiveUnitsUtil.width;

  /// Returns diagonal length in pixels calculated as a percentage of the
  /// screen's diagonal length
  ///
  /// ex: ```50.dg``` returns 50% of the screen's diagonal
  ///
  /// This is useful for scaling text and corners
  double get dg => this / 100 * _ResponsiveUnitsUtil.diagonal;

  /// Returns the (safe) height in pixels calculated as a percentage of the
  /// screen's height excluding the parts of the display that are partially
  /// obscured by system UI (such as notches and the status bar)
  ///
  /// ex: ```50.sfh``` returns 50% of the screen's safe height
  double get sfh => this / 100 * _ResponsiveUnitsUtil.safeHeight;

  /// Returns the (safe) width in pixels calculated as a percentage of the
  /// screen's width excluding the parts of the display that are partially
  /// obscured by system UI (such as notches and the status bar)
  ///
  /// ex: ```50.sfw``` returns 50% of the screen's safe width
  double get sfw => this / 100 * _ResponsiveUnitsUtil.safeWidth;

  /// Returns the (safe) diagonal length in pixels calculated as a percentage
  /// of the screen's diagonal length excluding the parts of the display that
  /// are partially obscured by system UI (such as notches and the status bar)
  ///
  /// ex: ```50.sfdg``` returns 50% of the screen's safe diagonal
  ///
  /// This is useful for scaling text and corners
  double get sfdg => this / 100 * _ResponsiveUnitsUtil.safeDiagonal;

  /// Returns a scalable pixel value that scales with the user selected text
  /// scale factor
  double get sp => this * _ResponsiveUnitsUtil.textScaleFactor;
}

// https://stackoverflow.com/a/58513635
/// Rebuilds the entire widget tree below context
void _rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}
