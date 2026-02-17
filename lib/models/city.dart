class City {
  final int id;
  final String name;
  final int stateId;

  City({this.id = 0, this.name = "", this.stateId = 0});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'] ?? "",
      stateId: json['state_id'],
    );
  }
}
