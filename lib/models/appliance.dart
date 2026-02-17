class Appliance {
  int id = 0;
  String name = "";

  Appliance(); // Default constructor

  // Add this for easy comparison in the .contains() check
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Appliance && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // --- UPDATED: fromJson constructor with try...catch ---
  Appliance.fromJson(Map<String, dynamic> json) {
    try {
      id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
      name = json['name']?.toString() ?? '';
    } catch (e) {
      print("Failed to parse Appliance: $e");
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