import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../core.dart';

class RegisterHeight extends StatelessWidget {
  const RegisterHeight({super.key});
  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              color: glLightPrimaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
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
                        color:
                            glDarkPrimaryColor, // 🔑 Explicitly set to dark color
                        height: 1,
                        shadows: const [
                          // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                        ],
                      ),
                    )
                        .animate()
                        .shimmer(
                            duration: (1200 / 3).ms, color: glLightThemeColor)
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
                      value: (authController.registerProcessPageIndex.value) /
                          (authController.registerProcessPages.length - 1),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'What\'s your Height?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22, // Increased size for readability
                        color: glDarkPrimaryColor, // 🔑 Set dark color
                        height: 1,
                      ),
                    )
                        .animate()
                        .shimmer(
                            duration: (1200 / 3).ms, color: glLightThemeColor)
                        .fadeIn(
                          duration: (1200 / 3).ms,
                          curve: Curves.easeOutQuad,
                        )
                        .slideX(),
                    const SizedBox(
                      height: 50,
                    ),

                    // --- HEIGHT UNIT TOGGLE
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // LEFT SIDE: METRIC
                          Flexible(
                            child: "Metric (CM)"
                                .text
                                .textStyle(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    // Active (Dark) when heightInCms is TRUE
                                    color: authController.heightInCms.value
                                        ? glDarkPrimaryColor
                                        : glDarkPrimaryColor.withOpacity(0.5),
                                    height: 1,
                                  ),
                                )
                                .align(TextAlign.right)
                                .make(),
                          ),
                          const SizedBox(width: 8),
                          CupertinoSwitch(
                            // FIX: Inverted logic to match UI placement
                            // Metric is Left (False/OFF), US is Right (True/ON)
                            value: !authController.heightInCms.value, 
                            onChanged: (v) {
                              // If v is true (Switch moved Right to US), set Cms to false
                              // If v is false (Switch moved Left to Metric), set Cms to true
                              authController.heightInCms.value = !v;
                              authController.convertHeight();
                            },
                            activeColor: glLightThemeColor,
                          ),
                          const SizedBox(width: 8),
                          // RIGHT SIDE: US
                          Flexible(
                            child: "US (Feet & Inches)"
                                .text
                                .textStyle(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    // Active (Dark) when heightInCms is FALSE
                                    color: authController.heightInCms.value
                                        ? glDarkPrimaryColor.withOpacity(0.5)
                                        : glDarkPrimaryColor,
                                    height: 1,
                                  ),
                                )
                                .make(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ).pOnly(bottom: 50),
                    // -------------------------------------------------------------
                    Obx(
                      () => authController.heightInCms.value
                          ? Column(
                              children: [
                                const SizedBox(height: 16),
                                "Centimeters"
                                    .text
                                    .textStyle(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20, // Increased size
                                        color: glDarkPrimaryColor,
                                        height: 1,
                                      ),
                                    )
                                    .make(),
                                const SizedBox(height: 16), // Increased spacing
                                NumberPicker(
                                  value: authController
                                      .selectedHeightInCms.value
                                      .toInt(),
                                  minValue: 75,
                                  maxValue: 300,
                                  step: 1,
                                  haptics: true,
                                  onChanged: (value) => authController
                                      .selectedHeightInCms
                                      .value = double.parse(value.toString()),
                                  selectedTextStyle: Get
                                      .theme.textTheme.headlineLarge!
                                      .copyWith(fontSize: 50),
                                  itemHeight: 80,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(glBorderRadius),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            )
                              .animate()
                              .fadeIn(
                                duration: (1200 / 3).ms,
                                curve: Curves.easeOutQuad,
                                delay: (200 / 3).ms,
                              )
                              .slideX()
                              .pOnly(left: 10, right: 10)
                          : Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        "Feet"
                                            .text
                                            .textStyle(
                                              TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20, // Increased size
                                                color: glDarkPrimaryColor,
                                                height: 1,
                                              ),
                                            )
                                            .make(),
                                        NumberPicker(
                                          value: authController
                                              .selectedHeightInFeet.value,
                                          minValue: 3,
                                          maxValue: 8,
                                          step: 1,
                                          haptics: true,
                                          onChanged: (value) {
                                            authController.selectedHeightInFeet
                                                .value = value;
                                            authController.selectedHeightInFeet
                                                .refresh();
                                            authController.convertHeight();
                                          },
                                          selectedTextStyle: Get
                                              .theme.textTheme.headlineLarge!
                                              .copyWith(fontSize: 50),
                                          itemHeight: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                glBorderRadius),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 40), // Added horizontal space
                                    Column(
                                      children: [
                                        "Inches"
                                            .text
                                            .textStyle(
                                              TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20, // Increased size
                                                color: glDarkPrimaryColor,
                                                height: 1,
                                              ),
                                            )
                                            .make(),
                                        NumberPicker(
                                          value: authController
                                              .selectedHeightInInches.value,
                                          minValue: 0,
                                          maxValue: 11,
                                          step: 1,
                                          haptics: true,
                                          onChanged: (value) {
                                            authController
                                                .selectedHeightInInches
                                                .value = value;
                                            authController.selectedHeightInFeet
                                                .refresh();
                                            authController.convertHeight();
                                          },
                                          selectedTextStyle: Get
                                              .theme.textTheme.headlineLarge!
                                              .copyWith(fontSize: 50),
                                          itemHeight: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                glBorderRadius),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                              ],
                            )
                              .animate()
                              .fadeIn(
                                duration: (1200 / 3).ms,
                                curve: Curves.easeOutQuad,
                                delay: (200 / 3).ms,
                              )
                              .slideX()
                              .pOnly(left: 10, right: 10),
                    ),
                  ],
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
                      onTap: authController.onNextButtonPressed,
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