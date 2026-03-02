import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:nutri_ai/common/helper.dart';

class PaymentService {
  Future<void> makePayment(String priceId) async {
    try {
      final response = await Helper.sendRequestToServer(
        endPoint: 'create-subscription',
        method: 'post',
        requestData: {
          "price_id": priceId,
        },
      );

      final json = jsonDecode(response.body);
      final clientSecret = json['client_secret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Your App Name",
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      print("Payment Successful");
    } catch (e) {
      print("Payment Failed: $e");
    }
  }
}
