library responsive_units;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A utility class acting as a namespace for the global
/// [_ResponsiveUnitsUtil.size] variable
class _ResponsiveUnitsUtil {
  static Size size = const Size(0, 0);
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

  /// This flag infroms [AppSizer] whether it should force a rebuild
  /// of the widget when the app's size changes
  ///
  /// If this flag is set to false, widgets that don't depend on media
  /// query in their build methods might not rebuild on size change events.
  /// However, calling the extension methods on num [.h, .w, .dg]
  /// would still return correct results
  final bool rebuildTree;

  const AppSizer({Key? key, this.child, this.rebuildTree = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (rebuildTree && size != _ResponsiveUnitsUtil.size) {
      _rebuildAllChildren(context);
    }

    _ResponsiveUnitsUtil.size = size;

    return child ?? const SizedBox();
  }
}

extension ResponsiveUnitsX on num {
  /// Returns height in pixels calculated as a percentage of the
  /// screen's height
  ///
  /// ex: ```50.h``` returns 50% of the screens height
  double get h => this / 100 * _ResponsiveUnitsUtil.size.height;

  /// Returns width in pixels calculated as a percentage of the
  /// screen's width
  ///
  /// ex: ```50.w``` returns 50% of the screens width
  double get w => this / 100 * _ResponsiveUnitsUtil.size.width;

  /// Returns diagonal lentgh in pixels calculated as a percentage of the
  /// screen's diagonal length
  ///
  /// ex: ```50.dg``` returns 50% of the screens diagonal
  ///
  /// This is useful for scaling text and corners
  double get dg =>
      this /
      100 *
      sqrt(_ResponsiveUnitsUtil.size.width * _ResponsiveUnitsUtil.size.width +
          _ResponsiveUnitsUtil.size.height * _ResponsiveUnitsUtil.size.height);
}

// https://stackoverflow.com/a/58513635
/// Rebuilds the enitre widget tree below context
void _rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}
