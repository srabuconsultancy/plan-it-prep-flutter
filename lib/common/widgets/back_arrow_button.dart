import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core.dart';

class BackArrowButton extends StatelessWidget {
  const BackArrowButton({
    super.key,
    this.onTap,
    this.size = 20.0,
  });

  final VoidCallback? onTap;
  final double size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        color: glDarkPrimaryColor,
        size: 20,
      ),
    );
  }
}
