import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core.dart';

class RootView extends GetView {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetRouterOutlet(
        initialRoute: Routes.home,
        anchorRoute: '/',
      ),
    );
  }
}
