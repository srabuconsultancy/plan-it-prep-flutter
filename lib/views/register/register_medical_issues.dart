import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

// import 'package:spflutter_number_picker/spflutter_number_picker.dart';

import '../../core.dart';
///not required
class RegisterMedicalIssues extends StatelessWidget {
  const RegisterMedicalIssues({super.key});

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
                        'Any Medical Condition?',
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
                        height: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: RootService.to.config.value.medicalIssues
                                .mapIndexed(
                                  (medConditionItem, i) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: authController.selectedMedicalIssues.value.contains(medConditionItem) ? glLightPrimaryColor : glLightDividerColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(glBorderRadius),
                                      boxShadow: [
                                        BoxShadow(
                                          color: authController.selectedMedicalIssues.value.contains(medConditionItem)
                                              ? glLightThemeColor.withValues(alpha: 0.4)
                                              : glDarkPrimaryColor.withValues(alpha: 0.01),
                                          offset: const Offset(0, 3),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        medConditionItem.name.tr.text.size(12).make().onInkTap(() {
                                          if (!authController.selectedMedicalIssues.contains(medConditionItem)) {
                                            authController.selectedMedicalIssues.add(medConditionItem);
                                          } else {
                                            authController.selectedMedicalIssues.remove(medConditionItem);
                                          }
                                          authController.selectedMedicalIssues.refresh();
                                        }),
                                        if (authController.selectedMedicalIssues.contains(medConditionItem))
                                          Icon(
                                            Icons.check_circle,
                                            color: glLightThemeColor,
                                            size: 14,
                                          )
                                              .pOnly(left: 5)
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
                                      ],
                                    ),
                                  )
                                      .animate()
                                      .shimmer(duration: (1200 / 3).ms, color: glLightThemeColor)
                                      .fadeIn(
                                        duration: (1200 / 3).ms,
                                        curve: Curves.easeOutQuad,
                                        delay: ((i * 100) / 3).ms,
                                      )
                                      .slideX(),
                                )
                                .toList(),
                          ).marginOnly(bottom: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 90,
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
            Positioned(
              bottom: 90,
              // height: 50,
              left: 0,
              right: 0,
              child: Container(
                // height: 50,
                color: glLightPrimaryColor,
                child: "Skip".text.underline.size(12).make().centered().onTap(authController.onNextButtonPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
