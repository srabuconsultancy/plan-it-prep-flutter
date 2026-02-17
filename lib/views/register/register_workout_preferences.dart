import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterWorkoutPreferences extends StatelessWidget {
  const RegisterWorkoutPreferences({super.key});

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
                      'Your Country',
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
                        )
                        .slideX(),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => CountryStateCityPicker(
                        countryTextController: authController.countryController,
                        stateTextController: authController.stateController,
                        cityTextController: authController.cityController,
                        dialogColor: Colors.grey.shade200,
                        textFieldDecoration: InputDecoration(
                          fillColor: Colors.blueGrey.shade100,
                          filled: true,
                          suffixIcon: const Icon(Icons.arrow_downward_rounded),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
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
