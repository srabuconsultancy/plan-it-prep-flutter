class PaymentModel {
  final int id;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: (json['amount'] ?? 000).toDouble(), // fallback if null
      currency: json['currency'] ?? 'INR',
      status: json['status'] ?? '',
      paymentMethod: json['payment_method'] ?? 'Stripe',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
