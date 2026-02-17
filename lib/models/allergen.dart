class Allergen {
  int id = 0;
  String name = "";
  String image = "";

  Allergen();

  Allergen.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)
    // //print("Allergen.fromJson json: $json");

    try {
      id = json['id'] ?? 0;
      name = json['name'] ?? "";
      image = json['image'] ?? "";
    } catch (e) {
      id = 0;
      name = "";
      image = "";
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}
