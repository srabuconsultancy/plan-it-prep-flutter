import '../core.dart';

class Meal {
  int? id;
  String? name;
  String? image;
  List<MealPlanFoodItem>? mealPlanItems;
  Macros? macros;

  Meal({
    this.id = 0,
    this.name = '',
    this.image = '',
    this.mealPlanItems = const [],
    this.macros,
  });

  // fromJson factory method
  factory Meal.fromJson(Map<String, dynamic> json) {
    List<MealPlanFoodItem> mealPlanItems = (json['meal_plan_items'] != null) ? Helper.parseItem(json['meal_plan_items'], MealPlanFoodItem.fromJson) : [];
    return Meal(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      mealPlanItems: mealPlanItems,
      macros: json['macros'] != null ? Macros.fromJson(json['macros']) : Macros(),
    );
  }
}
