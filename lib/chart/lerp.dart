import 'dart:ui';

import 'package:flutter/material.dart';

import 'bar_chart/bar_chart_data.dart';
import 'base/axis_chart/axis_chart_data.dart';
import 'line_chart/line_chart_data.dart';
import 'pie_chart/pie_chart_data.dart';

@visibleForTesting
List<T>? lerpList<T>(
  List<T>? a,
  List<T>? b,
  double t, {
  required T Function(T, T, double) lerp,
}) {
  if (a != null && b != null && a.length == b.length) {
    return List.generate(a.length, (i) {
      return lerp(a[i], b[i], t);
    });
  } else if (a != null && b != null) {
    return List.generate(b.length, (i) {
      return lerp(i >= a.length ? b[i] : a[i], b[i], t);
    });
  } else {
    return b;
  }
}

/// s [Color] list based on [t] value, check [Tween.lerp].
List<Color>? lerpColorList(List<Color>? a, List<Color>? b, double t) =>
    lerpList(a, b, t, lerp: lerpColor);

/// s [Color] based on [t] value, check [Color.lerp].
Color lerpColor(Color a, Color b, double t) => Color.lerp(a, b, t)!;

/// s [double] list based on [t] value, allows [double.infinity].
double? lerpDoubleAllowInfinity(double? a, double? b, double t) {
  if (a == b || (a?.isNaN == true) && (b?.isNaN == true)) {
    return a;
  }

  if (a!.isInfinite || b!.isInfinite) {
    return b;
  }
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return a * (1.0 - t) + b * t;
}

/// s [double] list based on [t] value, check [Tween.lerp].
List<double>? lerpDoubleList(List<double>? a, List<double>? b, double t) =>
    lerpList(a, b, t, lerp: lerpNonNullDouble);

/// s [int] list based on [t] value, check [Tween.lerp].
List<int>? lerpIntList(List<int>? a, List<int>? b, double t) =>
    lerpList(a, b, t, lerp: lerpInt);

/// s [int] list based on [t] value, check [Tween.lerp].
int lerpInt(int a, int b, double t) => (a + (b - a) * t).round();

@visibleForTesting
double lerpNonNullDouble(double a, double b, double t) => lerpDouble(a, b, t)!;

/// s [FlSpot] list based on [t] value, check [Tween.lerp].
List<FlSpot>? lerpFlSpotList(List<FlSpot>? a, List<FlSpot>? b, double t) =>
    lerpList(a, b, t, lerp: FlSpot.lerp);

/// s [HorizontalLine] list based on [t] value, check [Tween.lerp].
List<HorizontalLine>? lerpHorizontalLineList(
  List<HorizontalLine>? a,
  List<HorizontalLine>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: HorizontalLine.lerp);

/// s [VerticalLine] list based on [t] value, check [Tween.lerp].
List<VerticalLine>? lerpVerticalLineList(
  List<VerticalLine>? a,
  List<VerticalLine>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: VerticalLine.lerp);

///  [HorizontalRangeAnnotation] list based on [t] value, check
/// [Tween.lerp].
List<HorizontalRangeAnnotation>? lerpHorizontalRangeAnnotationList(
  List<HorizontalRangeAnnotation>? a,
  List<HorizontalRangeAnnotation>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: HorizontalRangeAnnotation.lerp);

/// s [VerticalRangeAnnotation] list based on [t] value, check [Tween.lerp].
List<VerticalRangeAnnotation>? lerpVerticalRangeAnnotationList(
  List<VerticalRangeAnnotation>? a,
  List<VerticalRangeAnnotation>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: VerticalRangeAnnotation.lerp);

/// s [LineChartBarData] list based on [t] value, check [Tween.lerp].
List<LineChartBarData>? lerpLineChartBarDataList(
  List<LineChartBarData>? a,
  List<LineChartBarData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: LineChartBarData.lerp);

/// s [BetweenBarsData] list based on [t] value, check [Tween.lerp].
List<BetweenBarsData>? lerpBetweenBarsDataList(
  List<BetweenBarsData>? a,
  List<BetweenBarsData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: BetweenBarsData.lerp);

/// s [BarChartGroupData] list based on [t] value, check [Tween.lerp].
List<BarChartGroupData>? lerpBarChartGroupDataList(
  List<BarChartGroupData>? a,
  List<BarChartGroupData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: BarChartGroupData.lerp);

/// s [BarChartRodData] list based on [t] value, check [Tween.lerp].
List<BarChartRodData>? lerpBarChartRodDataList(
  List<BarChartRodData>? a,
  List<BarChartRodData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: BarChartRodData.lerp);

/// s [PieChartSectionData] list based on [t] value, check [Tween.lerp].
List<PieChartSectionData>? lerpPieChartSectionDataList(
  List<PieChartSectionData>? a,
  List<PieChartSectionData>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: PieChartSectionData.lerp);

/// s [BarChartRodStackItem] list based on [t] value, check [Tween.lerp].
List<BarChartRodStackItem>? lerpBarChartRodStackList(
  List<BarChartRodStackItem>? a,
  List<BarChartRodStackItem>? b,
  double t,
) =>
    lerpList(a, b, t, lerp: BarChartRodStackItem.lerp);

/// s between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  final length = colors.length;
  if (stops.length != length) {
    /// provided gradientColorStops is invalid and we calculate it here
    stops = List.generate(length, (i) => (i + 1) / length);
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];

    final leftColor = colors[s];
    final rightColor = colors[s + 1];

    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
