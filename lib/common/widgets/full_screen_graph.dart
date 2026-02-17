import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenGraphPage extends StatelessWidget {
  const FullScreenGraphPage({super.key, required this.chart});

  final Widget chart;
  @override
  Widget build(BuildContext context) {
    // Set the orientation to landscape
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Reset to default orientation on back
          await SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        right: true,
        left: true,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: chart,
          ),
        ),
      ),
    );
  }
}
