import 'package:flutter/material.dart';

import '../../../bar_chart/bar_chart_data.dart' show BarChartData;
import '../../../utils.dart';
import '../axis_chart_data.dart';
import '../axis_chart_helper.dart';
import 'side_titles_flex.dart';

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets get onlyTopBottom => EdgeInsets.only(
        top: top,
        bottom: bottom,
      );

  EdgeInsets get onlyLeftRight => EdgeInsets.only(
        left: left,
        right: right,
      );
}

class SideTitlesWidget extends StatelessWidget {
  const SideTitlesWidget({
    required this.side,
    required this.axisChartData,
    required this.parentSize,
    super.key,
  });

  final AxisSide side;
  final AxisChartData axisChartData;
  final Size parentSize;

  bool get isHorizontal => side == AxisSide.top || side == AxisSide.bottom;

  bool get isVertical => !isHorizontal;

  double get minX => axisChartData.minX;

  double get maxX => axisChartData.maxX;

  double get baselineX => axisChartData.baselineX;

  double get minY => axisChartData.minY;

  double get maxY => axisChartData.maxY;

  double get baselineY => axisChartData.baselineY;

  double get axisMin => isHorizontal ? minX : minY;

  double get axisMax => isHorizontal ? maxX : maxY;

  double get axisBaseLine => isHorizontal ? baselineX : baselineY;

  FlTitlesData get titlesData => axisChartData.titlesData;

  bool get isLeftOrTop => side == AxisSide.left || side == AxisSide.top;

  bool get isRightOrBottom => side == AxisSide.right || side == AxisSide.bottom;

  AxisTitles get axisTitles {
    switch (side) {
      case AxisSide.left:
        return titlesData.leftTitles;
      case AxisSide.top:
        return titlesData.topTitles;
      case AxisSide.right:
        return titlesData.rightTitles;
      case AxisSide.bottom:
        return titlesData.bottomTitles;
    }
  }

  SideTitles get sideTitles => axisTitles.sideTitles;

  Axis get direction => isHorizontal ? Axis.horizontal : Axis.vertical;

  Axis get counterDirection => isHorizontal ? Axis.vertical : Axis.horizontal;

  Alignment get alignment {
    switch (side) {
      case AxisSide.left:
        return Alignment.centerLeft;
      case AxisSide.top:
        return Alignment.topCenter;
      case AxisSide.right:
        return Alignment.centerRight;
      case AxisSide.bottom:
        return Alignment.bottomCenter;
    }
  }

  EdgeInsets get thisSidePadding {
    final titlesPadding = titlesData.allSidesPadding;
    final borderPadding = axisChartData.borderData.allSidesPadding;
    switch (side) {
      case AxisSide.right:
      case AxisSide.left:
        return titlesPadding.onlyTopBottom + borderPadding.onlyTopBottom;
      case AxisSide.top:
      case AxisSide.bottom:
        return titlesPadding.onlyLeftRight + borderPadding.onlyLeftRight;
    }
  }

  double get thisSidePaddingTotal {
    final borderPadding = axisChartData.borderData.allSidesPadding;
    final titlesPadding = titlesData.allSidesPadding;
    switch (side) {
      case AxisSide.right:
      case AxisSide.left:
        return titlesPadding.vertical + borderPadding.vertical;
      case AxisSide.top:
      case AxisSide.bottom:
        return titlesPadding.horizontal +
            borderPadding.horizontal +
            axisChartData.horizontalGap * 2;
    }
  }

  Iterable<double> _iterateHorizontalAxis({
    required double min,
    required double max,
    required double interval,
  }) sync* {
    // final double diff = max - min;
    // final count = diff ~/ interval;

    yield min;

    double axisSeek = min + interval;
    while (axisSeek <= max) {
      yield axisSeek.roundToDouble();
      axisSeek += interval;
    }
  }

