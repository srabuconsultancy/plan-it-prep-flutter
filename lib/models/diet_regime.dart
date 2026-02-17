class DietRegime {
  int id = 0;
  String title = "";
  String image = "";
  String details = "";

  DietRegime();

  DietRegime.fromJson(Map<String, dynamic> json) {
    // Print some details about the parsing process (optional)
    // //print("Goal.fromJson json: $json");

    try {
      id = json['id'] ?? 0;
      title = json['title'] ?? "";
      image = json['image'] ?? "";
      details = json['details'] ?? "";
    } catch (e) {
      id = 0;
      title = "";
      image = "";
      details = "";
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'details': details,
      };
}
