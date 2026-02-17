import 'dart:io';

import 'package:get/get.dart';

import '../core.dart';

class RootService extends GetxService {
  static RootService get to => Get.find();
  var isInternetWorking = true.obs;
  var firstTimeLoad = true.obs;
  var config = AppConfig().obs;
  var uploadProgress = 0.0.obs;
  var isOnHomePage = true.obs;
  // var checkIfTesting = false;
  bool _calculateIsNotRestrictedTesting() {
    if (config.value.countries.isEmpty) {
      // Handle case where config isn't loaded yet.
      // Decide a safe default. Maybe assume not testing?

      return false;
    }
    bool isTestingRestricted = (config.value.testingAndroid && Platform.isAndroid) || (config.value.testingIos && Platform.isIOS);
    return !isTestingRestricted; // True if NOT restricted testing
  }

  // --- NEW: Central getter for feature accessibility ---
  bool get isFeatureAccessible {
    // Get the current values safely
    final bool isNotRestricted = _calculateIsNotRestrictedTesting();
    final bool freeMembershipEnabled = config.value.enableFreeMemberShip;

    // Feature is accessible if NOT in restricted testing OR free membership is ON
    return isNotRestricted || freeMembershipEnabled;
  }
}
