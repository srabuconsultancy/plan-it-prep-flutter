class MealPlanFoodItem {
  int? id;
  String? name;
  int? foodGroupId;
  String? servingSize;
  String? servingUnit;
  String? calories;
  String? totalFat;
  String? saturatedFat;
  String? transFat;
  String? monounsaturatedFat;
  String? polyunsaturatedFat;
  String? cholesterol;
  String? sodium;
  String? totalCarbohydrates;
  String? dietaryFiber;
  String? sugars;
  String? addedSugars;
  String? protein;
  String? vitaminA;
  String? vitaminC;
  String? calcium;
  String? iron;
  String? potassium;
  String? vitaminD;
  String? vitaminB6;
  String? vitaminB12;
  String? magnesium;
  String? glycemicIndex;
  String? comments;
  int? active;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  String? calorieUnit;
  String? type;

  MealPlanFoodItem({
    this.id = 0,
    this.name = '',
    this.foodGroupId = 0,
    this.servingSize = '',
    this.servingUnit = '',
    this.calories = '',
    this.totalFat = '',
    this.saturatedFat = '',
    this.transFat = '',
    this.monounsaturatedFat = '',
    this.polyunsaturatedFat = '',
    this.cholesterol = '',
    this.sodium = '',
    this.totalCarbohydrates = '',
    this.dietaryFiber = '',
    this.sugars = '',
    this.addedSugars = '',
    this.protein = '',
    this.vitaminA = '',
    this.vitaminC = '',
    this.calcium = '',
    this.iron = '',
    this.potassium = '',
    this.vitaminD = '',
    this.vitaminB6 = '',
    this.vitaminB12 = '',
    this.magnesium = '',
    this.glycemicIndex = '',
    this.comments,
    this.active = 1,
    this.image = '',
    this.calorieUnit = '',
    this.type = '',
    this.createdAt,
    this.updatedAt,
  });

  // fromJson factory method
  factory MealPlanFoodItem.fromJson(Map<String, dynamic> json) {
    return MealPlanFoodItem(
      id: json['id'] ?? 0,
      // name: Helper.convertToUnicode(json['name']) ?? '',
      name: json['name'] ?? '',
      foodGroupId: json['food_group_id'] ?? 0,
      servingSize: json['serving_size'] ?? '',
      servingUnit: json['serving_unit'] ?? '',
      calories: json['calories'] ?? '0',
      totalFat: json['total_fat'] ?? '0',
      saturatedFat: json['saturated_fat'] ?? '0',
      transFat: json['trans_fat'] ?? '0',
      monounsaturatedFat: json['monounsaturated_fat'] ?? '0',
      polyunsaturatedFat: json['polyunsaturated_fat'] ?? '0',
      cholesterol: json['cholesterol'] ?? '0',
      sodium: json['sodium'] ?? '0',
      totalCarbohydrates: json['total_carbohydrates'] ?? '0',
      dietaryFiber: json['dietary_fiber'] ?? '0',
      sugars: json['sugars'] ?? '0',
      addedSugars: json['added_sugars'] ?? '0',
      protein: json['protein'] ?? '0',
      vitaminA: json['vitamin_a'] ?? '0',
      vitaminC: json['vitamin_c'] ?? '0',
      calcium: json['calcium'] ?? '0',
      iron: json['iron'] ?? '0',
      potassium: json['potassium'] ?? '0',
      vitaminD: json['vitamin_d'] ?? '0',
      vitaminB6: json['vitamin_b6'] ?? '0',
      vitaminB12: json['vitamin_b12'] ?? '0',
      magnesium: json['magnesium'] ?? '0',
      glycemicIndex: json['glycemic_index'] ?? '0',
      comments: json['comments'] ?? '',
      active: json['active'] ?? 1,
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      calorieUnit: json['calorie_unit'] ?? 'kcal',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
