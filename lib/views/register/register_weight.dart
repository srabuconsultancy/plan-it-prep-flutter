import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for the switch
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../core.dart'; // Assuming this contains glDarkPrimaryColor, etc.

class RegisterWeight extends StatelessWidget {
  const RegisterWeight({super.key});

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
                child: SingleChildScrollView(
                  // Added bottom padding so content isn't hidden by bottom buttons
                  padding: const EdgeInsets.only(bottom: 120), 
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
                      RichText(
                        text: TextSpan(
                          text: 'What\'s your Weight?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // fontSize: 22, // Example size, adjust as needed
                            color:
                                glDarkPrimaryColor, // Set color to dark for readability
                          ),
                        ),
                      )
                          .animate()
                          .shimmer(
                              duration: (1200 / 3).ms, color: glLightThemeColor)
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (300 / 3).ms,
                          )
                          .slideX(),
                      const SizedBox(
                        height: 10,
                      ),
                      // --- 1. UNIT TOGGLE ---
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child:
                                  "Metric (KG)" // Changed label to reflect unit system
                                      .text
                                      .textStyle(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color:
                                              authController.weightInLbs.value
                                                  ? glDarkPrimaryColor
                                                      .withOpacity(0.5)
                                                  : glDarkPrimaryColor,
                                          height: 1,
                                        ),
                                      )
                                      .align(TextAlign.right)
                                      .make(),
                            ),
                            const SizedBox(width: 8),
                            CupertinoSwitch(
                              value: authController.weightInLbs.value,
                              onChanged: (v) {
                                authController.weightInLbs.value =
                                    v; // Use 'v' directly
                                authController.convertWeight();
                              },
                              activeColor:
                                  glLightThemeColor, // Set active color
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child:
                                  "US (Lbs)" // Changed label to reflect unit system
                                      .text
                                      .textStyle(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color:
                                              authController.weightInLbs.value
                                                  ? glDarkPrimaryColor
                                                  : glDarkPrimaryColor
                                                      .withOpacity(0.5),
                                          height: 1,
                                        ),
                                      )
                                      .make(),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Obx(
                        () => !authController.weightInLbs.value
                            ? Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Removed "Gm" column
                                      Flexible(
                                        child: "KG"
                                            .text
                                            .textStyle(
                                              TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: glDarkPrimaryColor,
                                                height: 1,
                                              ),
                                            )
                                            .make(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Changed from DecimalNumberPicker to NumberPicker
                                  NumberPicker(
                                    value: authController.selectedWeightInKGS.value.toInt().clamp(30, 150),
                                    minValue: 30,
                                    maxValue: 150,
                                    haptics: true,
                                    itemHeight: 60,
                                    selectedTextStyle: Get
                                        .theme.textTheme.headlineLarge!
                                        .copyWith(fontSize: 45),
                                    onChanged: (value) => authController
                                        .selectedWeightInKGS
                                        .value = value.toDouble(),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(glBorderRadius),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                  const SizedBox(height: 0),
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
                                  "Lbs" // Only show Lbs label
                                      .text
                                      .textStyle(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: glDarkPrimaryColor,
                                          height: 1,
                                        ),
                                      )
                                      .make(),
                                  const SizedBox(height: 20),
                                  // Changed from DecimalNumberPicker to NumberPicker
                                  NumberPicker(
                                    value: authController.selectedWeightInLbs.value.toInt().clamp(66, 397),
                                    minValue: 66,
                                    maxValue: 397,
                                    haptics: true,
                                    itemHeight: 60,
                                    selectedTextStyle: Get
                                        .theme.textTheme.headlineLarge!
                                        .copyWith(fontSize: 45),
                                    onChanged: (value) => authController
                                        .selectedWeightInLbs
                                        .value = value.toDouble(),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(glBorderRadius),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'What\'s your',
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Goal ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: glLightThemeColor,
                              ),
                            ),
                            const TextSpan(text: 'Weight?'),
                          ],
                        ),
                      )
                          .animate()
                          .shimmer(
                              duration: (1200 / 3).ms, color: glLightThemeColor)
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (300 / 3).ms,
                          )
                          .slideX(),
                      SizedBox(
                        height: 30,
                        child: Obx(
                          () {
                            String text = "";
                            // The logic below assumes the controller handles conversion internally
                            if (authController.selectedGoalWeightInKGS.value >
                                authController.selectedWeightInKGS.value) {
                              text =
                                  " gain ${Helper.formatIfDecimal((authController.selectedGoalWeightInKGS.value - authController.selectedWeightInKGS.value).abs())} KG";
                            } else if (authController
                                    .selectedGoalWeightInKGS.value <
                                authController.selectedWeightInKGS.value) {
                              text =
                                  " loose ${(authController.selectedWeightInKGS.value - authController.selectedGoalWeightInKGS.value).abs().toStringAsFixed(2)} KG";
                            } else {}
                            return text != ""
                                ? RichText(
                                    text: TextSpan(
                                      text: 'You want to',
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' $text',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: glLightThemeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : "".text.make();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => !authController.weightInLbs.value
                            ? Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Removed "Gm" column
                                      Flexible(
                                        child: "KG"
                                            .text
                                            .textStyle(
                                              TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: glDarkPrimaryColor,
                                                height: 1,
                                              ),
                                            )
                                            .make(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Changed from DecimalNumberPicker to NumberPicker
                                  NumberPicker(
                                    value: authController.selectedGoalWeightInKGS.value.toInt().clamp(30, 150),
                                    minValue: 30,
                                    maxValue: 150,
                                    haptics: true,
                                    itemHeight: 60,
                                    selectedTextStyle: Get
                                        .theme.textTheme.headlineLarge!
                                        .copyWith(fontSize: 45),
                                    onChanged: (value) => authController
                                        .selectedGoalWeightInKGS
                                        .value = value.toDouble(),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(glBorderRadius),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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
                                  "Lbs" // Only show Lbs label
                                      .text
                                      .textStyle(
                                        TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          color: glDarkPrimaryColor,
                                          height: 1,
                                        ),
                                      )
                                      .make(),
                                  const SizedBox(height: 8),
                                  // Changed from DecimalNumberPicker to NumberPicker
                                  NumberPicker(
                                    value: authController.selectedGoalWeightInLBS.value.toInt().clamp(66, 397),
                                    minValue: 66,
                                    maxValue: 397,
                                    haptics: true,
                                    itemHeight: 60,
                                    selectedTextStyle: Get
                                        .theme.textTheme.headlineLarge!
                                        .copyWith(fontSize: 45),
                                    onChanged: (value) => authController
                                        .selectedGoalWeightInLBS
                                        .value = value.toDouble(),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(glBorderRadius),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
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