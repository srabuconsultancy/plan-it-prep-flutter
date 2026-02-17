import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nutri_ai/models/cuisine.dart';

import '../../core.dart'; // Assuming this imports your controllers, models, etc.

class RegisterCuisines extends StatelessWidget {
  const RegisterCuisines({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

    // --- DUMMY DATA (Removed) ---
    // final List<Cuisine> dummyCuisines = [ ... ];
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
                          "Which cuisine do you enjoy the most?", // <-- NEW TITLE
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
                          height: 10,
                        ),

                        // --- REMOVED SUBTITLE ---
                        // Text(
                        //   "(Select up to 3)",
                        //   ...
                        // )
                        // ---------------------

                        const SizedBox(
                          height: 20,
                        ),

                        // --- UPDATED CUISINE MAPPING ---
                        // --- MODIFICATION: Using live data from RootService ---
                        ...RootService.to.config.value.cuisine.mapIndexed(
                          (cuisineItem, i) => Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              // --- MODIFICATION: Changed to single-select UI logic ---
                              color: authController.selectedCuisine.value ==
                                      cuisineItem
                                  ? glLightPrimaryColor
                                  : glLightDividerColor.withValues(
                                      alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(glBorderRadius),
                              boxShadow: [
                                BoxShadow(
                                  // --- MODIFICATION: Changed to single-select UI logic ---
                                  color: authController.selectedCuisine.value ==
                                          cuisineItem
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
                                  // --- FIX: Added explicit style ---
                                  child: Text(
                                    cuisineItem.name.tr,
                                    style: TextStyle(
                                      color: glDarkPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // --- END OF FIX ---
                                ),
                                const SizedBox(width: 10),
                                // --- MODIFICATION: Changed to single-select UI logic ---
                                if (authController.selectedCuisine.value ==
                                    cuisineItem)
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
                            // --- MODIFICATION: Changed to single-select TAP logic ---
                            authController.selectedCuisine.value = cuisineItem;
                            authController.selectedCuisine.refresh();
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
                        // --- MODIFICATION: Changed to single-select NEXT logic ---
                        if (authController.selectedCuisine.value.id <= 0) {
                          Get.snackbar(
                            "Error",
                            "Please select a cuisine.",
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