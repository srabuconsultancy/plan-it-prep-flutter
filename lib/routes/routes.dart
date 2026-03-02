import 'package:get/get.dart';
import 'package:nutri_ai/views/dashboard/surPriseMeal2.dart';
import 'package:nutri_ai/views/dashboard/surpriseMeal.dart';
import 'package:nutri_ai/views/meal/favouriteMeal.dart';
import 'package:nutri_ai/views/payment/stripePayment.dart';
import 'package:nutri_ai/views/payment/payment_details_page.dart';
import 'package:nutri_ai/views/payment/payment_history_page.dart';

import '../core.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.register;

  static final routes = [
    GetPage(
      name: Routes.getStarted,
      page: () => const GetStarted(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.verifyOtp,
      page: () => const VerifyOTP(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.register,
      page: () => Register(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.packages,
      page: () => const RegisterDietPackages(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.checkoutPayment,
      page: () => PaymentView(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      participatesInRootNavigator: true,
      preventDuplicates: true,
      name: Routes.dashboard,
      page: () => Dashboard(),
    ),
    GetPage(
      name: Routes.home,
      participatesInRootNavigator: true,
      page: () => Home(),
    ),
    GetPage(
      name: Routes.dailyMeals,
      page: () => DailyMeals(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.myMeals,
      page: () => MyDailyMeals(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.listFood,
      participatesInRootNavigator: true,
      page: () => const FoodList(),
    ),
    GetPage(
      name: Routes.weightTracker,
      participatesInRootNavigator: true,
      page: () => const WeightTracker(),
    ),
    GetPage(
      name: Routes.paymentHistory,
      participatesInRootNavigator: true,
      page: () => PaymentHistory(),
    ),
    GetPage(
      name: Routes.stripePayment,
      page: () => const StripePaymentPage(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.stripePaymentHistory,
      page: () => SubscriptionHistoryPage(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.stripePaymentDetails,
      page: () => SubscriptionDetailsPage(),
      participatesInRootNavigator: true,
    ),
    GetPage(
      name: Routes.membershipList,
      participatesInRootNavigator: true,
      page: () => MembershipsList(),
    ),
    GetPage(
      name: Routes.editProfile,
      participatesInRootNavigator: true,
      showCupertinoParallax: true,
      page: () => const EditProfile(),
    ),
    GetPage(
      name: Routes.progressImages,
      participatesInRootNavigator: true,
      page: () => ProgressImages(),
    ),
    GetPage(
      name: Routes.loadingPage,
      participatesInRootNavigator: true,
      page: () => const LoadingPage(),
    ),
    GetPage(
      name: Routes.notifications,
      participatesInRootNavigator: true,
      page: () => const NotificationsView(),
    ),
    GetPage(
      name: Routes.surpriseMeal,
      participatesInRootNavigator: true,
      page: () => const SurpriseMeal(),
      // Optional: Add a transition
    ),
    GetPage(
      name: Routes.favouriteMealPage,
      page: () => FavouriteMealPage(),
      participatesInRootNavigator: true,
    ),
  ];
}

// ignore_for_file: non_constant_identifier_names

// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  static const getStarted = _Paths.getStarted;
  static const login = _Paths.login;
  static const verifyOtp = _Paths.verifyOtp;
  static const register = _Paths.register;
  static const packages = _Paths.packages;

  // static const root = _Paths.root;
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const dailyMeals = _Paths.dailyMeals;
  static const myMeals = _Paths.myMeals;
  static const listFood = _Paths.listFood;
  static const weightTracker = _Paths.weightTracker;
  static const profile = _Paths.profile;
  static const settings = _Paths.settings;
  static const checkoutPayment = _Paths.checkoutPayment;
  static const paymentHistory = _Paths.paymentHistory;
  static const membershipList = _Paths.packagesList;
  static const progressImages = _Paths.progressImages;
  static const loadingPage = _Paths.loadingPage;
  static const editProfile = _Paths.editProfile;
  static const notifications = _Paths.notifications;
  static const recipeDetail = _Paths.recipeDetail;
  static const surpriseMeal = _Paths.surpriseMeal;
  static const stripePayment = _Paths.stripePayment;
  static const stripePaymentHistory = _Paths.stripePaymentHistory;
  static const stripePaymentDetails = _Paths.stripePaymentDetails;
  static const favouriteMealPage = _Paths.favouriteMealPage;

  Routes._();
}

abstract class _Paths {
  static const getStarted = '/';
  static const login = '/login';
  static const register = '/register';
  static const packages = '/packages';
  static const dashboard = '/dashboard';
  static const home = '/home';

  static const profile = '/profile';
  static const settings = '/settings';

  static const verifyOtp = '/verify-otp';
  static const dailyMeals = '/daily-meals';
  static const myMeals = '/my-meals';
  static const listFood = '/food-list';
  static const weightTracker = '/weight-tracker';
  static const paymentHistory = '/payments-history';
  static const packagesList = '/packages-list';
  static const progressImages = '/progress-images';
  static const checkoutPayment = '/checkout';
  static const loadingPage = '/loading-page';
  static const editProfile = '/edit-profile';
  static const notifications = '/notifications';
  static const recipeDetail = '/recipeDetail';
  static const surpriseMeal = '/surprise-meal';
  static const stripePayment = '/payment';
  static const stripePaymentHistory = '/stripePaymentHistory';
  static const stripePaymentDetails = '/stripePaymentDetails';
  static const favouriteMealPage = '/favouriteMealPage';
}