  List<AxisSideTitleWidgetHolder> makeWidgets(
    BuildContext context,
    double axisViewSize,
    double axisMin,
    double axisMax,
    AxisSide side,
  ) {
    List<AxisSideTitleMetaData> axisPositions;
    final interval = sideTitles.interval ??
        ChartUtils().getEfficientInterval(
          axisViewSize,
          axisMax - axisMin,
          pixelPerInterval: sideTitles.titlesSize,
        );
    if (isHorizontal && axisChartData is BarChartData) {
      final barChartData = axisChartData as BarChartData;
      if (barChartData.barGroups.isEmpty) {
        return [];
      }
      final xLocations = barChartData.calculateGroupsX(axisViewSize);
      axisPositions = xLocations.asMap().entries.map((e) {
        final index = e.key;
        final xLocation = e.value;
        final xValue = barChartData.barGroups[index].x;
        return AxisSideTitleMetaData(xValue.toDouble(), xLocation);
      }).toList();
    } else {
      late final Iterable<double> axisValues;
      late final double axisDiff;
      late final double minY;
      if (isHorizontal) {
        axisValues = _iterateHorizontalAxis(
          min: axisMin,
          max: axisMax,
          interval: interval,
        );
        axisDiff = axisMax - axisMin;
        minY = axisMin;
      } else {
        axisValues = AxisChartHelper().iterateThroughAxis(
          min: axisMin,
          max: axisMax,
          baseLine: axisBaseLine,
          interval: interval,
          ceilMaxValue: true,
        );
        minY = interval * (axisMin / interval).floor();
        axisDiff = axisValues.last - minY;
      }

      axisPositions = axisValues.map((axisValue) {
        var portion = 0.0;
        if (axisDiff > 0) {
          portion = (axisValue - minY) / axisDiff;
        }

        if (isVertical) {
          portion = 1 - portion;
        }
        double axisLocation = portion * axisViewSize;
        if (isHorizontal) {
          axisLocation = axisChartData.horizontalGap + axisLocation;
        }

        return AxisSideTitleMetaData(axisValue, axisLocation);
      }).toList();
    }
    return axisPositions.map(
      (metaData) {
        return AxisSideTitleWidgetHolder(
          metaData,
          DefaultTextStyle(
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
            child: sideTitles.getTitlesWidget(
              metaData.axisValue,
              TitleMeta(
                min: axisMin,
                max: axisMax,
                appliedInterval: interval,
                sideTitles: sideTitles,
                formattedValue: ChartUtils().formatNumber(
                  axisMin,
                  axisMax,
                  metaData.axisValue,
                ),
                axisSide: side,
                parentAxisSize: axisViewSize,
                axisPosition: metaData.axisPixelLocation,
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!axisTitles.showAxisTitles && !axisTitles.showSideTitles) {
      return Container();
    }
    final axisViewSize = isHorizontal ? parentSize.width : parentSize.height;
    return Align(
      alignment: alignment,
      child: Flex(
        direction: counterDirection,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeftOrTop && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
          if (sideTitles.showTitles)
            Container(
              width: isHorizontal ? axisViewSize : sideTitles.reservedSize,
              height: isHorizontal ? sideTitles.reservedSize : axisViewSize,
              margin: thisSidePadding,
              child: SideTitlesFlex(
                direction: direction,
                axisSideMetaData: AxisSideMetaData(
                  axisMin,
                  axisMax,
                  axisViewSize - thisSidePaddingTotal,
                ),
                widgetHolders: makeWidgets(
                  context,
                  axisViewSize - thisSidePaddingTotal,
                  axisMin,
                  axisMax,
                  side,
                ),
              ),
            ),
          if (isRightOrBottom && axisTitles.axisNameWidget != null)
            _AxisTitleWidget(
              axisTitles: axisTitles,
              side: side,
              axisViewSize: axisViewSize,
            ),
        ],
      ),
    );
  }
}

class _AxisTitleWidget extends StatelessWidget {
  const _AxisTitleWidget({
    required this.axisTitles,
    required this.side,
    required this.axisViewSize,
  });

  final AxisTitles axisTitles;
  final AxisSide side;
  final double axisViewSize;

  int get axisNameQuarterTurns {
    switch (side) {
      case AxisSide.right:
        return 3;
      case AxisSide.left:
        return 3;
      case AxisSide.top:
        return 0;
      case AxisSide.bottom:
        return 0;
    }
  }

  bool get isHorizontal => side == AxisSide.top || side == AxisSide.bottom;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isHorizontal ? axisViewSize : axisTitles.axisNameSize,
      height: isHorizontal ? axisTitles.axisNameSize : axisViewSize,
      child: Center(
        child: RotatedBox(
          quarterTurns: axisNameQuarterTurns,
          child: axisTitles.axisNameWidget,
        ),
      ),
    );
  }
}
