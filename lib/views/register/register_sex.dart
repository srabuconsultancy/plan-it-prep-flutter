import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterSex extends StatelessWidget {
  const RegisterSex({super.key});
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
                        shadows: [
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
                        shadows: [
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
                      'What\'s your Sex?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: glDarkPrimaryColor,
                        height: 1,
                        shadows: [
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
                      height: 50,
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded( // <-- FIX: Added Expanded
                            child: Stack(
                              children: [
                                Container(
                                  // width: Get.width / 2.5, // <-- FIX: Removed fixed width
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: authController.selectedGender.value.value == 'M' ? glLightPrimaryColor : glLightDividerColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                    boxShadow: [
                                      BoxShadow(
                                        color: authController.selectedGender.value.value == 'M' ? glLightThemeColor.withValues(alpha: 0.4) : glDarkPrimaryColor.withValues(alpha: 0.01),
                                        offset: const Offset(0, 3),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Lottie.asset(
                                        'assets/lottie/male.json',
                                      ),
                                      "Male".tr.text.make(),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ).onInkTap(() {
                                  authController.selectedGender.value = Gender('M', 'Male'.tr);
                                  authController.selectedGender.refresh();
                                }),
                                if (authController.selectedGender.value.value == "M")
                                  Positioned(
                                    right: 15,
                                    top: 10,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: glLightThemeColor,
                                    )
                                        .animate()
                                        .shimmer(
                                          duration: (1200 / 3).ms,
                                          color: glLightThemeColor,
                                          delay: (200.ms),
                                        )
                                        .fadeIn(
                                          duration: (1200 / 3).ms,
                                          curve: Curves.easeOutQuad,
                                          delay: (200.ms),
                                        )
                                        .slideY(),
                                  )
                              ],
                            ),
                          ),
                          Expanded( // <-- FIX: Added Expanded
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: authController.selectedGender.value.value == 'F' ? glLightPrimaryColor : glLightDividerColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(glBorderRadius),
                                    boxShadow: [
                                      BoxShadow(
                                        color: authController.selectedGender.value.value == 'F' ? glLightThemeColor.withValues(alpha: 0.4) : glDarkPrimaryColor.withValues(alpha: 0.01),
                                        offset: const Offset(0, 3),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                  // width: Get.width / 2.5, // <-- FIX: Removed fixed width
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Lottie.asset(
                                        'assets/lottie/female.json',
                                      ),
                                      "Female".tr.text.make(),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                ).onInkTap(() {
                                  authController.selectedGender.value = Gender('F', 'Female'.tr);
                                  authController.selectedGender.refresh();
                                }),
                                if (authController.selectedGender.value.value == "F")
                                  Positioned(
                                    right: 15,
                                    top: 10,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: glLightThemeColor,
                                    )
                                        .animate()
                                        .shimmer(
                                          duration: (1200 / 3).ms,
                                          color: glLightThemeColor,
                                          delay: (200.ms),
                                        )
                                        .fadeIn(
                                          duration: (1200 / 3).ms,
                                          curve: Curves.easeOutQuad,
                                          delay: (200.ms),
                                        )
                                        .slideY(),
                                  )
                              ],
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (200 / 3).ms,
                          )
                          .slideX(), // <-- FIX: Removed .pOnly
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