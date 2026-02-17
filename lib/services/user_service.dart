import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../core.dart';

class UserService extends GetxService {
  static UserService get to => Get.find();

  /// Mocks a login process
  final isLoggedIn = false.obs;
  bool get isLoggedInValue => isLoggedIn.value;
  var currentUser = User().obs;
  var errorString = "".obs;
  // PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      "https://www.googleapis.com/auth/userinfo.profile",
    ],
  );
  var socialUserProfile = User().obs;

  var resetPasswordEmail = "".obs;

  var notificationsCount = 0.obs;

  var myPaymentTransactions = <UserPayment>[].obs;
  var myProgressImages = <ProgressImage>[].obs;
  var myMemberships = <UserMembership>[].obs;
  var notifications = <NotificationModel>[].obs;

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
