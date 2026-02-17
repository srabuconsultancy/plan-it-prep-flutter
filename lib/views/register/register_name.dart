import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core.dart';

class RegisterName extends StatelessWidget {
  const RegisterName({super.key});

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
                      // 'What\'s your name?',
                      'Who are you?',
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
                      () => CustomFormField(
                        textFieldKey: authController.nameFieldKey,
                        textFieldHintText: "Enter your Full Name".tr,
                        textFieldController: authController.fullNameController.value,
                        textFieldBorderRadius: glBorderRadius,
                        textFieldOnChanged: (v) {
                          authController.fullName.value = v!;
                          authController.fullName.refresh();
                        },
                        textFieldValidator: (input) {
                          RegExp exp = RegExp(r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{2,}$");
                          if (input!.isEmpty) {
                            return "Name can't be empty".tr;
                          } else if (!exp.hasMatch(input)) {
                            return "Name can not include any special characters.".tr;
                          } else {
                            return null;
                          }
                        },
                        textFieldElevation: 0,
                        textFieldEnabledBorderColor: glDarkPrimaryColor,
                        textFieldPrefixIconWidget: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Icon(
                            Icons.person,
                            color: glLightThemeColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(0.5, 0.5),
                                blurRadius: 1.5,
                                color: glDarkPrimaryColor,
                              ),
                            ],
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
                child: CustomButtonWidget(
                  title: "Continue",
                  width: Get.width,
                  fontWeight: FontWeight.bold,
                  borderRadius: glBorderRadius,
                  bgColor: glLightThemeColor,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: authController.onNextButtonPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
