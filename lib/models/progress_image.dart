class ProgressImage {
  int id = 0;
  String image = "";

  DateTime uploadedAt = DateTime.now();

  ProgressImage({required id, required image, required uploadedAt});

  ProgressImage.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)
    // //print("ProgressImage.fromJson json: $json");
    try {
      id = json['id'] ?? 0;
      image = json['image'] ?? "";
      uploadedAt = json['created_At'] == null || json['created_At'] == "" ? DateTime.now() : DateTime.parse(json['created_At']);
    } catch (e) {
      id = 0;
      image = "";
      uploadedAt = DateTime.now();
    }
  }
}
