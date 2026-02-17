import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../core.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserController userController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    userController.fullName.value = UserService.to.currentUser.value.name;
    userController.phoneNumber.value = UserService.to.currentUser.value.phone;
    userController.email.value = UserService.to.currentUser.value.email;
    userController.selectedAge.value = UserService.to.currentUser.value.age;
    userController.selectedHeightInCms.value = UserService.to.currentUser.value.height;
    userController.heightInCms.value = true;
    userController.convertHeight();
    userController.heightInCms.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      backgroundColor: glLightestGrey,
      body: Obx(
        () => Form(
          key: userController.editProfileFormKey,
          child: ListView(
            children: [
              Obx(
                () => CustomFormField(
                  textFieldInitialValue: userController.fullName.value,
                  textFieldFocusedBorderColor: glLightestGrey,
                  textFieldLabelText: "Full Name",
                  textFieldPrefixIconWidget: const Icon(Icons.person),
                  textFieldBgColor: Colors.white,
                  textFieldBorderRadius: 10,
                  textFieldElevation: 0,
                  textFieldEnabledBorderColor: glLightThemeColor.withValues(alpha: 0.3),
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
                  textFieldOnChanged: (value) {
                    userController.fullName.value = value!;
                  },
                  textFieldKey: userController.nameFieldKey,
                ),
              ),
              // const SizedBox(height: 16),
              CustomFormField(
                textFieldKey: userController.emailFieldKey,
                textFieldInitialValue: userController.email.value,
                textFieldFocusedBorderColor: glLightestGrey,
                textFieldBgColor: Colors.white,
                textFieldLabelText: "Email",
                textFieldPrefixIconWidget: const Icon(Icons.email),
                textFieldBorderRadius: 10,
                textFieldElevation: 0,
                textFieldEnabledBorderColor: glLightThemeColor.withValues(alpha: 0.3),
                textFieldValidator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                textFieldOnChanged: (value) {
                  userController.email.value = value!;
                },
              ),
              // const SizedBox(height: 16),
              Obx(
                () => CustomFormField(
                  textFieldInitialValue: userController.phoneNumber.value,
                  textFieldFocusedBorderColor: glLightestGrey,
                  textFieldBgColor: Colors.white,
                  textFieldElevation: 0,
                  textFieldHeight: 50,
                  textFieldShadowColor: Colors.white,
                  textFieldLabelText: "Phone",
                  textFieldPrefixIconWidget: const Icon(Icons.mobile_friendly),
                  textFieldBorderRadius: 10,
                  textFieldEnabledBorderColor: glLightThemeColor.withValues(alpha: 0.3),
                  textFieldValidator: (input) {
                    if (input!.isEmpty) {
                      return "Phone can't be empty";
                    } else if (GetUtils.isLengthLessThan(input, 10)) {
                      return "Phone should be 10 digits only";
                    } else {
                      return null;
                    }
                  },
                  textFieldInputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textFieldOnChanged: (value) {
                    userController.phoneNumber.value = value!;
                  },
                  textFieldKey: userController.phoneFieldKey,
                ),
              ),
              // const SizedBox(height: 16),
              Obx(
                () => Column(
                  children: [
                    "Select Age".text.bold.size(20).make().objectCenterLeft(),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 160,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Transform.translate(
                          offset: const Offset(0, -20),
                          child: NumberPicker(
                            value: userController.selectedAge.value,
                            minValue: 12,
                            maxValue: 100,
                            step: 1,
                            haptics: true,
                            onChanged: (value) => userController.selectedAge.value = value,
                            selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 50),
                            itemHeight: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(glBorderRadius),
                            ),
                          ),
                        ),
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
                    .slideX()
                    .pOnly(left: 10, right: 10),
              ),
              // const SizedBox(height: 20),
              Obx(
                () => Column(
                  children: [
                    "Select Height".text.bold.size(20).make().objectCenterLeft(),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 220,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Transform.translate(
                          offset: const Offset(0, -20),
                          child: Column(
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
                                              fontSize: 14,
                                              color: glDarkPrimaryColor,
                                              height: 1,
                                              shadows: const [
                                                // Shadow(offset: const Offset(1, 1), color: glDarkPrimaryColor.withValues(alpha:0.6), blurRadius: 4),
                                              ],
                                            ),
                                          )
                                          .make(),
                                      NumberPicker(
                                        value: userController.selectedHeightInFeet.value,
                                        minValue: 3,
                                        maxValue: 8,
                                        step: 1,
                                        haptics: true,
                                        onChanged: (value) {
                                          userController.selectedHeightInFeet.value = value;
                                          userController.selectedHeightInFeet.refresh();
                                          userController.convertHeight();
                                        },
                                        selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 50),
                                        itemHeight: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(glBorderRadius),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      "Inches"
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
                                      NumberPicker(
                                        value: userController.selectedHeightInInches.value,
                                        minValue: 0,
                                        maxValue: 11,
                                        step: 1,
                                        haptics: true,
                                        onChanged: (value) {
                                          userController.selectedHeightInInches.value = value;
                                          userController.selectedHeightInInches.refresh();
                                          userController.convertHeight();
                                        },
                                        selectedTextStyle: Get.theme.textTheme.headlineLarge!.copyWith(fontSize: 50),
                                        itemHeight: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(glBorderRadius),
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
                    .slideX()
                    .pOnly(left: 10, right: 10),
              ),
              ElevatedButton(
                onPressed: () {
                  userController.editProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: glLightThemeColor,
                  foregroundColor: glLightButtonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  textStyle: GoogleFonts.poppins().copyWith(fontSize: buttonTextFontSize, color: glLightButtonTextColor, fontWeight: FontWeight.w400),
                ),
                child: const Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ).pSymmetric(h: 20, v: 15),
    );
  }
}
