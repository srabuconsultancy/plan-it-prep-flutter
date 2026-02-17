class SubscriptionModel {
  final int id;
  final String stripeSubscriptionId;
  final String stripePriceId;
  final String status;
  final DateTime? createdAt;

  SubscriptionModel({
    required this.id,
    required this.stripeSubscriptionId,
    required this.stripePriceId,
    required this.status,
    required this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    try {
      if (json['created_at'] != null) {
        parsedDate = DateTime.parse(json['created_at']);
      }
    } catch (_) {
      parsedDate = null;
    }

    return SubscriptionModel(
      id: json['id'] ?? 0,
      stripeSubscriptionId: json['stripe_subscription_id'] ?? '',
      stripePriceId: json['stripe_price_id'] ?? '',
      status: json['status'] ?? 'unknown',
      createdAt: parsedDate,
    );
  }
}
