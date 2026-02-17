import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/subscription_model.dart';
import '../services/user_service.dart';
import '../../common/widgets/app_config.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  var subscriptions = <SubscriptionModel>[].obs;
  var selectedSubscription = Rxn<SubscriptionModel>();

  /// Price map (single source of truth for UI)
  final Map<String, Map<String, dynamic>> priceMap = {
    'price_1SqWXYBoy1so7bjrXfiz3SPS': {
      'title': 'Monthly Plan',
      'amount': 499,
      'duration': 'per month',
      'gradient': [0xFF6A11CB, 0xFF2575FC],
    },
    'price_1SqWayBoy1so7bjr2BeXfPku': {
      'title': 'Daily Plan',
      'amount': 49,
      'duration': 'per day',
      'gradient': [0xFFFF512F, 0xFFF09819],
    },
  };

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptions();
  }

  /// Fetch subscriptions from API
  Future<void> fetchSubscriptions() async {
    isLoading.value = true;

    try {
      final token = UserService.to.currentUser.value.accessToken;

      final response = await http.get(
        Uri.parse('${baseUrl}api/v1/payments-subscriptions-data'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'USER': apiUser,
          'KEY': apiKey,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true && decoded['data'] != null) {
          final subs = decoded['data']['subscriptions'] as List<dynamic>?;

          if (subs != null && subs.isNotEmpty) {
            subscriptions.value =
                subs.map((e) => SubscriptionModel.fromJson(e)).toList();
          } else {
            subscriptions.clear();
            print('No subscriptions found in API response');
          }
        } else {
          subscriptions.clear();
          print('API returned success=false or missing data');
        }
      } else {
        subscriptions.clear();
        print('API error: ${response.statusCode}');
      }
    } catch (e) {
      subscriptions.clear();
      print('Exception fetching subscriptions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Format date for UI
  String formatDate(DateTime? date) {
    if (date == null) return '--';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Get price info for subscription, fallback if priceId not found
  Map<String, dynamic> getPriceData(String? priceId) {
    if (priceId != null && priceMap.containsKey(priceId)) {
      return priceMap[priceId]!;
    }
    // Default fallback plan
    return {
      'title': 'Subscription',
      'amount': 0,
      'duration': '',
      'gradient': [0xFF9E9E9E, 0xFFBDBDBD],
    };
  }
}
