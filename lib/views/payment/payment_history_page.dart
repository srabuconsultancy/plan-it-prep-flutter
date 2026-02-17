import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/subscription_controller.dart';
import '../../routes/routes.dart';
import '../../core.dart'; // Assuming core contains your gl colors and theme constants

class SubscriptionHistoryPage extends StatelessWidget {
  SubscriptionHistoryPage({super.key});

  final SubscriptionController controller =
      Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    // Setting status bar to match the clean theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(
          0xFFF5F7FA), // Light grey/blue background from UserProfile
      appBar: AppBar(
        title: Text(
          'Subscription History',
          style: TextStyle(
            color: glShadeColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(TablerIcons.chevron_left, color: glShadeColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: glLightThemeColor,
              strokeWidth: 3,
            ),
          );
        }

        if (controller.subscriptions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(TablerIcons.receipt_off,
                    size: 60, color: glShadeColor.withOpacity(0.2)),
                const SizedBox(height: 16),
                Text(
                  'No subscriptions found',
                  style: TextStyle(
                    color: glShadeColor.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.subscriptions.length,
          itemBuilder: (_, index) {
            final sub = controller.subscriptions[index];
            final plan = controller.priceMap[sub.stripePriceId] ??
                {
                  'title': 'Subscription',
                  'amount': 0,
                  'duration': '',
                };

            bool isActive = sub.status.toLowerCase() == 'active';

            return GestureDetector(
              onTap: () {
                controller.selectedSubscription.value = sub;
                Get.toNamed(Routes.stripePaymentDetails);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon/Indicator
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isActive ? glLightThemeColor : Colors.grey)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive
                            ? TablerIcons.check
                            : TablerIcons.refresh_alert,
                        color: isActive ? glLightThemeColor : Colors.grey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Main Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['title'],
                            style: TextStyle(
                              color: glShadeColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formatDate(sub.createdAt),
                            style: TextStyle(
                              color: glShadeColor.withOpacity(0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Status Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              sub.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: isActive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Amount Side
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${plan['amount']}',
                          style: TextStyle(
                            color: glShadeColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          plan['duration'],
                          style: TextStyle(
                            color: glShadeColor.withOpacity(0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          TablerIcons.chevron_right,
                          size: 18,
                          color: glShadeColor.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                  .slideX(begin: 0.1, end: 0),
            );
          },
        );
      }),
    );
  }
}
