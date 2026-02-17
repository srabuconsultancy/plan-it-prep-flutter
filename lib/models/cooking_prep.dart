class CookingPrep {
  int id = 0;
  String name = "";

  CookingPrep(); // Default constructor

  // --- UPDATED: fromJson constructor with try...catch ---
  CookingPrep.fromJson(Map<String, dynamic> json) {
    try {
      id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print("Failed to parse CookingPrep: $e");
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