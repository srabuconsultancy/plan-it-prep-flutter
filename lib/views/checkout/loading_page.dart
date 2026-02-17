import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // List of status messages to update
  final List<String> statusMessages = [
    'We are gathering your diet plan inputs...',
    'Processing your age and height details...',
    'Analyzing your diet preferences...',
    'Checking for allergies and health conditions...',
    'Almost there, just one more step...',
    'Generating your personalized diet plan...'
  ];
  double progressValue = 0.0;
  // Current status index
  int currentStatusIndex = 0;

  // Timer to update the status message every 1-20 seconds
  late Timer _timer;
  late Timer _progressTimer;

  // Timer for auto-completion after 1-2 minutes
  // late Timer _autoCompleteTimer;
  final int loadingDurationInSeconds = 90;

  @override
  void initState() {
    super.initState();

    // Update status every random time between 1 to 20 seconds
    _timer = Timer.periodic(Duration(seconds: _getRandomTime()), _updateStatus);

    // Automatically complete the loading after 1-2 minutes (e.g., 90 seconds)
    _progressTimer = Timer.periodic(const Duration(seconds: 1), _updateProgress);
  }

  // Get random time between 1 and 20 seconds
  int _getRandomTime() {
    return (1 + (20 - 1) * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt();
  }

// Update the progress value every second
  void _updateProgress(Timer timer) {
    setState(() {
      if (progressValue < 1.0) {
        progressValue += 1 / loadingDurationInSeconds; // Increment progress by 1/90 each second
      } else {
        progressValue = 1.0;
      }
    });

    // If progress reaches 100%, stop the progress timer and complete loading
    if (progressValue == 1.0) {
      _completeLoading();
    }
  }

  // Update the status message
  void _updateStatus(Timer timer) {
    setState(() {
      currentStatusIndex = (currentStatusIndex + 1) % statusMessages.length;
    });
  }

  // Complete the loading process after 90 seconds (1.5 minutes)
  Future<void> _completeLoading() async {
    setState(() {
      currentStatusIndex = statusMessages.length - 1; // Set the last message as final status
    });
    // Optionally navigate to the next screen, e.g., Diet Plan Screen
    DashboardController dashboardController = Get.find();
    await dashboardController.getData();
    UserService.to.currentUser.value.membershipStartDate = DateTime.now();
    UserService.to.currentUser.value.membershipEndDate = DateTime.now().add(const Duration(days: 30));

    Get.offNamed(Routes.dashboard);
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading...')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular progress indicator
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: Get.width / 2.2,
                    height: Get.width / 2,
                    child: FittedBox(child: statusMessages[currentStatusIndex].text.textStyle(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)).center.make()),
                  ),
                  SizedBox(
                    width: Get.width / 2,
                    height: Get.width / 2,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      value: progressValue,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(glLightThemeColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dynamic status text

            const SizedBox(height: 20),
            // A placeholder to indicate loading time
            'Please wait while we generate your diet plan...'.text.center.textStyle(const TextStyle(fontSize: 16, color: Colors.grey)).make().p(20).centered(),
          ],
        ),
      ),
    );
  }
}
