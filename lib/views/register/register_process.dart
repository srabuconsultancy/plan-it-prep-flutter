import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class Register extends StatelessWidget {
  const Register({super.key});
  @override
  Widget build(BuildContext context) {
    UserController authController = Get.find();
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: null,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: authController.completeProfileFormKey,
                child: Obx(
                  () => PageTransitionSwitcher(
                    reverse: authController.animateToNextPage.value,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                    child: authController.registerProcessPages[authController.registerProcessPageIndex.value],
                  ),
                ),
              ),
            ),
            /*if (authController.registerProcessPageIndex.value > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: authController.onPreviousButtonPressed,
                      child: const Text('BACK'),
                    ),
                    ElevatedButton(
                      onPressed: authController.onNextButtonPressed,
                      child: const Text('NEXT'),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 2.0),
            ]*/
          ],
        ),
      ),
    );
  }
}
