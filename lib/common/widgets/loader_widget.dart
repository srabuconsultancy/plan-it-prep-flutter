import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? contentColor;

  const LoadingWidget({
    super.key,
    this.message,
    this.backgroundColor = Colors.white,
    this.contentColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: contentColor),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: TextStyle(fontSize: 16, color: contentColor),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
