class WeightTracking {
  final String date;
  final double currentWeight;
  final double targetWeight;

  WeightTracking({this.date = "", this.currentWeight = 0, this.targetWeight = 0});
  factory WeightTracking.fromJson(Map<String, dynamic> json) {
    return WeightTracking(date: json['date'] ?? "", currentWeight: double.parse(json['current_weight'].toString()), targetWeight: double.parse(json['target_weight'].toString()));
  }
}
