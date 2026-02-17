// import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../core.dart';

// class IndividualMacrosTrackerLineChart extends StatelessWidget {
//   const IndividualMacrosTrackerLineChart({
//     super.key,
//     this.data = const [],
//     this.bottomPoints = const [],
//     this.leftPoints = const [],
//     this.interval = 1,
//     this.dailyValue = 0,
//     this.macroLineColor = Colors.black,
//     required this.macroName,
//     this.betweenColor = Colors.transparent,
//   });

//   final List<Macros> data;
//   final List<String> bottomPoints;
//   final List<double> leftPoints;
//   final double interval;
//   final double dailyValue;
//   final String macroName;
//   final Color macroLineColor;
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
//     return Card(
//       child: AspectRatio(
//         aspectRatio: 1.2,
//         child: Stack(
//           children: [
//             Positioned(
//               top: -5,
//               left: 0,
//               right: 0,
//               child: macroName.capitalized.text
//                   .color(
//                     macroName == "calories"
//                         ? glCaloriesColor
//                         : macroName == "carb"
//                             ? glCarbColor
//                             : macroName == "protein"
//                                 ? glProteinColor
//                                 : macroName == "fat"
//                                     ? glFatColor
//                                     : macroName == "fiber"
//                                         ? glFiberColor
//                                         : glWaterColor,
//                   )
//                   .size(20)
//                   .make()
//                   .centered(),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 10,
//                 right: 18,
//                 top: 10,
//                 bottom: 4,
//               ),
//               child: Transform.translate(
//                 offset: const Offset(-10, 0),
//                 child: buildLineChart(),
//               ),
//             ),
//             /*Positioned(
//               bottom: 30,
//               right: 20,
//               child: const Icon(Icons.fullscreen).onInkTap(
//                 () {
//                   //print("asdasdasdasd");
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Stack(
//                         children: [
//                           Positioned(
//                             top: -5,
//                             left: 0,
//                             right: 0,
//                             child: macroName.capitalized.text
//                                 .color(
//                                   macroName == "calories"
//                                       ? glCaloriesColor
//                                       : macroName == "carb"
//                                           ? glCarbColor
//                                           : macroName == "protein"
//                                               ? glProteinColor
//                                               : macroName == "fat"
//                                                   ? glFatColor
//                                                   : macroName == "fiber"
//                                                       ? glFiberColor
//                                                       : glWaterColor,
//                                 )
//                                 .size(20)
//                                 .make()
//                                 .centered(),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 10,
//                               right: 18,
//                               top: 10,
//                               bottom: 4,
//                             ),
//                             child: buildLineChart(),
//                           ),
//                           */ /*Positioned(
//                             bottom: 30,
//                             right: 20,
//                             child: const Icon(Icons.fullscreen_exit).onInkTap(
//                               () {
//                                 //print("asdasdasdasd");
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),*/ /*
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),*/
//           ],
//         ),
//       ).pSymmetric(v: 10),
//     );
//   }

//   LineChart buildLineChart() {
//     return LineChart(
//       LineChartData(
//         lineTouchData: const LineTouchData(enabled: true),
//         lineBarsData: [
//           LineChartBarData(
//             spots: data.map((value) {
//               var macrosMap = value.toJson();
//               double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//               double y = macrosMap[macroName].toDouble();
//               //print("LineChartBarDatay1 $x $y");
//               return FlSpot(x, y);
//             }).toList(),
//             isCurved: true,
//             preventCurveOverShooting: true,
//             barWidth: 2,
//             color: macroLineColor,
//             dotData: const FlDotData(
//               show: false,
//             ),
//           ),
//           LineChartBarData(
//             spots: data.map((value) {
//               double x = bottomPoints.indexWhere((element) => element == value.date).toDouble();
//               double y = dailyValue.toDouble();
//               //print("LineChartBarDatay $x $y");
//               return FlSpot(x, y);
//             }).toList(),
//             isCurved: true,
//             preventCurveOverShooting: true,
//             barWidth: 2,
//             color: Colors.black,
//             dotData: const FlDotData(
//               show: false,
//             ),
//           ),
//         ],
//         betweenBarsData: [
//           BetweenBarsData(
//             fromIndex: 0,
//             toIndex: 1,
//             color: betweenColor,
//           )
//         ],
//         minY: leftPoints.first,
//         maxY: leftPoints.last,
//         borderData: FlBorderData(
//           show: false,
//         ),
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               interval: 1,
//               getTitlesWidget: bottomTitleWidgets,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: leftTitleWidgets,
//               interval: interval,
//               reservedSize: 42,
//               maxIncluded: true,
//               minIncluded: true,
//             ),
//           ),
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           rightTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//         ),
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: false,
//           horizontalInterval: 1,
//           checkToShowHorizontalLine: (double value) {
//             return value == 1 || value == 6 || value == 4 || value == 5;
//           },
//         ),
//       ),
//     );
//   }
// }

// class IndividualMacrosTrackerLineChartSF extends StatelessWidget {
//   final List<Macros> data;
//   final List<String> bottomPoints;
//   final List<double> leftPoints;
//   final double dailyValue;
//   final double interval;
//   final String macroName;
//   final Color macroLineColor;

//   const IndividualMacrosTrackerLineChartSF({
//     super.key,
//     required this.data,
//     required this.bottomPoints,
//     required this.leftPoints,
//     required this.dailyValue,
//     required this.interval,
//     required this.macroName,
//     this.macroLineColor = Colors.black,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double minY = leftPoints.isNotEmpty ? leftPoints.first : 0;
//     double maxY = leftPoints.isNotEmpty ? leftPoints.last : 100;

//     return Card(
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: Stack(
//           children: [
//             Positioned(
//               top: 5,
//               left: 10,
//               right: 10,
//               child: Text(
//                 macroName[0].toUpperCase() + macroName.substring(1),
//                 style: TextStyle(fontSize: 18, color: macroLineColor),
//                 textAlign: TextAlign.center,
//               ).pOnly(bottom: 10),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 30),
//               child: SfCartesianChart(
//                 primaryXAxis: CategoryAxis(
//                   labelRotation: -25,
//                   majorGridLines: const MajorGridLines(width: 0),
//                 ),
//                 primaryYAxis: NumericAxis(
//                   interval: interval,
//                   minimum: minY,
//                   maximum: maxY,
//                   majorGridLines: const MajorGridLines(width: 0.2),
//                 ),
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 series: <CartesianSeries<Macros, String>>[
//                   LineSeries<Macros, String>(
//                     name: macroName,
//                     dataSource: data,
//                     xValueMapper: (Macros m, _) => m.date,
//                     yValueMapper: (Macros m, _) => m.toJson()[macroName].toDouble(),
//                     color: macroLineColor,
//                     markerSettings: const MarkerSettings(isVisible: false),
//                     dataLabelSettings: const DataLabelSettings(isVisible: false),
//                   ),
//                   LineSeries<Macros, String>(
//                     name: 'Daily Goal',
//                     dataSource: data,
//                     xValueMapper: (Macros m, _) => m.date,
//                     yValueMapper: (Macros m, _) => dailyValue,
//                     color: Colors.black,
//                     dashArray: <double>[5, 5],
//                     markerSettings: const MarkerSettings(isVisible: false),
//                     dataLabelSettings: const DataLabelSettings(isVisible: false),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
