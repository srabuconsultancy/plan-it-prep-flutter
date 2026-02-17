import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
// Ensure collection is imported for mapIndexed
import 'package:collection/collection.dart';

import '../../core.dart';

class RegisterDietPreferences extends StatelessWidget {
  const RegisterDietPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    // Removed local controller since it's now in authController

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              color: glLightPrimaryColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Obx(
                    () {
                      // --- SORTING LOGIC ---
                      // 1. Get list from DB
                      var prefList = RootService.to.config.value.dietPreference.toList();

                      // 2. Sort: Regular -> Top, Others -> Bottom
                      prefList.sort((a, b) {
                        final aName = a.name.toLowerCase();
                        final bName = b.name.toLowerCase();

                        // Priority 1: Regular at the top
                        bool aIsRegular = aName.contains("regular");
                        bool bIsRegular = bName.contains("regular");
                        if (aIsRegular && !bIsRegular) return -1;
                        if (!aIsRegular && bIsRegular) return 1;

                        // Priority 2: Others at the bottom
                        bool aIsOthers = aName.contains("others") || aName.contains("other");
                        bool bIsOthers = bName.contains("others") || bName.contains("other");
                        if (aIsOthers && !bIsOthers) return 1;
                        if (!aIsOthers && bIsOthers) return -1;

                        // Default: Keep original order
                        return 0;
                      });
                      // ---------------------

                      bool isOtherSelected = authController.selectedDietPreference.value.name.toLowerCase().contains('other');

                      return Column(
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
                            'Food Preference',
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

                          // --- MAPPING SORTED LIST ---
                          ...prefList.mapIndexed((i, foodPrefItem) => 
                                Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: authController.selectedDietPreference.value == foodPrefItem ? glLightPrimaryColor : glLightDividerColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                    boxShadow: [
                                      BoxShadow(
                                        color: authController.selectedDietPreference.value == foodPrefItem ? glLightThemeColor.withValues(alpha: 0.4) : glDarkPrimaryColor.withValues(alpha: 0.01),
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
                                          foodPrefItem.name.tr,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      if (authController.selectedDietPreference.value == foodPrefItem)
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
                                )
                                    .onInkTap(() {
                                      authController.selectedDietPreference.value = foodPrefItem;
                                      authController.selectedDietPreference.refresh();
                                    })
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
                              ),
                          // --- END OF MAPPING ---

                          // --- OTHER INPUT FIELD ---
                          if (isOtherSelected)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: TextField(
                                controller: authController.otherPreferenceController, // Using controller from authController
                                decoration: InputDecoration(
                                  labelText: "Specify Preference",
                                  hintText: "No onion",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (val) {
                                  // Value is automatically updated in the controller
                                },
                              ).animate().fadeIn().slideY(begin: 0.2),
                            ),
                          // -------------------------

                          const SizedBox(
                            height: 120,
                          ),
                        ],
                      );
                    }
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
                        if (authController.selectedDietPreference.value.id > 0) {
                          // Validation for "Other"
                          bool isOther = authController.selectedDietPreference.value.name.toLowerCase().contains('other');
                          if (isOther && authController.otherPreferenceController.text.trim().isEmpty) {
                             Get.snackbar(
                              "Required",
                              "Please specify your diet preference",
                              snackPosition: SnackPosition.bottom,
                            );
                            return;
                          }
                          
                          // Proceed
                          authController.onNextButtonPressed.call();
                        } else {
                           Get.snackbar(
                            "Error",
                            "Please select a food preference",
                            snackPosition: SnackPosition.bottom,
                          );
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
}