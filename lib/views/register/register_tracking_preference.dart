import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core.dart'; // Make sure this imports UserController, colors, etc.

class RegisterTrackingPreference extends StatelessWidget {
  const RegisterTrackingPreference({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

    // Use theme colors
    final Color primaryColor = glLightThemeColor;
    final Color primaryTextColor = glDarkPrimaryColor;
    final Color cardBackgroundColor = glLightPrimaryColor;
    final Color subtleBackgroundColor =
        glLightDividerColor.withValues(alpha: 0.1);
    final Color secondaryTextColor = Colors.grey[600] ?? Colors.grey;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows keyboard adjustments
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              color: cardBackgroundColor, // Use theme background
              // Use SingleChildScrollView to prevent overflow when keyboard appears
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Obx(
                    // Wrap Column in Obx to react to changes
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        // --- Standard Header ---
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: primaryTextColor,
                            height: 1,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideX(),
                        const SizedBox(height: 10),
                        Text(
                          'Step ${int.parse(authController.registerProcessPageIndex.value.toString()) + 1} of ${authController.registerProcessPages.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: primaryColor,
                            height: 1,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .slideX(),
                        const SizedBox(height: 30),
                        LinearProgressIndicator(
                          color: primaryColor,
                          value: (authController.registerProcessPages.length >
                                  1)
                              ? (authController.registerProcessPageIndex.value
                                      .toDouble()) /
                                  (authController.registerProcessPages.length -
                                      1)
                              : 0.0,
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 30),
                        // --- Question ---
                        Text(
                          "Do you want to track calories or just follow meal suggestions?"
                              .tr,
                          textAlign: TextAlign.center, // Center align the text
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16, // Slightly larger font
                            color: primaryTextColor,
                            height: 1.3, // Add line height
                          ),
                        )
                            .pSymmetric(h: 15) // Add horizontal padding
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms)
                            .slideX(),
                        const SizedBox(height: 30), // Increased spacing

                        // --- Option 1: Track Calories ---
                        _buildOptionCard(
                          title: "Track calories".tr,
                          isSelected: authController.trackingPreference.value ==
                              'Track',
                          onTap: () {
                            authController.trackingPreference.value = 'Track';
                          },
                          primaryColor: primaryColor,
                          cardBackgroundColor: cardBackgroundColor,
                          subtleBackgroundColor: subtleBackgroundColor,
                          primaryTextColor: primaryTextColor,
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 300.ms)
                            .slideX(),

                        // --- Calorie Input Field (Conditional) ---
                        AnimatedSwitcher(
                          duration: 300.ms,
                          transitionBuilder: (child, animation) {
                            return SizeTransition(
                              sizeFactor: animation,
                              axisAlignment: -1.0, // Start animation from top
                              child: FadeTransition(
                                  opacity: animation, child: child),
                            );
                          },
                          child: authController.trackingPreference.value ==
                                  'Track'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  child: TextFormField(
                                    controller:
                                        authController.calorieInputController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ], // Allow only numbers

                                    // --- ADDED VALIDATION ---
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        // Return null if you want to allow an empty field.
                                        // Or return an error string if it's required.
                                        return 'Please enter a value'.tr;
                                      }

                                      final int? calories = int.tryParse(value);

                                      if (calories == null) {
                                        return 'Invalid number'
                                            .tr; // Should not happen with formatter
                                      }

                                      if (calories <= 1600) {
                                        return 'Must be greater than 1600 kcal'
                                            .tr;
                                      }

                                      return null; // Value is valid
                                    },
                                    // --- END VALIDATION ---

                                    decoration: InputDecoration(
                                      labelText:
                                          "Target daily calories (kcal)".tr,
                                      labelStyle:
                                          TextStyle(color: secondaryTextColor),
                                      filled: true,
                                      fillColor: subtleBackgroundColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            glBorderRadius),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            glBorderRadius),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 1.5),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14.0, horizontal: 16.0),
                                    ),
                                    style: TextStyle(
                                        color: primaryTextColor,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : const SizedBox
                                  .shrink(), // Empty space when not tracking
                        ),

                        // --- Option 2: Follow Meals ---
                        _buildOptionCard(
                          title: "Just follow balanced meals".tr,
                          isSelected: authController.trackingPreference.value ==
                              'Follow',
                          onTap: () {
                            authController.trackingPreference.value = 'Follow';
                            // Optionally clear calorie input if they switch
                            authController.calorieInputController.clear();
                            FocusScope.of(context).unfocus(); // Hide keyboard
                          },
                          primaryColor: primaryColor,
                          cardBackgroundColor: cardBackgroundColor,
                          subtleBackgroundColor: subtleBackgroundColor,
                          primaryTextColor: primaryTextColor,
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 400.ms)
                            .slideX(),

                        const SizedBox(height: 120), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // --- Bottom Navigation Buttons ---
            Positioned(
              bottom: 0,
              height: 100,
              width: Get.width,
              child: Container(
                height: 100,
                color: cardBackgroundColor, // Match background
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButtonWidget(
                      title: "Back",
                      width: Get.width / 2.5,
                      fontWeight: FontWeight.bold,
                      borderRadius: glBorderRadius,
                      bgColor: cardBackgroundColor, // Use background color
                      textColor: primaryColor, // Use primary color for text
                      borderColor: primaryColor, // Add border
                      border: 1.5,
                      height: 50,
                      onTap: authController.onPreviousButtonPressed,
                    ),
                    CustomButtonWidget(
                      title: "Next",
                      width: Get.width / 2.5,
                      fontWeight: FontWeight.bold,
                      borderRadius: glBorderRadius,
                      bgColor: primaryColor, // Use primary color for background
                      textColor: Colors.white, // White text
                      height: 50,
                      onTap: () {
                        // Call the validation function before proceeding
                        if (authController.isTrackingPreferenceValid()) {
                          authController.onNextButtonPressed.call();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the selectable option cards
  Widget _buildOptionCard({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
    required Color cardBackgroundColor,
    required Color subtleBackgroundColor,
    required Color primaryTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(glBorderRadius),
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 8), // Adjusted margin
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 16), // Adjusted padding
        decoration: BoxDecoration(
          color: isSelected
              ? cardBackgroundColor
              : subtleBackgroundColor, // Background changes on selection
          borderRadius: BorderRadius.circular(glBorderRadius),
          border: Border.all(
            color: isSelected
                ? primaryColor
                : Colors.transparent, // Border indicates selection
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  // Add shadow only when selected
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [], // No shadow when not selected
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align check icon to the right
          children: [
            Expanded(
              // Allow text to wrap if needed
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15, // Slightly smaller font
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.w500, // Bolden selected text
                  color: primaryTextColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 22, // Adjust size
              ),
          ],
        ),
      ),
    );
  }
}
