import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player/video_player.dart';

import '../../core.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late VideoPlayerController _videoController;
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: glLightPrimaryColor.withValues(alpha: 0.7)),
    ),
  );

  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  UserController controller = Get.find();
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    _videoController =
        VideoPlayerController.asset('assets/videos/startup-video.mp4');

    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();

    /// In case you need an SMS autofill feature
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Get.theme.primaryColor,
          statusBarIconBrightness: Brightness.light),
    );
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: Stack(
                children: [
                  // VIDEO
                  //VideoPlayer(_videoController),

                  // COLOR OVERLAY WITH OPACITY
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFFF6F61).withOpacity(0.2),
                    ),
                  ),
                  VideoPlayer(_videoController),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: Get.width,
          height: Get.height,
          color: Colors.black12,
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            excludeHeaderSemantics: false,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: glLightPrimaryColor,
                shadows: [
                  Shadow(
                      offset: const Offset(0.5, 0.5),
                      color: glLightPrimaryColor.withValues(alpha: 0.6),
                      blurRadius: 4),
                ],
              ),
            ),
            centerTitle: false,
            leadingWidth: 25,
            title: "OTP Verification"
                .text
                .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                    color: glLightPrimaryColor,
                    shadows: [
                      Shadow(
                          offset: const Offset(0.5, 0.5),
                          color: glLightPrimaryColor.withValues(alpha: 0.6),
                          blurRadius: 4),
                    ],
                    fontSize: 14))
                .make(),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.close,
                  color: glLightPrimaryColor,
                  shadows: [
                    Shadow(
                        offset: const Offset(0.5, 0.5),
                        color: glLightPrimaryColor.withValues(alpha: 0.6),
                        blurRadius: 4),
                  ],
                ),
              )
            ],
          ),
          body: PopScope(
            canPop: true, // Prevent default pop
            onPopInvokedWithResult: (didPop, result) {
              // No action needed, as back navigation is blocked
            },
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  "Enter Verification Code"
                      .tr
                      .text
                      .textStyle(Get.theme.textTheme.headlineSmall!.copyWith(
                        color: glLightPrimaryColor,
                        shadows: [
                          Shadow(
                              offset: const Offset(0.5, 0.5),
                              color: glLightPrimaryColor.withValues(alpha: 0.6),
                              blurRadius: 4),
                        ],
                      ))
                      .center
                      .wide
                      .lineHeight(1.5)
                      .make()
                      .centered()
                      .pOnly(bottom: 15)
                      .pSymmetric(h: 20)
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                      )
                      .slideX(),
                  Column(
                    children: [
                      "We have sent a verification code to "
                          .text
                          .textStyle(
                            Get.theme.textTheme.bodySmall!.copyWith(
                                color: glLightPrimaryColor,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      color: glLightPrimaryColor.withValues(
                                          alpha: 0.6),
                                      blurRadius: 4),
                                ],
                                fontWeight: FontWeight.w500),
                          )
                          .center
                          .make()
                          .centered()
                          .pOnly(bottom: 5),
                      controller.phoneNumber.value.text
                          .textStyle(
                            Get.theme.textTheme.bodySmall!.copyWith(
                                color: glLightPrimaryColor,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      color: glLightPrimaryColor.withValues(
                                          alpha: 0.6),
                                      blurRadius: 4),
                                ],
                                fontWeight: FontWeight.w600),
                          )
                          .center
                          .make()
                          .centered()
                    ],
                  )
                      .pSymmetric(h: 20)
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                      )
                      .slideX(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Directionality(
                      // Specify direction if desired
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: pinController,
                        focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        length: 6,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        validator: (value) {
                          return value == '123456' ? null : 'Pin is incorrect';
                        },
                        hapticFeedbackType: HapticFeedbackType.mediumImpact,
                        onCompleted: (v) {
                          controller.otp = v;
                          controller.verifyOtp();
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                          controller.otp = value;
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: glLightThemeColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: glLightPrimaryColor),
                            color: glLightPrimaryColor,
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: glLightPrimaryColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: glLightPrimaryColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: glLightPrimaryColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ).pSymmetric(h: 20),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // ButtonWidget(
                  //   border: 1,
                  //   borderColor: Get.theme.colorScheme.primary.withValues(alpha:0),
                  //   bgColor: Get.theme.colorScheme.primary.withValues(alpha:0.9),
                  //   textColor: Get.theme.highlightColor,
                  //   title: "${(controller.userController.isPhoneEdit.value || controller.userController.isEmailEdit.value) ? 'Verify & Update' : 'Verify'}",
                  //   onTap: () {
                  //     if (controller.userController.isPhoneEdit.value || controller.userController.isEmailEdit.value) {
                  //       controller.updatePhoneEmail();
                  //     } else {
                  //       controller.verifyOtp();
                  //     }
                  //   },
                  // ).pSymmetric(h: 20),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Didn't receive OTP?"
                            .text
                            .textStyle(
                              Get.theme.textTheme.headlineSmall!.copyWith(
                                color: glLightPrimaryColor,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      color: glLightPrimaryColor.withValues(
                                          alpha: 0.6),
                                      blurRadius: 4),
                                ],
                                fontSize: 12,
                              ),
                            )
                            .make()
                            .pSymmetric(h: 5),
                        const SizedBox(
                          width: 20,
                        ),
                        (controller.bHideTimer.value
                                ? "${'Resend in'.tr} ${controller.countTimer.value} ${'sec'.tr}"
                                : "Resend again".tr)
                            .text
                            .textStyle(
                              Get.theme.textTheme.headlineSmall!.copyWith(
                                color: glLightPrimaryColor,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(0.5, 0.5),
                                      color: glLightPrimaryColor.withValues(
                                          alpha: 0.6),
                                      blurRadius: 4),
                                ],
                                fontSize: 12,
                              ),
                            )
                            .make()
                            .onTap(() async {
                          if (!controller.bHideTimer.value) {
                            await controller.resendOtp();
                            controller.startTimer();
                          }
                        }),
                      ],
                    ).pSymmetric(h: 20, v: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
