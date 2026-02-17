import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core.dart';

class DashboardService extends GetxService {
  static DashboardService get to => Get.find();
  var currentPage = 0.obs;
  // var today = DateTime.now();
  var pageController = PageController(keepPage: true).obs;
  var data = DashboardData().obs;
  var weightTrackingData = <WeightTracking>[].obs;
  var graphMacrosConsumed = <Macros>[].obs;
  // var graphMacrosStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30,),),).obs;
  var graphMacrosStartDate = "".obs;
  var graphMacrosEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  var isOnDashboard = false.obs;
}
