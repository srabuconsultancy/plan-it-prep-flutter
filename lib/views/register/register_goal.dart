import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

// import 'package:spflutter_number_picker/spflutter_number_picker.dart';

import '../../core.dart'; // Assuming this imports your controllers, models, and CustomButtonWidget

class RegisterGoal extends StatelessWidget {
  const RegisterGoal({super.key});
  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          // --- THIS IS THE FIX ---
          // Tell the Stack to expand to fill the SafeArea
          fit: StackFit.expand,
          // -----------------------
          children: [
            // 2. This Container holds the SCROLLABLE list
            Container(
              width: Get.width,
              color: glLightPrimaryColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: glDarkPrimaryColor,
                            height: 1,
                            shadows: const [
                              // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                            ],
                          ),
                        )
                            .animate()
                            .shimmer(
                                duration: (1200 / 3).ms,
                                color: glLightThemeColor)
                            .fadeIn(
                              duration: (1200 / 3).ms,
                              curve: Curves.easeOutQuad,
                            )
                            .slideX(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Step ${int.parse(authController.registerProcessPageIndex.value.toString()) + 1} of ${authController.registerProcessPages.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: glLightThemeColor,
                            height: 1,
                            shadows: const [
                              // Shadow(offset: const Offset(1, 1), color: glLightThemeColor.withValues(alpha:0.6), blurRadius: 4),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(
                              duration: (1200 / 3).ms,
                              curve: Curves.easeOutQuad,
                            )
                            .slideX(),
                        const SizedBox(
                          height: 30,
                        ),
                        LinearProgressIndicator(
                          color: glLightThemeColor,
                          value: (authController
                                  .registerProcessPageIndex.value) /
                              (authController.registerProcessPages.length - 1),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "What's your Goal?",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: glDarkPrimaryColor,
                            height: 1,
                            shadows: const [
                              // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                            ],
                          ),
                        )
                            .animate()
                            .shimmer(
                                duration: (1200 / 3).ms,
                                color: glLightThemeColor)
                            .fadeIn(
                              duration: (1200 / 3).ms,
                              curve: Curves.easeOutQuad,
                              delay: (300 / 3).ms,
                            )
                            .slideX(),
                        const SizedBox(
                          height: 20,
                        ),

                        // --- UPDATED GOAL MAPPING (with text wrap) ---
                        ...RootService.to.config.value.goals.mapIndexed(
                          (goalItem, i) => Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: authController.selectedGoal.value ==
                                      goalItem
                                  ? glLightPrimaryColor
                                  : glLightDividerColor.withValues(
                                      alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(glBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      authController.selectedGoal.value ==
                                              goalItem
                                          ? glLightThemeColor.withValues(
                                              alpha: 0.4)
                                          : glDarkPrimaryColor.withValues(
                                              alpha: 0.01),
                                  offset: const Offset(0, 3),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // FIX: Text is wrapped in Expanded
                                Expanded(
                                  child: Text(
                                    goalItem.name.tr,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (authController.selectedGoal.value ==
                                    goalItem)
                                  Icon(
                                    Icons.check_circle,
                                    color: glLightThemeColor,
                                  )
                                      .animate()
                                      .shimmer(
                                        duration: (1200 / 3).ms,
                                        color: glLightThemeColor,
                                        delay: (60.ms),
                                      )
                                      .fadeIn(
                                        duration: (1200 / 3).ms,
                                        curve: Curves.easeOutQuad,
                                        delay: (60.ms),
                                      )
                                      .slideY(),
                              ],
                            ),
                          ).onInkTap(() {
                            authController.selectedGoal.value = goalItem;
                            authController.selectedGoal.refresh();
                          })
                          .animate()
                          .shimmer(
                              duration: (1200 / 3).ms,
                              color: glLightThemeColor)
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (60).ms,
                          )
                          .slideX(),
                        ),
                        // --- END OF UPDATED BLOCK ---

                        // 4. ADDED PADDING at the bottom of the list
                        const SizedBox(
                          height: 120, // Space for the buttons
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 3. UN-COMMENTED THE BUTTONS
            Positioned(
              bottom: 0,
              height: 100,
              width: Get.width,
              child: Container(
                height: 100,
                color: glLightPrimaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButtonWidget(
                      title: "Back",
                      width: Get.width / 2.5,
                      fontWeight: FontWeight.bold,
                      borderRadius: glBorderRadius,
                      bgColor: glLightPrimaryColor,
                      textColor: glLightThemeColor,
                      height: 50,
                      onTap: authController.onPreviousButtonPressed,
                    ),
                    CustomButtonWidget(
                      title: "Next",
                      width: Get.width / 2.5,
                      fontWeight: FontWeight.bold,
                      borderRadius: glBorderRadius,
                      bgColor: glLightThemeColor,
                      height: 50,
                      onTap: () {
                        // Using .value to access the Goal object
                        final selectedGoal = authController.selectedGoal.value;

                        // This check assumes a non-selected goal has an ID of 0 or less
                        // Make sure your controller initializes selectedGoal correctly
                        if (selectedGoal.id == null || selectedGoal.id <= 0) {
                          Get.snackbar(
                            "Error",
                            "Please select a goal",
                            snackPosition: SnackPosition.bottom,
                          );
                          return;
                        }

                        authController.onNextButtonPressed.call();
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
}