import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../common/widgets/app_config.dart';
import '../../common/helper.dart';
import 'package:nutri_ai/services/user_service.dart';

class PaymentController extends GetxController {

  /// Observable loading state
  RxBool isVerifying = false.obs;

  /// Verify Stripe Session Payment
  Future<bool> verifyPayment(String? sessionId) async {
    if (sessionId == null || sessionId.isEmpty) {
      print("Session ID is null");
      return false;
    }

    try {
      isVerifying.value = true;

      final url = Uri.parse('${baseUrl}api/v1/verify-payment');
      final token = UserService.to.currentUser.value.accessToken;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'USER': apiUser,
          'KEY': apiKey,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "session_id": sessionId,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("Subscription Activated Successfully");
        return true;
      } else {
        print("Payment Verification Failed: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("Payment Verification Error: $e");
      return false;
    } finally {
      isVerifying.value = false;
    }
  }
}
