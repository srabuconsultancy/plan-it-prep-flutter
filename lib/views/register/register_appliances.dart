import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
// Ensure 'collection' is imported for mapIndexed if not already in core.dart
// import 'package:collection/collection.dart';

import '../../core.dart';

class RegisterAppliances extends StatelessWidget {
  const RegisterAppliances({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

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
                        // --- TITLE ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Do you have access to basic kitchen appliances? (Select all that apply)",
                            textAlign: TextAlign.center,
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
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // --- UPDATED MULTI-SELECT MAPPING ---
                        ...RootService.to.config.value.appliance.mapIndexed(
                          (applianceItem, i) {
                            // Check if the item is currently selected in the list
                            final isSelected = authController.selectedAppliances
                                .contains(applianceItem);

                            return Container(
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(
                                // Highlight if selected
                                color: isSelected
                                    ? glLightPrimaryColor
                                    : glLightDividerColor.withValues(
                                        alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(glBorderRadius),
                                border: isSelected
                                    ? Border.all(
                                        color: glLightThemeColor, width: 1)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      applianceItem.name.tr,
                                      style: TextStyle(
                                        color: glDarkPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Show Check Icon if selected
                                  if (isSelected)
                                    Icon(
                                      Icons.check_box,
                                      color: glLightThemeColor,
                                    )
                                        .animate()
                                        .fadeIn(
                                          duration: (200).ms,
                                          curve: Curves.easeOutQuad,
                                        )
                                        .scale(),
                                  if (!isSelected)
                                    Icon(
                                      Icons.check_box_outline_blank,
                                      color:
                                          glDarkPrimaryColor.withOpacity(0.3),
                                    ),
                                ],
                              ),
                            )
                                .onInkTap(() {
                                  // --- MULTI-SELECT LOGIC ---
                                  if (authController.selectedAppliances
                                      .contains(applianceItem)) {
                                    authController.selectedAppliances
                                        .remove(applianceItem);
                                  } else {
                                    authController.selectedAppliances
                                        .add(applianceItem);
                                  }
                                  // Note: RxList updates automatically, .refresh() is usually not needed
                                  // but added if you have specific listeners depending on manual triggers.
                                  // authController.selectedAppliances.refresh();
                                })
                                .animate()
                                .shimmer(
                                    duration: (1200 / 3).ms,
                                    color: glLightThemeColor)
                                .fadeIn(
                                  duration: (1200 / 3).ms,
                                  curve: Curves.easeOutQuad,
                                  delay: (60.ms + (i * 33).ms),
                                )
                                .slideX();
                          },
                        ),
                        // --- END OF UPDATED BLOCK ---

                        const SizedBox(
                          height: 120,
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
                        // --- VALIDATION: Ensure at least one is selected ---
                        if (authController.selectedAppliances.isEmpty) {
                          Get.snackbar(
                            "Selection Required",
                            "Please select at least one appliance.",
                            snackPosition: SnackPosition.bottom,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(20),
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
