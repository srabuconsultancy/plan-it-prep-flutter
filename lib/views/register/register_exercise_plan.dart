import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterExercisePlan extends StatelessWidget {
  const RegisterExercisePlan({super.key});
  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          // --- FIX 1: Make Stack fill the screen ---
          fit: StackFit.expand,
          children: [
            // --- FIX 2: Remove fixed height, add SingleChildScrollView ---
            Container(
              width: Get.width,
              // height: Get.height, // <-- Removed this to prevent overflow
              color: glLightPrimaryColor,
              child: SingleChildScrollView( // <-- Added this
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Obx( // <-- Moved Obx inside the scrollable
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
                        // --- FIX 3: Added Padding and centering to title ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'How many days you choose to exercise in a week?',
                            textAlign: TextAlign.center, // <-- Added center
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
                              )
                              .slideX(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ...RootService.to.config.value.exercisePlanDays
                            .mapIndexed(
                          (exercisePlan, i) =>
                              // --- FIX 4: Replaced Stack with Container/Row ---
                              Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            // --- USER REQUEST: Increased vertical padding ---
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20), // <-- Was 10
                            decoration: BoxDecoration(
                              color:
                                  authController.selectedExercisePlan.value ==
                                          exercisePlan
                                      ? glLightPrimaryColor
                                      : glLightDividerColor.withValues(
                                          alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(glBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: authController.selectedExercisePlan
                                              .value ==
                                          exercisePlan
                                      ? glLightThemeColor.withValues(alpha: 0.4)
                                      : glDarkPrimaryColor.withValues(
                                          alpha: 0.01),
                                  offset: const Offset(0, 3),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween, // <-- Added
                              children: [
                                // --- FIX 5: Use Expanded and Text for wrapping ---
                                Expanded(
                                  child: Text(
                                    exercisePlan.name.tr,
                                    // You can add style here if .make() had one
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // --- (Image logic commented out) ---

                                // --- FIX 6: Conditional checkmark icon ---
                                if (authController.selectedExercisePlan.value ==
                                    exercisePlan)
                                  Icon(
                                    Icons.check_circle,
                                    color: glLightThemeColor,
                                  )
                                      .animate()
                                      .shimmer(
                                        duration: (1200 / 3).ms,
                                        color: glLightThemeColor,
                                        delay: (200.ms + (i * 33).ms),
                                      )
                                      .fadeIn(
                                        duration: (1200 / 3).ms,
                                        curve: Curves.easeOutQuad,
                                        delay: (200.ms + (i * 33).ms),
                                      )
                                      .slideY(),
                              ],
                            ),
                          ).onInkTap(() {
                            authController.selectedExercisePlan.value =
                                exercisePlan;
                            authController.selectedExercisePlan.refresh();
                          })
                                .animate()
                                .shimmer(
                                    duration: (1200 / 3).ms,
                                    color: glLightThemeColor)
                                .fadeIn(
                                  duration: (1200 / 3).ms,
                                  curve: Curves.easeOutQuad,
                                  delay: ((i * 300) / 3).ms,
                                )
                                .slideX(),
                        ),
                        // --- FIX 7: Added space for bottom buttons ---
                        const SizedBox(
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                      // margin: const EdgeInsets.symmetric(horizontal: 20),
                      onTap: authController.onPreviousButtonPressed,
                    ),
                    CustomButtonWidget(
                        title: "Next",
                        width: Get.width / 2.5,
                        fontWeight: FontWeight.bold,
                        borderRadius: glBorderRadius,
                        bgColor: glLightThemeColor,
                        height: 50,
                        // margin: const EdgeInsets.symmetric(horizontal: 20),
                        onTap: () {
                          if (authController.selectedExercisePlan.value.id >
                              0) {
                            authController.onNextButtonPressed.call();
                          } else {
                            // --- FIX 8: Added error snackbar ---
                            Get.snackbar(
                              "Error",
                              "Please select an exercise plan.",
                              snackPosition: SnackPosition.bottom,
                            );
                          }
                        }),
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