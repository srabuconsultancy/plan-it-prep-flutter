class MedicalTest {
  int id = 0;
  String name = "";
  String date = "";
  String file = "";

  MedicalTest({this.id = 0, this.name = "", this.date = "", this.file = ""});

  MedicalTest.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)
    // //print("FitnessLevel.fromJson json: $json");

    try {
      id = json['id'] ?? 0;
      name = json['name'] ?? "";
      date = json['date'] ?? "";
      file = json['image'] ?? "";
    } catch (e) {
      id = 0;
      name = "";
      date = "";
      file = "";
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date,
        'file': file,
      };
}
