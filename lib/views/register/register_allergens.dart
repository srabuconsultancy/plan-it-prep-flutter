import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:collection/collection.dart';

import '../../core.dart';

class RegisterAllergies extends StatefulWidget {
  const RegisterAllergies({super.key});

  @override
  State<RegisterAllergies> createState() => _RegisterAllergiesState();
}

class _RegisterAllergiesState extends State<RegisterAllergies> {
  late TextEditingController _othersController;
  final UserController _authController = Get.find();

  // Simple local state to track if "Others" box is open
  bool _isOthersOptionSelected = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing value from AuthController
    _othersController =
        TextEditingController(text: _authController.otherAllergies.value);

    // If there is already text saved, make sure the option shows as selected
    _isOthersOptionSelected = _authController.otherAllergies.value.isNotEmpty;

    // Listen for typing and update the variable immediately
    _othersController.addListener(() {
      _authController.otherAllergies.value = _othersController.text;
    });
  }

  @override
  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
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
                          'Step ${int.parse(_authController.registerProcessPageIndex.value.toString()) + 1} of ${_authController.registerProcessPages.length}',
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
                          value: (_authController
                                  .registerProcessPageIndex.value) /
                              (_authController.registerProcessPages.length - 1),
                          borderRadius: BorderRadius.circular(10),
                          minHeight: 8,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Any Allergies?',
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
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            // --- EXISTING DYNAMIC LIST ---
                            ...RootService.to.config.value.allergens
                                .mapIndexed(
                                  (i, allergen) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2.5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: _authController
                                              .selectedAllergies.value
                                              .contains(allergen)
                                          ? glLightPrimaryColor
                                          : glLightDividerColor.withValues(
                                              alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(glBorderRadius),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _authController
                                                  .selectedAllergies.value
                                                  .contains(allergen)
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
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        allergen.name.tr.text.size(12).make(),
                                        if (_authController.selectedAllergies
                                            .contains(allergen))
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
                                                delay: (200.ms + (i * 33).ms),
                                              )
                                              .fadeIn(
                                                duration: (1200 / 3).ms,
                                                curve: Curves.easeOutQuad,
                                                delay: (200.ms + (i * 33).ms),
                                              )
                                              .slideY(),
                                      ],
                                    ).onInkTap(() {
                                      if (!_authController.selectedAllergies
                                          .contains(allergen)) {
                                        _authController.selectedAllergies
                                            .add(allergen);
                                      } else {
                                        _authController.selectedAllergies
                                            .remove(allergen);
                                      }
                                      _authController.selectedAllergies
                                          .refresh();
                                    }),
                                  )
                                      .animate()
                                      .shimmer(
                                          duration: (1200 / 3).ms,
                                          color: glLightThemeColor)
                                      .fadeIn(
                                        duration: (1200 / 3).ms,
                                        curve: Curves.easeOutQuad,
                                        delay: ((i * 100) / 3).ms,
                                      )
                                      .slideX(),
                                )
                                .toList(),

                            // --- MANUAL "OTHERS" OPTION ---
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 2.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                // Use local boolean for color state
                                color: _isOthersOptionSelected
                                    ? glLightPrimaryColor
                                    : glLightDividerColor.withValues(
                                        alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(glBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: _isOthersOptionSelected
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  "Others".tr.text.size(12).make(),
                                  if (_isOthersOptionSelected)
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
                                        )
                                        .fadeIn(
                                          duration: (1200 / 3).ms,
                                          curve: Curves.easeOutQuad,
                                        )
                                        .slideY(),
                                ],
                              ).onInkTap(() {
                                // --- SIMPLIFIED TOGGLE LOGIC ---
                                setState(() {
                                  _isOthersOptionSelected =
                                      !_isOthersOptionSelected;

                                  // If deselected, clear the text and the variable
                                  if (!_isOthersOptionSelected) {
                                    _othersController.clear();
                                    _authController.otherAllergies.value = "";
                                  }
                                });
                              }),
                            )
                                .animate()
                                .shimmer(
                                    duration: (1200 / 3).ms,
                                    color: glLightThemeColor)
                                .fadeIn(
                                  duration: (1200 / 3).ms,
                                  curve: Curves.easeOutQuad,
                                  delay: (500).ms, // Delay after the list
                                )
                                .slideX(),
                          ],
                        ),

                        // --- FREE TEXT BOX FOR "OTHERS" ---
                        // Shows only if the local boolean is true
                        if (_isOthersOptionSelected)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 5, right: 5),
                            child: TextFormField(
                              controller: _othersController,
                              maxLines: 2,
                              minLines: 1,
                              style: TextStyle(color: glDarkPrimaryColor),
                              decoration: InputDecoration(
                                hintText:
                                    "Please specify your other allergies...",
                                hintStyle: TextStyle(
                                    color: glDarkPrimaryColor.withOpacity(0.5)),
                                filled: true,
                                fillColor: glLightDividerColor.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(glBorderRadius),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(glBorderRadius),
                                  borderSide: BorderSide(
                                      color: glLightThemeColor, width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: -0.1, end: 0),
                          ),
                        // ----------------------------------

                        const SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
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
                      onTap: _authController.onPreviousButtonPressed,
                    ),
                    CustomButtonWidget(
                      title: "Next",
                      width: Get.width / 2.5,
                      fontWeight: FontWeight.bold,
                      borderRadius: glBorderRadius,
                      bgColor: glLightThemeColor,
                      height: 50,
                      onTap: _authController.onNextButtonPressed,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Container(
                color: glLightPrimaryColor,
                child: "Skip"
                    .text
                    .underline
                    .size(12)
                    .make()
                    .centered()
                    .onTap(_authController.onNextButtonPressed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
