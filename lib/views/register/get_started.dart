import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as sc;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../core.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  UserController authController = Get.find();
  late VideoPlayerController _controller;
  RootController rootController = Get.find();
  @override
  void initState() {
    super.initState();
    if (UserService.to.currentUser.value.id > 0 &&
        UserService.to.currentUser.value.name != "") {
      //print("Dashboard page");
      sc.timeDilation = 1.0;
      Get.offNamed(Routes.dashboard);
    } else if (UserService.to.currentUser.value.id > 0 &&
        UserService.to.currentUser.value.name == "") {
      //print("Register page");
      Get.offNamed(Routes.register);
    } else {
      //continue
    }
    // rootController.getAppConfig();

    _controller =
        VideoPlayerController.asset('assets/videos/startup-video.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    //print("Get.find<AuthService>().currentUser.value.accessToken${Get.find<UserService>().currentUser.value.accessToken}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
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
                  VideoPlayer(_controller),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          width: Get.width,
          height: Get.height * 0.5,
          child: Container(
            height: Get.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.black, Colors.transparent],
              stops: [0.2, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: Get.width,
            height: Get.height,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: Get.height * 0.3,
                  // ),
                  /*Image.asset(
                    "assets/images/logo.png",
                    width: 250,
                  )*/
                  // Text(
                  //   'Welcome to',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: 25,
                  //     color: Colors.white,
                  //     height: 1,
                  //     letterSpacing: -1,
                  //     shadows: [
                  //       Shadow(
                  //           offset: const Offset(1, 1),
                  //           color: Colors.white.withValues(alpha: 0.6),
                  //           blurRadius: 4),
                  //     ],
                  //   ),
                  // )
                  //     .animate()
                  //     .shimmer(
                  //         duration: (1200 / 3).ms, color: glLightThemeColor)
                  //     .fadeIn(
                  //       duration: (1200 / 3).ms,
                  //       curve: Curves.easeOutQuad,
                  //     )
                  //     .slideY(),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        "assets/images/clean_logo.png",
                        width: 200,
                        height: 100,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                    width: Get.width,
                  ),
                  (!authController.isInAuthenticationProcess.value)
                      ? OutlinedBorderWithBorderRadius(
                          onPressed: () {
                            authController.registerProcessPageIndex.value = 0;
                            sc.timeDilation = 2.0;
                            Get.offNamed(Routes.login);
                          },
                          borderColor: glLightPrimaryColor,
                          borderRadius: 20,
                          borderWidth: 1,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                  color: Colors.white,
                                  height: 1,
                                  letterSpacing: -1,
                                  shadows: [
                                    Shadow(
                                        offset: const Offset(1, 1),
                                        color:
                                            Colors.white.withValues(alpha: 0.6),
                                        blurRadius: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: glLightPrimaryColor,
                                size: 25,
                                shadows: [
                                  Shadow(
                                      offset: const Offset(1, 1),
                                      color:
                                          Colors.white.withValues(alpha: 0.6),
                                      blurRadius: 4),
                                ],
                              ),
                            ],
                          ),
                        )
                          .animate()
                          .shimmer(
                              duration: (3200 / 3).ms, color: glLightThemeColor)
                          .fadeIn(
                            duration: (1200 / 3).ms,
                            curve: Curves.easeOutQuad,
                            delay: (200 / 3).ms,
                          )
                          .slideX()
                          .then()
                          .tint(color: glLightThemeColor)
                          .then()
                          .tint(color: glLightPrimaryColor)
                      : LoadingWidget(
                          backgroundColor: Colors.transparent,
                          message: "Loading Please Wait",
                          contentColor: Colors.white,
                        )
                  // .blurXY(delay:( 4400/3).ms, begin: 100, end: 0),
                  /*StylishButton(
                    padding: 20,
                    onPressed: () {},
                    text: "Get Started",
                    backgroundColor: glLightThemeColor,
                  )
                      .animate()
                      .shimmer(duration:( 3200/3).ms, color: glLightThemeColor)
                      .fadeIn(duration:( 1200/3).ms, curve: Curves.easeOutQuad, delay:( 200/3).ms,)
                      .slideX()

                      // .blurXY(delay:( 4400/3).ms, begin: 100, end: 0)
                      .pOnly(left: 10, right: 10)*/
                  /*CustomFormField(
                    textFieldHintText: "Enter your Email Address".tr,
                  ).animate().fadeIn(duration:( 1200/3).ms, curve: Curves.easeOutQuad, delay:( 200/3).ms,).slideX().pOnly(left: 10, right: 10),*/
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
