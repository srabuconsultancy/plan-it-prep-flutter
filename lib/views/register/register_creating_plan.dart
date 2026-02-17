import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

// import 'package:spflutter_number_picker/spflutter_number_picker.dart';

import '../../core.dart';

class RegisterCreatingPlan extends StatelessWidget {
  const RegisterCreatingPlan({super.key});
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                        color: glDarkPrimaryColor,
                        height: 1,
                        shadows: const [
                          // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                        ],
                      ),
                    )
                        .animate()
                        .shimmer(duration: (1200 / 3).ms, color: glLightThemeColor)
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
                      value: (authController.registerProcessPageIndex.value) / (authController.registerProcessPages.length - 1),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 8,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'What\'s your Weight?',
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
                        .shimmer(duration: (1200 / 3).ms, color: glLightThemeColor)
                        .fadeIn(
                          duration: (1200 / 3).ms,
                          curve: Curves.easeOutQuad,
                          delay: (300 / 3).ms,
                        )
                        .slideX(),
                    const SizedBox(
                      height: 50,
                    ),
                    /*Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: "Weight In KGs"
                                .text
                                .textStyle(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: glDarkPrimaryColor,
                                    height: 1,
                                    shadows: const [
                                      // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                    ],
                                  ),
                                )
                                .align(TextAlign.right)
                                .make(),
                          ),
                          const SizedBox(width: 8),
                          CupertinoSwitch(
                            value: authController.weightInLbs.value,
                            onChanged: (v) {
                              authController.weightInLbs.value = !authController.weightInLbs.value;
                              authController.weightInLbs.refresh();
                              authController.convertWeight();
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: "Weight in lbs"
                                .text
                                .textStyle(
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: glDarkPrimaryColor,
                                    height: 1,
                                    shadows: const [
                                      // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                    ],
                                  ),
                                )
                                .make(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),*/
                    const SizedBox(
                      height: 50,
                    ),
                    Obx(
                      () => !authController.weightInLbs.value
                          ? Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: "KG"
                                          .text
                                          .textStyle(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: glDarkPrimaryColor,
                                              height: 1,
                                              shadows: const [
                                                // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                              ],
                                            ),
                                          )
                                          .make(),
                                    ),
                                    const SizedBox(
                                      width: 50,
                                    ),
                                    Flexible(
                                      child: "Gm"
                                          .text
                                          .textStyle(
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: glDarkPrimaryColor,
                                              height: 1,
                                              shadows: const [
                                                // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                              ],
                                            ),
                                          )
                                          .make(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DecimalNumberPicker(
                                  value: authController.selectedWeightInKGS.value,
                                  minValue: 30,
                                  haptics: true,
                                  decimalPlaces: 3,
                                  maxValue: 100,
                                  itemHeight: 80,
                                  selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 45),
                                  onChanged: (value) => authController.selectedWeightInKGS.value = value.toDouble(),
                                  integerDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                  ),
                                  decimalDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            )
                              .animate()
                              .fadeIn(
                                duration: (1200 / 3).ms,
                                curve: Curves.easeOutQuad,
                                delay: (600 / 3).ms,
                              )
                              .slideX()
                              .pOnly(left: 10, right: 10)
                          : Column(
                              children: [
                                const SizedBox(height: 16),
                                "KG"
                                    .text
                                    .textStyle(
                                      TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: glDarkPrimaryColor,
                                        height: 1,
                                        shadows: const [
                                          // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                        ],
                                      ),
                                    )
                                    .make()
                                    .centered(),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: "Lbs"
                                      .text
                                      .textStyle(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: glDarkPrimaryColor,
                                          height: 1,
                                          shadows: const [
                                            // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                          ],
                                        ),
                                      )
                                      .make(),
                                ),
                                const SizedBox(height: 16),
                                DecimalNumberPicker(
                                  value: authController.selectedWeightInLbs.value,
                                  minValue: 66,
                                  maxValue: 397,
                                  haptics: true,
                                  decimalPlaces: 3,
                                  itemHeight: 80,
                                  selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 45),
                                  onChanged: (value) => authController.selectedWeightInLbs.value = value.toDouble(),
                                  integerDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                  ),
                                  decimalDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            )
                              .animate()
                              .fadeIn(
                                duration: (1200 / 3).ms,
                                curve: Curves.easeOutQuad,
                                delay: (600 / 3).ms,
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
