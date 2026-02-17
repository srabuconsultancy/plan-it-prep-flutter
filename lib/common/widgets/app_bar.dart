import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.onTap,
    this.title = '',
    this.height = 50,
    this.actions = const [],
  });

  final VoidCallback? onTap;
  final String title;
  final double height;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
              height: height, child: SafeArea(child: title.text.uppercase.center.textStyle(Get.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 13)).make().centered())),
          Positioned(
            height: height,
            width: 50,
            left: 0,
            child: SafeArea(child: BackArrowButton(onTap: onTap)),
          ),
          Positioned(
            height: height,
            width: 100,
            right: 0,
            child: SafeArea(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: actions,
            )),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
