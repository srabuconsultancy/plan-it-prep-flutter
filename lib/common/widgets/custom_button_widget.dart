import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    this.title,
    this.child,
    required this.onTap,
    this.border = 0,
    this.width = 100,
    this.height = 50,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.borderRadius = 5,
    this.padding,
    this.margin,
    this.borderColor = const Color(0xff000000),
    this.bgColor = const Color(0xff000000),
    this.textColor = const Color(0xffffffff),
  });

  final String? title;
  final Widget? child;
  final Function()? onTap;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final double border;
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap!,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title != null && title!.isNotEmpty
                ? title!.text
                    .textStyle(
                      Get.textTheme.bodySmall!.copyWith(color: textColor, fontSize: fontSize, fontWeight: fontWeight),
                    )
                    .center
                    .make()
                    .pSymmetric(h: 18, v: 15)
                : child!,
          ],
        ),
      ),
    ).objectCenter();
  }
}

class StylishButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double padding;
  final double margin;

  const StylishButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.padding = 16.0,
    this.margin = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: padding),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OutlinedBorderWithBorderRadius extends StatelessWidget {
  const OutlinedBorderWithBorderRadius({
    super.key,
    required this.child,
    required this.onPressed,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderRadius = 5.0,
    this.padding,
    this.margin,
  });

  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}

enum RoundButtonType { bgGradient, bgSGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;

  const RoundButton({super.key, required this.title, this.type = RoundButtonType.bgGradient, this.fontSize = 16, this.elevation = 1, this.fontWeight = FontWeight.w700, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: type == RoundButtonType.bgSGradient ? TColor.secondaryG : primaryG,
            colors: glPrimaryGradient,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? const [BoxShadow(color: Colors.black26, blurRadius: 0.5, offset: Offset(0, 0.5))] : null),
      child: MaterialButton(
        onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: glLightPrimaryColor,
        minWidth: double.maxFinite,
        elevation: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? 0 : elevation,
        color: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient ? Colors.transparent : glLightPrimaryColor,
        child: type == RoundButtonType.bgGradient || type == RoundButtonType.bgSGradient
            ? Text(title, style: TextStyle(color: glLightPrimaryColor, fontSize: fontSize, fontWeight: fontWeight))
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(colors: glPrimaryGradient, begin: Alignment.centerLeft, end: Alignment.centerRight).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                },
                child: Text(title, style: TextStyle(color: glLightPrimaryColor, fontSize: fontSize, fontWeight: fontWeight)),
              ),
      ),
    );
  }
}
