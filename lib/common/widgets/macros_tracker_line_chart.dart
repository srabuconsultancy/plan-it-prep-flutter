// import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../core.dart';

// class MacrosTrackerLineChartSF extends StatelessWidget {
//   final List<Macros> data;
//   final List<String> bottomPoints;
//   final List<double> leftPoints;
//   final double interval;

//   const MacrosTrackerLineChartSF({
//     super.key,
//     required this.data,
//     required this.bottomPoints,
//     required this.leftPoints,
//     this.interval = 1,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.2,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 18, top: 10, bottom: 4),
//         child: SfCartesianChart(
//           primaryXAxis: CategoryAxis(
//             labelRotation: -25,
//             majorGridLines: const MajorGridLines(width: 0),
//           ),
//           primaryYAxis: NumericAxis(
//             interval: interval,
//             minimum: leftPoints.isNotEmpty ? leftPoints.first : 0,
//             maximum: leftPoints.isNotEmpty ? leftPoints.last : null,
//             majorGridLines: const MajorGridLines(width: 0.2),
//           ),
//           legend: const Legend(
//             isVisible: true,
//             toggleSeriesVisibility: true,
//           ),
//           tooltipBehavior: TooltipBehavior(enable: true),
//           series: <CartesianSeries>[
//             LineSeries<Macros, String>(
//               name: 'Calories',
//               dataSource: data,
//               xValueMapper: (Macros m, _) => m.date,
//               yValueMapper: (Macros m, _) => m.calories,
//               color: glCaloriesColor,
//               markerSettings: const MarkerSettings(isVisible: false),
//             ),
//             LineSeries<Macros, String>(
//               name: 'Carbs',
//               dataSource: data,
//               xValueMapper: (Macros m, _) => m.date,
//               yValueMapper: (Macros m, _) => m.carb,
//               color: glCarbColor,
//               markerSettings: const MarkerSettings(isVisible: false),
//             ),
//             LineSeries<Macros, String>(
//               name: 'Protein',
//               dataSource: data,
//               xValueMapper: (Macros m, _) => m.date,
//               yValueMapper: (Macros m, _) => m.protein,
//               color: glProteinColor,
//               markerSettings: const MarkerSettings(isVisible: false),
//             ),
//             LineSeries<Macros, String>(
//               name: 'Fat',
//               dataSource: data,
//               xValueMapper: (Macros m, _) => m.date,
//               yValueMapper: (Macros m, _) => m.fat,
//               color: glFatColor,
//               markerSettings: const MarkerSettings(isVisible: false),
//             ),
//             LineSeries<Macros, String>(
//               name: 'Fiber',
//               dataSource: data,
//               xValueMapper: (Macros m, _) => m.date,
//               yValueMapper: (Macros m, _) => m.fiber,
//               color: glFiberColor,
//               markerSettings: const MarkerSettings(isVisible: false),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// /*class MacrosTrackerLineChartSF extends StatefulWidget {
//   final List<Macros> data;
//   final List<String> bottomPoints;
//   final double interval;

//   const MacrosTrackerLineChartSF({
//     super.key,
//     required this.data,
//     required this.bottomPoints,
//     this.interval = 1,
//   });

//   @override
//   State<MacrosTrackerLineChartSF> createState() => _MacrosTrackerLineChartSFState();
// }

// class _MacrosTrackerLineChartSFState extends State<MacrosTrackerLineChartSF> {
//   final Map<String, bool> _visibility = {
//     'Calories': true,
//     'Carbs': true,
//     'Protein': true,
//     'Fat': true,
//     'Fiber': true,
//   };

//   double minY = 0;
//   double maxY = 100;

//   @override
//   void initState() {
//     super.initState();
//     _recalculateYAxis();
//   }

