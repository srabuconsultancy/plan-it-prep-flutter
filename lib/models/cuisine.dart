class Cuisine {
  int id = 0;
  String name = "";

  Cuisine(); // Default constructor

  // Add this for easy comparison in the .contains() check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cuisine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // --- UPDATED: fromJson constructor with try...catch ---
  Cuisine.fromJson(Map<String, dynamic> json) {
    try {
      id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print("Failed to parse Cuisine: $e");
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