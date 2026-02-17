class UserPayment {
  int id;
  int userMembershipId;
  String membership;
  int month;
  int userId;
  String transactionId;
  String paymentMethod;
  double price;
  String status;
  dynamic response; // Can be null
  DateTime createdAt;

  // Constructor with default values
  UserPayment({
    this.id = 0,
    this.userMembershipId = 0,
    this.membership = "",
    this.month = 0,
    this.userId = 0,
    this.transactionId = "",
    this.paymentMethod = "",
    this.price = 0.0,
    this.status = "",
    this.response,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now(); // Default to current date if null

  // Factory method to create an instance from a JSON object
  factory UserPayment.fromJson(Map<String, dynamic> json) {
    return UserPayment(
      id: json['id'] ?? 0,
      userMembershipId: json['user_membership_id'] ?? 0,
      membership: json['membership'] ?? "",
      month: json['month'] ?? 0,
      userId: json['user_id'] ?? 0,
      transactionId: json['transaction_id'] ?? "",
      paymentMethod: json['payment_method'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? "",
      response: json['response'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  // Method to convert the Dart object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_membership_id': userMembershipId,
      'membership': membership,
      'month': month,
      'user_id': userId,
      'transaction_id': transactionId,
      'payment_method': paymentMethod,
      'price': price,
      'status': status,
      'response': response,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
