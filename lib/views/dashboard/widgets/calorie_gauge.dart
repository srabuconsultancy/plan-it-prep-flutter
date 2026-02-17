import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../core.dart';

class CalorieGauge extends StatelessWidget {
  const CalorieGauge({
    super.key,
    this.totalCalories = 1800,
    this.consumedCalories = 1800,
  });

  final double totalCalories;
  final double consumedCalories;

  @override
  Widget build(BuildContext context) {
    double remainingCalories = totalCalories - consumedCalories;
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: totalCalories,
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          axisLineStyle: AxisLineStyle(
            thickness: 12,
            color: Colors.grey[200],
            thicknessUnit: GaugeSizeUnit.logicalPixel,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: consumedCalories,
              width: 12,
              color: Color(0xFF4DB6AC),
              gradient: SweepGradient(
                colors: <Color>[Color(0xFF4DB6AC), Color(0xFFA5D6A7)],
                stops: <double>[0.25, 0.75],
              ),
              cornerStyle: CornerStyle.bothCurve, // or startCurve, endCurve
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 0,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    remainingCalories.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4DB6AC),
                    ),
                  ),
                  Text(
                    "kcal left",
                    style: TextStyle(fontSize: 14, color: glShadeColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
