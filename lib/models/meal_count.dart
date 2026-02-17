class MealCount {
  int id = 0;
  String name = "";

  MealCount(); // Default constructor

  // --- UPDATED: fromJson constructor with try...catch ---
  MealCount.fromJson(Map<String, dynamic> json) {
    try {
      id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print("Failed to parse MealCount: $e");
      id = 0;
      name = "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}