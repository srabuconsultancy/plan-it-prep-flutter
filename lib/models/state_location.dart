class StateLocation {
  final int id;
  final String name;
  final int countryId;

  StateLocation({this.id = 0, this.name = "", this.countryId = 0});
  factory StateLocation.fromJson(Map<String, dynamic> json) {
    return StateLocation(id: json['id'], name: json['name'] as String, countryId: json['country_id']);
  }
}
