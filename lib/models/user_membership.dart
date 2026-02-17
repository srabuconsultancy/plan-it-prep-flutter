class UserMembership {
  int id;
  int userId;
  String membership;
  int month;
  DateTime startDate;
  DateTime endDate;
  bool active;
  DateTime createdAt;

  // Constructor with default values
  UserMembership({
    this.id = 0,
    this.userId = 0,
    this.membership = "",
    this.month = 0,
    DateTime? startDate,
    DateTime? endDate,
    this.active = false,
    DateTime? createdAt,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // Factory method to create an instance from a JSON object
  factory UserMembership.fromJson(Map<String, dynamic> json) {
    return UserMembership(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      membership: json['membership'] ?? "",
      month: json['month'] ?? 0,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : DateTime.now(),
      active: json['active'] != null && json['active'] == 1 ? true : false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  // Method to convert the Dart object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'membership': membership,
      'month': month,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'active': active,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
