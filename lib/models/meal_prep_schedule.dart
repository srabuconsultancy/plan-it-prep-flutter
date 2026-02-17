class MealPrepSchedule {
  int id = 0;
  String name = "";

  MealPrepSchedule(); // Default constructor

  // --- UPDATED: fromJson constructor with try...catch ---
  MealPrepSchedule.fromJson(Map<String, dynamic> json) {
    try {
      id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print("Failed to parse MealPrepSchedule: $e");
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
