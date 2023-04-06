import 'dart:math' as math;

import 'package:flutter/material.dart';

List<Widget> divideTiles({
  required Iterable<Widget> tiles,
  Widget? divider,
  BuildContext? context,
  Color? color,
  double? width,
}) {
  tiles = tiles.toList();

  if (tiles.isEmpty || tiles.length == 1) {
    return tiles.toList();
  }

  if (color != null || context != null) {
    Widget wrapTile(Widget tile) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            bottom: Divider.createBorderSide(
              context,
              color: color,
              width: width,
            ),
          ),
        ),
        child: tile,
      );
    }

    return <Widget>[
      ...tiles.take(tiles.length - 1).map(wrapTile),
      tiles.last,
    ];
  }

  final length = math.max(0, tiles.length * 2 - 1);

  return List.generate(
    length,
    (index) {
      final int itemIndex = index ~/ 2;
      if (index.isEven) {
        return tiles.toList()[itemIndex];
      } else {
        return divider ?? Divider(height: 0, thickness: width);
      }
    },
  );
}
