import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../core.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserController controller = Get.find();
  late VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    // RootService.to.config.value.appleLogin = true;
    _videoController =
        VideoPlayerController.asset('assets/videos/startup-video.mp4');

    _videoController.addListener(() {
      setState(() {});
    });
    _videoController.setLooping(true);
    _videoController.initialize().then((_) => setState(() {}));
    _videoController.play();
  }

  DateTime? currentBackPressTime;
  var activeIndex = 0.obs;
  var focusNode = FocusNode();
  var openSimNoPopup = false.obs;
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
          statusBarColor: glLightPrimaryColor,
          statusBarIconBrightness: Brightness.light),
    );
    return Container(
      color: glDarkPrimaryColor,
      child: Stack(
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
            body: PopScope(
              canPop: true, // Prevent default pop
              onPopInvokedWithResult: (didPop, result) {
                // No action needed, as back navigation is blocked
              },
              child: Form(
                key: controller.loginFormKey,
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      snap: false,
                      floating: false,
                      expandedHeight: Get.height *
                          (0.47 -
                              (Platform.isIOS &&
                                      RootService.to.config.value.appleLogin ==
                                          true
                                  ? 0.07
                                  : 0)),
                      foregroundColor: Get.theme.highlightColor,
                      backgroundColor: Colors.transparent,
                      /*flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        background: Container(
                          width: Get.width,
                          height: Get.height * 0.47,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 50,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () async {},
                                  child: Container(
                                    decoration: BoxDecoration(color: glLightIconColor.withValues(alpha:0.4), borderRadius: BorderRadius.circular(10)),
                                    child: CustomPaint(
                                      size: Size(Get.width / 3,
                                          ((Get.width / 3) * 1).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                                      painter: RPSCustomPainter(fillPercentage: 40),

                                    ) */ /*"Skip"
                                        .tr
                                        .text
                                        .textStyle(Get.theme.textTheme.bodySmall!.copyWith(
                                          color: glLightPrimaryColor.withValues(alpha:0.9),
                                          fontSize: 13,

                                        ))
                                        .center
                                        .make()*/ /*
                                        .centered()
                                        .pOnly(left: 15, right: 15, top: 5, bottom: 7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),*/
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Obx(
                            () => Stack(
                              children: [
                                SizedBox(
                                  width: Get.width,
                                  height: Get.height *
                                      (0.5 +
                                          (Platform.isIOS &&
                                                  RootService.to.config.value
                                                          .appleLogin ==
                                                      true
                                              ? 0.07
                                              : 0)),
                                  // color: Colors.black26,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            controller.isExpand.value ? 25 : 0,
                                        // height: 25,
                                      ),
                                      "Your No #1 Trusted Dietitian App"
                                          .tr
                                          .text
                                          .textStyle(
                                            Get.theme.textTheme.headlineSmall!
                                                .copyWith(
                                              color: glLightPrimaryColor,
                                              shadows: [
                                                Shadow(
                                                    offset:
                                                        const Offset(0.5, 0.5),
                                                    color: glLightPrimaryColor
                                                        .withValues(alpha: 0.6),
                                                    blurRadius: 4),
                                              ],
                                            ),
                                          )
                                          .center
                                          .wide
                                          .lineHeight(1.5)
                                          .make()
                                          .centered()
                                          .pOnly(bottom: 20)
                                          .pSymmetric(h: 20)
                                          .animate()
                                          .fadeIn(
                                            duration: 600.ms,
                                          )
                                          .slideX(),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: glLightPrimaryColor
                                                      .withValues(alpha: 0.7))),
                                          "Log in or Sign up"
                                              .tr
                                              .text
                                              .textStyle(
                                                Get.theme.textTheme.bodySmall!
                                                    .copyWith(
                                                  color: glLightPrimaryColor
                                                      .withValues(alpha: 0.9),
                                                  fontWeight: FontWeight.w600,
                                                  shadows: [
                                                    Shadow(
                                                        offset: const Offset(
                                                            0.5, 0.5),
                                                        color:
                                                            glLightPrimaryColor
                                                                .withValues(
                                                                    alpha: 0.6),
                                                        blurRadius: 4),
                                                  ],
                                                ),
                                              )
                                              .make()
                                              .pSymmetric(h: 10),
                                          Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: glLightPrimaryColor
                                                      .withValues(alpha: 0.7))),
                                        ],
                                      )
                                          .pSymmetric(h: 20)
                                          .animate()
                                          .fadeIn(
                                            duration: 600.ms,
                                            delay: 200.ms,
                                          )
                                          .slideX(),
                                      if (RootService
                                              .to.config.value.mobileLogin ||
                                          RootService
                                              .to.config.value.emailLogin) ...[
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: controller
                                              .userInputController.value,
                                          style: TextStyle(
                                            color: glLightIconColor,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          keyboardType: RootService.to.config
                                                      .value.mobileLogin &&
                                                  !RootService.to.config.value
                                                      .emailLogin
                                              ? TextInputType.number
                                              : TextInputType.emailAddress,
                                          validator: (input) {
                                            if (input!.isEmpty) {
                                              return RootService.to.config.value
                                                          .mobileLogin &&
                                                      !RootService.to.config
                                                          .value.emailLogin
                                                  ? "Mobile number can't be empty"
                                                  : RootService.to.config.value
                                                              .emailLogin &&
                                                          !RootService.to.config
                                                              .value.mobileLogin
                                                      ? "Email can't be empty"
                                                      : "Input can't be empty";
                                            }
                                            if (RootService.to.config.value
                                                    .mobileLogin &&
                                                RootService.to.config.value
                                                    .emailLogin) {
                                              // Both enabled: autodetect input type
                                              if (GetUtils.isNumericOnly(
                                                      input) &&
                                                  GetUtils.isLengthEqualTo(
                                                      input, 10)) {
                                                return null; // Valid mobile number
                                              } else if (GetUtils.isEmail(
                                                  input)) {
                                                return null; // Valid email
                                              } else {
                                                return "Please enter a valid mobile number or email";
                                              }
                                            } else if (RootService.to.config
                                                    .value.mobileLogin &&
                                                GetUtils.isLengthLessThan(
                                                    input, 10)) {
                                              return "Mobile number should be 10 digits";
                                            } else if (RootService.to.config
                                                    .value.emailLogin &&
                                                !GetUtils.isEmail(input)) {
                                              return "Please enter a valid email address";
                                            }
                                            return null;
                                          },
                                          inputFormatters: RootService.to.config
                                                      .value.mobileLogin &&
                                                  !RootService.to.config.value
                                                      .emailLogin
                                              ? <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ]
                                              : null,
                                          onChanged: (input) {
                                            controller.userInput.value = input;
                                            if (RootService.to.config.value
                                                    .mobileLogin &&
                                                RootService.to.config.value
                                                    .emailLogin) {
                                              // Autodetect input type when both are enabled
                                              controller.isMobileInput.value =
                                                  GetUtils.isNumericOnly(input);
                                            }
                                          },
                                          onTap: () async {
                                            if (RootService.to.config.value
                                                    .mobileLogin &&
                                                !openSimNoPopup.value) {
                                              String? hint = await controller
                                                  .autoFillSMS.hint;
                                              //print(hint);
                                              if (hint != '') {
                                                controller.userInputController
                                                        .value =
                                                    TextEditingController(
                                                  text: hint!
                                                      .replaceAll('+91', '')
                                                      .replaceAll('+1', ''),
                                                );
                                                controller.userInputController
                                                    .refresh();
                                                controller.phoneNumber.value =
                                                    hint
                                                        .replaceAll('+91', '')
                                                        .replaceAll('+1', '');
                                                controller.phoneNumber
                                                    .refresh();
                                                controller.isMobileInput.value =
                                                    true;
                                              }
                                              focusNode.requestFocus();
                                              openSimNoPopup.value = true;
                                              openSimNoPopup.refresh();
                                            }
                                            await Future.delayed(650.ms);
                                            controller.scrollController
                                                .animToBottom();
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          autocorrect: true,
                                          onTapAlwaysCalled: true,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: glLightPrimaryColor,
                                            hintText: RootService.to.config
                                                        .value.mobileLogin &&
                                                    !RootService.to.config.value
                                                        .emailLogin
                                                ? "Mobile number".tr
                                                : RootService.to.config.value
                                                            .emailLogin &&
                                                        !RootService.to.config
                                                            .value.mobileLogin
                                                    ? "Email address".tr
                                                    : "Mobile number or Email"
                                                        .tr,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 0,
                                            ),
                                            prefixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Obx(
                                                  () => SvgPicture.asset(
                                                    controller
                                                            .isMobileInput.value
                                                        ? "assets/icons/mobile.svg"
                                                        : "assets/icons/email.svg",
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                            glLightThemeColor,
                                                            BlendMode.srcIn),
                                                    width: 20,
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Container(
                                                  height: 50,
                                                  width: 1,
                                                  color: glLightIconColor
                                                      .withValues(alpha: 0.1),
                                                ),
                                              ],
                                            ).pOnly(left: 20, right: 15),
                                            errorStyle:
                                                const TextStyle(fontSize: 13),
                                            hintStyle: Get
                                                .theme.textTheme.bodyLarge!
                                                .copyWith(
                                              color: glLightIconColor
                                                  .withValues(alpha: 0.2),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: glLightIconColor
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: glLightIconColor
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: glLightIconColor
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: glLightIconColor
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: glLightIconColor
                                                    .withValues(alpha: 0.15),
                                              ),
                                            ),
                                          ),
                                        ).pSymmetric(h: 20),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        CustomButtonWidget(
                                          border: 1,
                                          width: Get.width / 1.5,
                                          borderColor: glLightPrimaryColor,
                                          bgColor: glLightThemeColor,
                                          textColor: glLightPrimaryColor,
                                          title: "Continue".tr,
                                          onTap: () {
                                            if (controller
                                                .loginFormKey.currentState!
                                                .validate()) {
                                              controller.authenticate();
                                            }
                                          },
                                        ).pSymmetric(h: 20),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                      RootService.to.config.value.mobileLogin &&
                                              (RootService.to.config.value
                                                          .appleLogin ==
                                                      true ||
                                                  RootService.to.config.value
                                                          .googleLogin ==
                                                      true)
                                          ? Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        height: 1,
                                                        color:
                                                            glLightPrimaryColor
                                                                .withValues(
                                                                    alpha:
                                                                        0.7))),
                                                "OR"
                                                    .tr
                                                    .text
                                                    .textStyle(
                                                      Get.theme.textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        color:
                                                            glLightPrimaryColor
                                                                .withValues(
                                                                    alpha: 0.9),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        shadows: [
                                                          Shadow(
                                                              offset:
                                                                  const Offset(
                                                                      0.5, 0.5),
                                                              color: glLightPrimaryColor
                                                                  .withValues(
                                                                      alpha:
                                                                          0.6),
                                                              blurRadius: 4),
                                                        ],
                                                      ),
                                                    )
                                                    .make()
                                                    .pSymmetric(h: 10),
                                                Expanded(
                                                    child: Container(
                                                        height: 1,
                                                        color:
                                                            glLightPrimaryColor
                                                                .withValues(
                                                                    alpha:
                                                                        0.7))),
                                              ],
                                            )
                                              .pSymmetric(h: 20)
                                              .animate()
                                              .fadeIn(
                                                duration: 600.ms,
                                                delay: 200.ms,
                                              )
                                              .slideX()
                                          : const SizedBox(),
                                      Platform.isIOS &&
                                              RootService.to.config.value
                                                      .appleLogin ==
                                                  true
                                          ? ButtonTheme(
                                              height: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  // backgroundColor: Color(0xff000000),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SvgPicture.asset(
                                                      'assets/icons/apple.svg',
                                                      width: 25.0,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                              Get.theme
                                                                  .primaryColor,
                                                              BlendMode
                                                                  .srcATop),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    "Sign up with Apple"
                                                        .tr
                                                        .text
                                                        .center
                                                        .make(),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  controller.signInWithApple();
                                                },
                                              ),
                                            )
                                              .pOnly(bottom: 12)
                                              .marginSymmetric(
                                                  horizontal: 30, vertical: 10)
                                              .animate()
                                              .fadeIn(
                                                duration: 600.ms,
                                                delay: 200.ms,
                                              )
                                              .slideX()
                                          : const SizedBox(),
                                      RootService.to.config.value.googleLogin ==
                                              true
                                          ? ButtonTheme(
                                              height: 60,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/icons/small-google.png',
                                                      width: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    "Sign up with Google"
                                                        .tr
                                                        .text
                                                        .center
                                                        .make(),
                                                  ],
                                                ),
                                                onPressed: () async {
                                                  controller.signInWithGoogle();
                                                },
                                              ),
                                            )
                                              .pOnly(bottom: 12)
                                              .marginSymmetric(
                                                  horizontal: 30,
                                                  vertical: Platform.isIOS &&
                                                          RootService.to.config
                                                              .value.appleLogin
                                                      ? 0
                                                      : 10)
                                              .animate()
                                              .fadeIn(
                                                duration: 600.ms,
                                                delay: 200.ms,
                                              )
                                              .slideX()
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: SafeArea(
                                    bottom: true,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          "By continuing,you agree to our "
                                              .tr
                                              .text
                                              .textStyle(Get
                                                  .theme.textTheme.bodySmall!
                                                  .copyWith(
                                                fontSize: 12,
                                                color: glLightPrimaryColor,
                                                shadows: [
                                                  Shadow(
                                                      offset: const Offset(
                                                          0.5, 0.5),
                                                      color: glLightPrimaryColor
                                                          .withValues(
                                                              alpha: 0.6),
                                                      blurRadius: 4),
                                                ],
                                              ))
                                              .center
                                              .make()
                                              .centered()
                                              .pOnly(bottom: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              
                                              GestureDetector(
                                                onTap: () {
                                                  Helper.launchLinkedURL(
                                                      "https://planitprep.srabu.com/privacy-policy.html");
                                                },
                                                child: "Privacy Policy "
                                                    .tr
                                                    .text
                                                    .textStyle(Get
                                                        .theme
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                      color: glLightPrimaryColor
                                                          .withValues(
                                                              alpha: 0.8),
                                                      fontSize: 11,
                                                      shadows: [
                                                        Shadow(
                                                            offset:
                                                                const Offset(
                                                                    0.5,
                                                                    0.5),
                                                            color:
                                                                glLightPrimaryColor
                                                                    .withValues(
                                                                        alpha:
                                                                            0.6),
                                                            blurRadius: 4),
                                                      ],
                                                    ))
                                                    .center
                                                    .make()
                                                    .centered()
                                                    .pOnly(right: 10),
                                              ),
                                              
                                            ],
                                          )
                                        ],
                                      ).pSymmetric(h: 20, v: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
