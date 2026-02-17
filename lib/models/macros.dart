import 'dart:ui';

class Macros {
  String date = "";
  num calories = 0;
  num carb = 0;
  num protein = 0;
  num fat = 0;
  num fiber = 0;
  num water = 0;

  Macros();

  Macros.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)
    // //print("Macros.fromJson json: $json");
    try {
      date = json['date'] ?? "";
      calories = json['calories'] ?? json['total_calories'] ?? 0;
      carb = json['carb'] ?? json['total_carbs'] ?? 0;
      protein = json['protein'] ?? json['total_protein'] ?? 0;
      fat = json['fat'] ?? json['total_fat'] ?? 0;
      fiber = json['fiber'] ?? 0;
      water = json['water'] ?? 0;
    } catch (e, s) {
      print("Macros.fromJson $e $s");
      date = "";
      calories = 0;
      carb = 0;
      protein = 0;
      fat = 0;
      fiber = 0;
      water = 0;
    }
  }
  Map<String, dynamic> toJson() {
    // //print("toJson this $this");
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['date'] = date;
    data['calories'] = calories;
    data['carb'] = carb;
    data['protein'] = protein;
    data['fat'] = fat;
    data['fiber'] = fiber;
    data['water'] = water;
    return data;
  }
}

class MacroData {
  final String name;
  final double value;
  final Color color;

  MacroData({required this.name, required this.value, required this.color});
}
