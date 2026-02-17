import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    super.key,
    this.child = const SizedBox(),
    this.size = 25,
    this.bgColor = const Color(0xffcecece),
    this.shadowColor,
  });

  final Widget child;
  final double size;
  final Color bgColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // Makes it circular
      ),
      elevation: shadowColor == null ? 0 : 4,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            100,
          ),
        ),
        child: Container(
          height: size,
          width: size,
          color: bgColor,
          child: child,
        ),
      ),
    );
  }
}
