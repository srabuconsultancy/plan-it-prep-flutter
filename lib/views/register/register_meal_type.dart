import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nutri_ai/models/mealtype.dart';

import '../../core.dart'; // Assuming this imports your controllers, models, etc.

class RegisterMealType extends StatelessWidget {
  const RegisterMealType({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

    // --- DUMMY DATA ---
    // This replicates your DB response
    final List<MealType> dummyMealTypes = [
      MealType(id: 1, name: "Light & quick"),
      MealType(id: 2, name: "Hearty & filling"),
      MealType(id: 3, name: "High protein"),
      MealType(id: 4, name: "Low carb"),
      MealType(id: 5, name: "Plant-based"),
    ];
    // --------------------

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // This Container holds the SCROLLABLE list
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
                          "What type of meals do you prefer?", // <-- NEW TITLE
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: glDarkPrimaryColor,
                            height: 1,
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

                        // --- UPDATED MEAL TYPE MAPPING ---
                        ...dummyMealTypes.mapIndexed(
                          (mealTypeItem, i) => Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              // --- SINGLE-SELECT UI LOGIC ---
                              color: authController.selectedMealType.value ==
                                      mealTypeItem
                                  ? glLightPrimaryColor
                                  : glLightDividerColor.withValues(
                                      alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(glBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  // --- SINGLE-SELECT UI LOGIC ---
                                  color: authController.selectedMealType.value ==
                                          mealTypeItem
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
                                Expanded(
                                  child: Text(
                                    mealTypeItem.name.tr,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // --- SINGLE-SELECT UI LOGIC ---
                                if (authController.selectedMealType.value ==
                                    mealTypeItem)
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
                            // --- SINGLE-SELECT TAP LOGIC ---
                            authController.selectedMealType.value = mealTypeItem;
                            authController.selectedMealType.refresh();
                            // ---------------------------------
                          })
                          .animate()
                          .shimmer(
                              duration: (1200 / 3).ms,
                              color: glLightThemeColor)
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (60.ms + (i * 33).ms), // Staggered animation
                          )
                          .slideX(),
                        ),
                        // --- END OF UPDATED BLOCK ---

                        const SizedBox(
                          height: 120, // Space for the buttons
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- BUTTONS ---
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
                        // --- SINGLE-SELECT NEXT LOGIC ---
                        if (authController.selectedMealType.value.id <= 0) {
                          Get.snackbar(
                            "Error",
                            "Please select a meal type.",
                            snackPosition: SnackPosition.bottom,
                          );
                          return;
                        }
                        // ---------------------------------

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