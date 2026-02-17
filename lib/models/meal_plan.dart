import '../core.dart';

class MealPlan {
  bool? status;
  List<Meal> meals = [];

  MealPlan({
    this.status = true,
    this.meals = const [],
  });

  // fromJson factory method
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      status: json['status'] ?? false,
      meals: (json['data'] != null) ? Helper.parseItem(json['data'], Meal.fromJson) : [],
    );
  }
}
