import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core.dart'; // adjust this path based on your project structure

class NutrientBarWidget extends StatelessWidget {
  final MealPlanFoodItem foodItem;
  final String label;
  final double? value;
  final String? unit;
  final Color color;

  const NutrientBarWidget({
    super.key,
    required this.foodItem,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  /// Returns nutrient value and unit based on label
  Map<String, dynamic> getNutrientInfo() {
    switch (label.toLowerCase()) {
      case 'protein':
        return {'value': double.parse(foodItem.protein!), 'unit': "g"};
      case 'carbs':
      case 'carbohydrates':
        return {'value': double.parse(foodItem.totalCarbohydrates!), 'unit': "g"};
      case 'fat':
        return {'value': double.parse(foodItem.totalFat!), 'unit': "g"};
      case 'fiber':
        return {'value': double.parse(foodItem.dietaryFiber!), 'unit': "g"};
      default:
        return {'value': 0.0, 'unit': 'g'};
    }
  }

  @override
  Widget build(BuildContext context) {
    final nutrient = getNutrientInfo();
    // //print("nutrient['value'] ${nutrient['value']} ${nutrient['value'].runtimeType}");
    final double nutrientValue = (nutrient['value'] ?? 0.0);

    final String nutrientUnit = nutrient['unit'] ?? 'g';

    final macros = DashboardService.to.data.value.todayMacros;
    final num maxValue = switch (label.toLowerCase()) {
      'protein' => macros.protein,
      'carbs' || 'carbohydrates' => macros.carb,
      'fat' => macros.fat,
      'fiber' => macros.fiber,
      _ => 1.0,
    };

    final progress = (nutrientValue / maxValue).clamp(0.01, 1.0);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${Helper.convertQuantityString(foodItem, value: nutrientValue.toStringAsFixed(1))} $nutrientUnit",
              style: Get.theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: Get.theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