//   void _recalculateYAxis() {
//     List<double> values = [];
//     for (final e in widget.data) {
//       if (_visibility['Calories']!) values.add(e.calories.toDouble());
//       if (_visibility['Carbs']!) values.add(e.carb.toDouble());
//       if (_visibility['Protein']!) values.add(e.protein.toDouble());
//       if (_visibility['Fat']!) values.add(e.fat.toDouble());
//       if (_visibility['Fiber']!) values.add(e.fiber.toDouble());
//     }

//     if (values.isEmpty) {
//       minY = 0;
//       maxY = 100;
//     } else {
//       minY = values.reduce(min);
//       maxY = values.reduce(max);
//       maxY += 50; // padding
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _recalculateYAxis();

//     return AspectRatio(
//       aspectRatio: 1.2,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         child: SfCartesianChart(
//           legend: Legend(
//             isVisible: true,
//             // toggleSeriesVisibility: false,
//             toggleSeriesVisibility: true,
//             position: LegendPosition.bottom,
//           ),
//           onLegendTapped: (LegendTapArgs args) {
//             final seriesName = args.series.name;
//             //print("onLegendTapped $seriesName");

//             if (seriesName != null) {
//               setState(() {
//                 _visibility[seriesName] = !(_visibility[seriesName] ?? true);
//               });
//             }
//           },
//           primaryXAxis: CategoryAxis(
//             labelRotation: -25,
//             majorGridLines: const MajorGridLines(width: 0),
//           ),
//           primaryYAxis: NumericAxis(
//             minimum: minY,
//             maximum: maxY,
//             interval: widget.interval,
//             majorGridLines: const MajorGridLines(width: 0.2),
//           ),
//           tooltipBehavior: TooltipBehavior(enable: true),
//           series: <CartesianSeries>[
//             if (_visibility['Calories']!)
//               LineSeries<Macros, String>(
//                 name: 'Calories',
//                 dataSource: widget.data,
//                 xValueMapper: (Macros m, _) => m.date,
//                 yValueMapper: (Macros m, _) => m.calories,
//                 color: glCaloriesColor,
//                 markerSettings: const MarkerSettings(isVisible: false),
//               ),
//             if (_visibility['Carbs']!)
//               LineSeries<Macros, String>(
//                 name: 'Carbs',
//                 dataSource: widget.data,
//                 xValueMapper: (Macros m, _) => m.date,
//                 yValueMapper: (Macros m, _) => m.carb,
//                 color: glCarbColor,
//                 markerSettings: const MarkerSettings(isVisible: false),
//               ),
//             if (_visibility['Protein']!)
//               LineSeries<Macros, String>(
//                 name: 'Protein',
//                 dataSource: widget.data,
//                 xValueMapper: (Macros m, _) => m.date,
//                 yValueMapper: (Macros m, _) => m.protein,
//                 color: glProteinColor,
//                 markerSettings: const MarkerSettings(isVisible: false),
//               ),
//             if (_visibility['Fat']!)
//               LineSeries<Macros, String>(
//                 name: 'Fat',
//                 dataSource: widget.data,
//                 xValueMapper: (Macros m, _) => m.date,
//                 yValueMapper: (Macros m, _) => m.fat,
//                 color: glFatColor,
//                 markerSettings: const MarkerSettings(isVisible: false),
//               ),
//             if (_visibility['Fiber']!)
//               LineSeries<Macros, String>(
//                 name: 'Fiber',
//                 dataSource: widget.data,
//                 xValueMapper: (Macros m, _) => m.date,
//                 yValueMapper: (Macros m, _) => m.fiber,
//                 color: glFiberColor,
//                 markerSettings: const MarkerSettings(isVisible: false),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }*/

// class MacrosTrackerLineChartFL extends StatelessWidget {
//   const MacrosTrackerLineChartFL({
//     super.key,
//     this.data = const [],
//     this.bottomPoints = const [],
//     this.leftPoints = const [],
//     this.interval = 1,
//     this.betweenColor = Colors.transparent,
//   });

