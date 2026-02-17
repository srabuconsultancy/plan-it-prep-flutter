import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core.dart';

class WeightTrackerLineChart extends StatelessWidget {
  const WeightTrackerLineChart({
    super.key,
    this.line1Color = const Color(0xFFFFB300),
    this.line2Color = const Color(0xFF4CAF50),
    this.betweenColor = Colors.transparent,
    this.data = const [],
    this.bottomPoints = const [],
    this.leftPoints = const [],
  });

  final Color? line1Color;
  final Color? line2Color;
  final Color? betweenColor;
  final List<WeightTracking> data;
  final List<String> bottomPoints;
  final List<double> leftPoints;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 8,
      fontWeight: FontWeight.normal,
    );

    // //print("bottomTitleWidgets $value $bottomPoints");

    return value.toInt() < bottomPoints.length
        ? SideTitleWidget(
            axisSide: meta.axisSide,
            space: 4,
            child: Transform.rotate(angle: -pi / 12.0, child: Text(bottomPoints[value.toInt()], style: style)),
          )
        : Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 8);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '$value',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 18,
          top: 10,
          bottom: 4,
        ),
        child: LineChart(
          LineChartData(
            lineTouchData: const LineTouchData(enabled: true),
            lineBarsData: [
              LineChartBarData(
                spots: data.map((value) {
                  double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
                  double y = value.currentWeight;
                  return FlSpot(x, y);
                }).toList(),
                isCurved: true,
                barWidth: 2,
                color: line1Color,
                preventCurveOverShooting: true,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: data.map((value) {
                  double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
                  double y = value.targetWeight;
                  //print("x:$x y:$y");
                  return FlSpot(x, y);
                }).toList(),
                isCurved: false,
                barWidth: 2,
                color: line2Color,
                preventCurveOverShooting: true,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            betweenBarsData: [
              BetweenBarsData(
                fromIndex: 0,
                toIndex: 1,
                color: betweenColor,
              )
            ],
            minY: leftPoints.first,
            maxY: leftPoints.last,
            borderData: FlBorderData(
              show: false,
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitleWidgets,
                  interval: 1,
                  reservedSize: 32,
                  maxIncluded: true,
                  minIncluded: true,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              checkToShowHorizontalLine: (double value) {
                return value == 1 || value == 6 || value == 4 || value == 5;
              },
            ),
          ),
        ),
      ),
    );
  }
}
