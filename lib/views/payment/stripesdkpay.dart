import 'package:flutter/material.dart';
import 'package:nutri_ai/services/payment_service.dart';
import '../services/payment_service.dart';

class newStripePaymentPage extends StatefulWidget {
  final int amount;
  final String priceId;

  const newStripePaymentPage({
    super.key,
    required this.amount,
    required this.priceId,
  });

  @override
  State<newStripePaymentPage> createState() => _newStripePaymentPageState();
}

class _newStripePaymentPageState extends State<newStripePaymentPage> {

  bool _isLoading = false;
  final PaymentService _paymentService = PaymentService();

  Future<void> _startPayment() async {
    setState(() => _isLoading = true);

    try {
      await _paymentService.makePayment(widget.priceId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Successful")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Payment"),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _startPayment,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(250, 50),
              ),
              child: Text("Pay ₹${widget.amount / 100}"),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}