//   final List<Macros> data;
//   final List<String> bottomPoints;
//   final List<double> leftPoints;
//   final double interval;
//   final Color? betweenColor;

//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontSize: 8,
//       fontWeight: FontWeight.normal,
//     );

//     // //print("bottomTitleWidgets $value $bottomPoints");

//     return value.toInt() < bottomPoints.length
//         ? SideTitleWidget(
//             axisSide: meta.axisSide,
//             space: 4,
//             child: Transform.rotate(angle: -pi / 12.0, child: Text(bottomPoints[value.toInt()], style: style)),
//           )
//         : Container();
//   }

//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(fontSize: 8);

//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(
//         '$value',
//         style: style,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.2,
//       child: Padding(
//         padding: const EdgeInsets.only(
//           left: 10,
//           right: 18,
//           top: 10,
//           bottom: 4,
//         ),
//         child: LineChart(
//           LineChartData(
//             lineTouchData: const LineTouchData(enabled: true),
//             lineBarsData: [
//               LineChartBarData(
//                 spots: data.map((value) {
//                   double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//                   double y = value.calories.toDouble();
//                   return FlSpot(x, y);
//                 }).toList(),
//                 isCurved: true,
//                 preventCurveOverShooting: true,
//                 barWidth: 2,
//                 color: glLightThemeColor,
//                 dotData: const FlDotData(
//                   show: false,
//                 ),
//               ),
//               LineChartBarData(
//                 spots: data.map((value) {
//                   double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//                   double y = value.carb.toDouble();
//                   return FlSpot(x, y);
//                 }).toList(),
//                 isCurved: true,
//                 preventCurveOverShooting: true,
//                 barWidth: 2,
//                 color: glCarbColor,
//                 dotData: const FlDotData(
//                   show: false,
//                 ),
//               ),
//               LineChartBarData(
//                 spots: data.map((value) {
//                   double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//                   double y = value.protein.toDouble();
//                   return FlSpot(x, y);
//                 }).toList(),
//                 isCurved: true,
//                 preventCurveOverShooting: true,
//                 barWidth: 2,
//                 color: glProteinColor,
//                 dotData: const FlDotData(
//                   show: false,
//                 ),
//               ),
//               LineChartBarData(
//                 spots: data.map((value) {
//                   double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//                   double y = value.fat.toDouble();
//                   return FlSpot(x, y);
//                 }).toList(),
//                 isCurved: true,
//                 preventCurveOverShooting: true,
//                 barWidth: 2,
//                 color: glFatColor,
//                 dotData: const FlDotData(
//                   show: false,
//                 ),
//               ),
//               LineChartBarData(
//                 spots: data.map((value) {
//                   double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//                   double y = value.fiber.toDouble();
//                   return FlSpot(x, y);
//                 }).toList(),
//                 isCurved: true,
//                 preventCurveOverShooting: true,
//                 barWidth: 2,
//                 color: glFiberColor,
//                 dotData: const FlDotData(
//                   show: false,
//                 ),
//               ),
//             ],
//             betweenBarsData: [
//               BetweenBarsData(
//                 fromIndex: 0,
//                 toIndex: 1,
//                 color: betweenColor,
//               )
//             ],
//             minY: leftPoints.first,
//             maxY: leftPoints.last,
//             borderData: FlBorderData(
//               show: false,
//             ),
//             titlesData: FlTitlesData(
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   interval: 1,
//                   getTitlesWidget: bottomTitleWidgets,
//                 ),
//               ),
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: leftTitleWidgets,
//                   interval: interval,
//                   reservedSize: 42,
//                   maxIncluded: true,
//                   minIncluded: true,
//                 ),
//               ),
//               topTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//               rightTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),
//             ),
//             gridData: FlGridData(
//               show: true,
//               drawVerticalLine: false,
//               horizontalInterval: 1,
//               checkToShowHorizontalLine: (double value) {
//                 return value == 1 || value == 6 || value == 4 || value == 5;
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
