import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nutri_ai/services/user_service.dart';
import '../../common/widgets/app_config.dart';
import '../../common/helper.dart';
import '../../core.dart';

/* =========================================================
    PAYMENT INTENT FUNCTIONS (Unchanged Functionality)
========================================================= */

Future<String> createPaymentIntent(int amount) async {
  final url = Uri.parse('${baseUrl}api/v1/create-payment-intent');
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
    body: jsonEncode({'amount': amount}),
  );

  final data = jsonDecode(response.body);
  return data['client_secret'];
}

Future<void> payWithStripe(int amount) async {
  try {
    final clientSecret = await createPaymentIntent(amount);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Nutri AI',
        style: ThemeMode.light,
      ),
    );

    await Stripe.instance.presentPaymentSheet();
  } on StripeException catch (e) {
    debugPrint("Stripe error: ${e.error.localizedMessage}");
    rethrow;
  } catch (e) {
    rethrow;
  }
}

Future<void> getSubsription(String priceId) async {
  final url = Uri.parse('${baseUrl}api/v1/create-subscription');
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
    body: jsonEncode({'price_id': priceId}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final String checkoutUrl = data['checkout_url'];
    Helper.launchLinkedURL(checkoutUrl);
  } else {
    throw Exception('Failed to create subscription');
  }
}

Future<http.Response> getPlans() async {
  final url = Uri.parse('${baseUrl}api/v1/plans/getAllPlans');
  final token = UserService.to.currentUser.value.accessToken;

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'USER': apiUser,
        'KEY': apiKey,
        'Authorization': 'Bearer $token',
      },
    );

    return response;
  } catch (e) {
    throw Exception('Failed to fetch plans: $e');
  }
}

/* =========================================================
    STRIPE PAYMENT PAGE (Modern Material Design)
========================================================= */

class StripePaymentPage extends StatefulWidget {
  const StripePaymentPage({super.key});

  @override
  State<StripePaymentPage> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  bool _isLoading = false;
  bool _hasError = false;
  List<Map<String, dynamic>> subscriptionPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await getPlans();
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        if (decodedData['status'] == true) {
          setState(() {
            subscriptionPlans =
                List<Map<String, dynamic>>.from(decodedData['data']);
          });
        }
      } else {
        setState(() => _hasError = true);
      }
    } catch (e) {
      debugPrint("Error fetching plans: $e");
      setState(() => _hasError = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSubscription(String priceId) async {
    setState(() => _isLoading = true);
    try {
      await getSubsription(priceId);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(TablerIcons.chevron_left, color: glShadeColor),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Subscription',
              style: TextStyle(
                  color: glShadeColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18),
            ),
            centerTitle: true,
          ),
          body: _hasError
              ? _buildErrorState()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Upgrade Your Plan',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: glShadeColor,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        'Select a subscription that suits you best to unlock all features.',
                        style: TextStyle(
                          color: glShadeColor.withOpacity(0.6),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 30),
                      ...subscriptionPlans
                          .map((plan) => _subscriptionCard(plan))
                          .toList(),
                      const SizedBox(height: 20),
                      _buildSecurePaymentNote(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(TablerIcons.alert_triangle,
              size: 64, color: Colors.orange.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'Failed to load plans',
            style: TextStyle(
                color: glShadeColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _fetchPlans,
            style: ElevatedButton.styleFrom(backgroundColor: glLightThemeColor),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionCard(Map<String, dynamic> plan) {
    final bool isHighlighted =
        plan['highlight'] == true || plan['highlight'] == 1;

    return GestureDetector(
      onTap: () => _handleSubscription(plan['price_id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isHighlighted ? glLightThemeColor : Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isHighlighted ? glLightThemeColor : glShadeColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isHighlighted ? TablerIcons.diamond : TablerIcons.bolt,
                    color: isHighlighted ? glLightThemeColor : glShadeColor,
                    size: 24,
                  ),
                ),
                if (isHighlighted)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: glLightThemeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'POPULAR',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              plan['title'] ?? 'N/A',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: glShadeColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan['price'] ?? '',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: glShadeColor,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    plan['duration'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: glShadeColor.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Divider(color: Colors.grey.withOpacity(0.1), thickness: 1),
            const SizedBox(height: 15),
            if (plan['features'] != null)
              ...(plan['features'] as List)
                  .map((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(TablerIcons.circle_check,
                                size: 18, color: glLightThemeColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                feature.toString(),
                                style: TextStyle(
                                  color: glShadeColor.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 200.ms)
          .slideY(begin: 0.1, end: 0),
    );
  }

  Widget _buildSecurePaymentNote() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(TablerIcons.lock,
                  size: 14, color: glShadeColor.withOpacity(0.4)),
              const SizedBox(width: 6),
              Text(
                'Secured by Stripe',
                style: TextStyle(
                  fontSize: 12,
                  color: glShadeColor.withOpacity(0.4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Payments are processed securely. Cancel anytime.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: glShadeColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
