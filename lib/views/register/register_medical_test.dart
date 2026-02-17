import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterMedicalTest extends StatelessWidget {
  const RegisterMedicalTest({super.key});

  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height - 100,
                color: glLightPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Obx(
                    () => ListView(
                      controller: authController.medicalTestScrollController,
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
                            .slideX()
                            .centered(),
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
                            .slideX()
                            .centered(),
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
                          height: 20,
                        ),
                        Lottie.asset(
                          "assets/lottie/medical-test.json",
                          height: 200,
                        ).paddingAll(10),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Have you undergone any medical tests recently?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: glDarkPrimaryColor,
                            height: 1.5,
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
                            .slideX()
                            .centered(),
                        const SizedBox(
                          height: 20,
                        ),
                        ...authController.addTestsWidget.isNotEmpty ? authController.addTestsWidget : [],
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            "Add more".text.make(),
                            RoundContainer(
                              size: 30,
                              child: Icon(
                                Icons.add_circle,
                                color: glLightThemeColor,
                              ),
                            ),
                          ],
                        ).objectCenterRight().onInkTap(authController.addMoreTests).pOnly(right: 10),
                        const SizedBox(
                          height: 50,
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
                        title: "Continue",
                        width: Get.width / 2.5,
                        fontWeight: FontWeight.bold,
                        borderRadius: glBorderRadius,
                        bgColor: glLightThemeColor,
                        height: 50,
                        // margin: const EdgeInsets.symmetric(horizontal: 20),
                        onTap: () async {
                          authController.onNextButtonPressed.call();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              /*Positioned(
                bottom: 100,
                // height: 50,
                left: 0,
                right: 0,
                child: Container(
                  // height: 50,
                  color: glLightPrimaryColor,
                  child: "Skip & Continue".text.underline.size(12).make().centered().onTap((){
                      UserService.to.currentUser.value.membershipStartDate = DateTime.now();
                        UserService.to.currentUser.value.membershipEndDate = DateTime.now().add(const Duration(days: 30));
                        DashboardController dashboardController = Get.find();
                      dashboardController.getData();
                      Get.offNamed(Routes.dashboard);
                  }),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
