import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/subscription_controller.dart';
import '../../core.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  SubscriptionDetailsPage({super.key});

  final SubscriptionController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Ensuring a clean status bar integration
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final sub = controller.selectedSubscription.value;

    if (sub == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(TablerIcons.receipt_off,
                  size: 48, color: glShadeColor.withOpacity(0.2)),
              const SizedBox(height: 16),
              Text(
                'No subscription selected',
                style: TextStyle(
                  color: glShadeColor.withOpacity(0.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final plan = controller.priceMap[sub.stripePriceId] ??
        {
          'title': 'Subscription',
          'amount': 0,
          'duration': '',
        };

    bool isActive = sub.status.toLowerCase() == 'active';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Plan Details',
          style: TextStyle(
            color: glShadeColor,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(TablerIcons.chevron_left, color: glShadeColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // --- TOP PREMIUM PLAN CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Plan Icon
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: (isActive ? glLightThemeColor : Colors.grey)
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        isActive ? TablerIcons.crown : TablerIcons.receipt,
                        color: isActive ? glLightThemeColor : Colors.grey,
                        size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    plan['title'],
                    style: TextStyle(
                      color: glShadeColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '₹${plan['amount']} / ${plan['duration']}',
                    style: TextStyle(
                      color: glShadeColor.withOpacity(0.4),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Enhanced Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          sub.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color:
                                isActive ? Colors.green[800] : Colors.red[800],
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).moveY(begin: 20, end: 0),

            const SizedBox(height: 30),

            // --- SECTION LABEL ---
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 12),
                child: Text(
                  "BILLING INFORMATION",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: glShadeColor.withOpacity(0.3),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            // --- DETAILS CONTAINER ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow(context, TablerIcons.id, 'Subscription ID',
                      sub.stripeSubscriptionId),
                  _buildDivider(),
                  _buildDetailRow(context, TablerIcons.barcode,
                      'Price Reference', sub.stripePriceId),
                  _buildDivider(),
                  _buildDetailRow(
                      context,
                      TablerIcons.calendar_time,
                      'Billing Start Date',
                      controller.formatDate(sub.createdAt)),
                ],
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 600.ms)
                .moveY(begin: 10, end: 0),

            const SizedBox(height: 40),

            // --- FOOTER HELP SECTION ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Icon(TablerIcons.help_circle, color: glLightThemeColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Have questions?",
                          style: TextStyle(
                              color: glShadeColor, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Our support team is here to help.",
                          style: TextStyle(
                              color: glShadeColor.withOpacity(0.5),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Support",
                    style: TextStyle(
                      color: glLightThemeColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ).onInkTap(() {
                    // Logic for support contact
                  }),
                ],
              ),
            ).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));

          // Replaced Get.snackbar with ScaffoldMessenger to resolve the enum error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(TablerIcons.clipboard_check,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text("Copied: $label",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              backgroundColor: glShadeColor.withOpacity(0.95),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: glShadeColor.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    Icon(icon, size: 20, color: glShadeColor.withOpacity(0.4)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: glShadeColor.withOpacity(0.4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        color: glShadeColor,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace', // Helpful for IDs
                      ),
                    ),
                  ],
                ),
              ),
              Icon(TablerIcons.copy,
                  size: 16, color: glShadeColor.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.03),
      indent: 70,
      endIndent: 20,
    );
  }
}
