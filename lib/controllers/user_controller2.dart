import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import "package:date_picker_plus/date_picker_plus.dart";
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as h_t_t_p;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path/path.dart' as path; // Import path package
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core.dart';

class UserController extends GetxController {
  UserService userService = Get.find();
  RootService rootService = Get.find();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> completeProfileFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> resetForgotPassword = GlobalKey(debugLabel: "resetForgotPassword");
  User completeProfile = User();
  var hidePassword = true.obs;
  var keyboardVisible = false.obs;
  ValueNotifier<bool> updateViewState = ValueNotifier(false);
  var userIdValue = 0.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> otpFormKey = GlobalKey();
  var showBannerAd = false.obs;
  Map userProfile = {};
  OverlayEntry loader = OverlayEntry(builder: (context) {
    return Container();
  });
  String timezone = 'Unknown';
  bool showUserLoader = false;
  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();
  int page = 1;
  int likedPage = 1;
  var showUploadProgressImageBackIcon = true.obs;
  var followUserId = 0.obs;
  String searchKeyword = '';
  bool showLoadMoreUsers = true;
  String largeProfilePic = '';
  String smallProfilePic = '';

  int curIndex = 0;
  String otp = "";
  var showLoader = false.obs;
  var videosLoader = false.obs;
  bool showLoadMore = true;
  var searchController = TextEditingController();
  bool followUnfollowLoader = false;
  String followText = "Follow";
  var countTimer = 60.obs;
  var bHideTimer = false.obs;
  var reload = false.obs;
  String iosUuId = "";
  String iosEmail = "";
  var fullName = "".obs;
  String username = "";
  var email = "".obs;
  String password = "";
  String confirmPassword = "";
  var fullNameController = TextEditingController().obs;
  TextEditingController emailController = TextEditingController();
  var phoneNoController = TextEditingController().obs;
  // var emailController = TextEditingController().obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController profileUsernameController = TextEditingController();
  var profileEmailController = TextEditingController().obs;
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController conDob = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String uniqueId = "";

  var showSendOtp = false.obs;
  ScrollController scrollController = ScrollController();
  String profileUsername = '';
  DateTime profileDOB = DateTime.now();
  String profileDOBString = '';

  var selectedDp = File("").obs;
  String loginType = '';
  var gender = <Gender>[Gender('M', 'Male'.tr), Gender('F', 'Female'.tr), Gender('O', 'Other'.tr)].obs;
  var selectedGender = Gender('M', 'Male'.tr).obs;
  var goals = <String>[].obs;
  var selectedGoal = Goal().obs;
  var medConditions = <String>[].obs;
  var foodPrefrences = <String>[].obs;

  var selectedDietPreference = DietPreference().obs;
  var fitnessLevels = <String>[].obs;
  var selectedFitnessLevel = FitnessLevel().obs;
  var exercisePlans = <String>[/*"1-2 days", "3-4 days", "5-6 days", "Everyday"*/].obs;
  var selectedExercisePlan = ExercisePlanDays().obs;
  bool visibleSocialButtons = true;
  GlobalKey<ScaffoldState> myProfileScaffoldKey = GlobalKey<ScaffoldState>();

  String deleteProfileOtp = "";
  var isValidEmail = false.obs;
  bool noLiveUserRecord = true;
  bool stillFetchingUserProfile = false;
  final ImagePicker picker = ImagePicker();
  final otpPinController = TextEditingController();
  final otpPinFocusNode = FocusNode();

  var isAnimationLoaded = false.obs;
  List<Widget> registerProcessPages = [];
  var toBeUploadedMedicalTests = <MedicalTest>[].obs;

  var registerProcessPageIndex = 0.obs;

  var selectedAge = 20.obs;
  var weightInLbs = false.obs;
  var selectedWeightInKGS = 60.0.obs;
  var selectedGoalWeightInKGS = 70.0.obs;

  var selectedWeightInLbs = 132.0.obs;
  var selectedGoalWeightInLbs = 154.0.obs;

  var heightInCms = false.obs;

  var selectedHeightInFeet = 5.obs;
  var selectedHeightInInches = 1.obs;
  var selectedHeightInCms = 155.0.obs;

  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  var selectedMedicalIssues = <MedicalIssue>[].obs;

  var isExpand = false.obs;

  var phoneNumber = "".obs;

  final SmsAutoFill autoFillSMS = SmsAutoFill();

  var selectedAllergies = <Allergen>[].obs;
  var selectedCountry = Country().obs;
  var selectedState = StateLocation().obs;
  var selectedCity = City().obs;
  var animateToNextPage = true.obs;

  var selectedDietRegimes = <DietRegime>[].obs;

  GlobalKey<FormFieldState> testNameKey = GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> testDateKey = GlobalKey<FormFieldState>();
  TextEditingController testNameController = TextEditingController();
  var testDateController = TextEditingController().obs;
  final _selectedTestDate = Rxn<DateTime>();
  String _selectedTestDateString = "";
  String _selectedTestName = "";
  var testFileValidationError = "".obs;
  // static AuthController get to => Get.find();
  var medicalTests = <MedicalTest>[].obs;
  var addTestsWidget = <Widget>[].obs;
  Widget? addTestWidget;

  ScrollController medicalTestScrollController = ScrollController();
  PlatformFile? testFile;

  GlobalKey<FormState> testFormKey = GlobalKey<FormState>();
  int currentOpenTestIndex = 0;
  var currentOpenIndexTestFileName = "".obs;
  var profileImage = File("").obs;
  DateTime today = DateTime.now();
  var progressImage = File("").obs;
  final GlobalKey<FormFieldState> emailFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> phoneFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> nameFieldKey = GlobalKey<FormFieldState>();
  var isCheckedDataDeleted = false.obs;
  var isCheckedPermanent = false.obs;
  var isCheckedConfirm = false.obs;
  var isButtonEnabled = false.obs;
  var timerText = 'Delete Profile in 10s'.obs; // For timer display
  int countdownTime = 10; // Countdown starting time

  var inRegisterProcess = false.obs;
  var isInAuthenticationProcess = false.obs;
  @override
  void onInit() {
    scrollController = ScrollController();
    // initPlatformState();
    registerProcessPages = [
      // const GetStarted(),
      RegisterName(),
      RegisterSex(),
      RegisterAge(),
      RegisterWeight(),
      RegisterHeight(),
      // RegisterLocation(),
      RegisterGoal(),
      // RegisterMedicalIssues(),
      RegisterAllergies(),
      RegisterDietPreferences(),
      RegisterFitnessLevel(),
      // RegisterExercisePlan(),
      // RegisterDietRegimes(),
      // RegisterMedicalTest(),
      // RegisterWorkoutPreferences(),
      // RegisterCreatingPlan(), commented for now
    ];

    addTestWidget = AddTest(
      key: const GlobalObjectKey('widget_0'),
      onTap: () {
        openTestPopup(index: 0);
      },
      onRemoveIconTap: () {
        removeTestDetails(index: 0);
      },
    )
        .animate()
        .shimmer(
          duration: (1200 / 3).ms,
          color: glLightThemeColor,
          delay: (200.ms),
        )
        .fadeIn(
          duration: (1200 / 3).ms,
          curve: Curves.easeOutQuad,
          delay: (200.ms),
        )
        .slideY();
    addTestsWidget.add(addTestWidget!);
    super.onInit();
  }

  String validDob(String year, String month, String day) {
    if (day.length == 1) {
      day = "0$day";
    }
    if (month.length == 1) {
      month = "0$month";
    }
    return "$year-$month-$day";
  }

/*  Future<void> initPlatformState() async {
    String timezone;
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timezone = 'Failed to get the timezone.';
    }
    timezone = timezone;
  }*/

  getUuId() async {
    iosUuId = GetStorage().read("ios_uuid") == null ? "" : GetStorage().read("ios_uuid").toString();
    iosEmail = GetStorage().read("ios_email") == null ? "" : GetStorage().read("ios_email").toString();
    //print("iosUuId $iosUuId");
    //print("iosEmail $iosEmail");
  }

  socialLogin(loginData, type) async {
    // var profile = LoginRequestModel().toSocialLoginMap(userProfile, timezone, type);
    if (type == "FB" && loginData["email"] == "") {
      userService.errorString.value = "Your facebook profile does not provide email address. Please try with another method";
      userService.errorString.refresh();
      return false;
    }
    var response = await Helper.sendRequestToServer(endPoint: 'social-login', requestData: loginData, method: "post");

    if (response.statusCode == 200) {
      //print(response.body);
      var chk = await setCurrentUser(response.body);
      if (chk == "success") {
        userService.currentUser.value = User.fromJSON(json.decode(response.body)['data']);
        userService.currentUser.refresh();

        return true;
      } else if (chk == "no-membership") {
        if (RootService.to.isFeatureAccessible) {
          Helper.showToast(msg: "You must purchase a package to generate a daily diet chart"); //Helper.showToast(msg: "To continue you must first purchase a package");
          userService.currentUser.value = User.fromJSON(json.decode(response.body)['content']);
          userService.currentUser.refresh();
          PackageController packageController = Get.find();
          await packageController.getPackagesAnFeatures();
          Get.offNamed(Routes.packages);
          return false;
        } else {
          DashboardController dashboardController = Get.find();
          await dashboardController.getData();
          Get.offNamed(Routes.dashboard);
          return true;
        }
      } else {
        Get.offNamed(Routes.login);
        return false;
      }
    } else {
      return false;
      // throw  Exception(response.body);
    }
  }

  signInWithApple() async {
    showLoader.value = true;
    getUuId();
    toastification.show(
      context: Get.context, // optional if you use ToastificationWrapper
      title: Text("${"Please wait".tr}..."),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 4),
    );
    showLoader.refresh();
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          // TODO: Set the `clientId` and `redirectUri` arguments to the values.dart you entered in the Apple Developer portal during the setup
          clientId: 'com.ofgwellness.dietician.dietcian_app',
          redirectUri: Uri.parse(
            'https://smiling-abrupt-screw.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );
      Map<String, String> userInfo = {};
      var email = credential.email;
      if (iosUuId == "") {
        if (Platform.isIOS) {
          String uuid;
          // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          uuid = credential.userIdentifier!; //UUID for iOS
          GetStorage().write("ios_uuid", uuid).whenComplete(() => log("iosUuId written $uuid"));
          GetStorage().write("ios_email", email).whenComplete(() => log("iosEmail written $uuid"));
          //print("uuid $uuid");
          userInfo = {
            'email': email ?? "",
            'login_type': "A",
            'ios_email': email ?? "",
            'ios_uuid': uuid,
          };
        }
      } else {
        userInfo = {
          'email': iosEmail,
          'login_type': "A",
          'ios_email': iosEmail,
          'ios_uuid': iosUuId,
        };
      }
      try {
        var value = await socialLogin(userInfo, 'A');
        if (value) {
          Helper.dismissToast();
          if (userService.currentUser.value.name != "") {
            DashboardController dashboardController = Get.find();
            await dashboardController.getData();
            Get.offNamed(Routes.dashboard);
          } else {
            Get.offNamed(Routes.register);
          }
        } else {
          if (userService.errorString.value != "") {
            toastification.show(
              context: Get.context, // optional if you use ToastificationWrapper
              title: Text("$userService.errorString.value".tr),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 4),
            );
          }
        }
      } catch (e) {
        //print(e.toString());
        Helper.showToast(msg: 'Sign In with Apple failed!', type: "error");
      }

      showLoader.value = false;
      showLoader.refresh();
    } catch (e) {
      showLoader.value = false;
      showLoader.refresh();
      if (e.toString().contains("Unsupported platform")) {
        Helper.showToast(msg: 'Unsupported platform iOS version. Please try some other login method.', type: "error");
      } else {
        Helper.showToast(msg: 'Please try Again with some other method', type: "error");
      }
    }
  }

  /*loginWithFB() async {
    final LoginResult fBResult = await FacebookAuth.instance.login();
    switch (fBResult.status) {
      case LoginStatus.success:
        final AccessToken accessToken = fBResult.accessToken!;
        // OverlayEntry loader =Helper.overlayLoader(Get.context);
        // Overlay.of(Get.context).insert(loader);
        final graphResponse = await HTTP.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,email,first_name,last_name,picture.width(720).height(720),birthday,gender,languages,location{location}&access_token=${accessToken.token}'));
        final profile = jsonDecode(graphResponse.body);
        socialLogin(profile, timezone, 'FB').then((value) async {
          if (value != null) {
            if (value) {
              Helper.dismissToast();

              Get.offNamed('/home');
              dashboardController.getData();
            } else {
              if (authService.errorString.value != "") {
                Helper.dismissToast();
                toastification.show(
                  context: Get.context, // optional if you use ToastificationWrapper
                  title: Text("$authService.errorString.value".tr),
                  type: ToastificationType.info,
                  autoCloseDuration: const Duration(seconds: 4),
                );
              }
            }
          }
        }).catchError((e) {
          //print(e);
          //print(s);
          Helper.showToast(msg: "Facebook login failed!", type: ToastificationType.error);
        });
        break;
      case LoginStatus.cancelled:
        Helper.showToast(msg: "Facebook login Cancelled!");

        break;
      case LoginStatus.failed:
        Fluttertoast.showToast(msg: "Facebook login failed!".tr);

        break;
      case LoginStatus.operationInProgress:
        EasyLoading.show(status: "${"Loading".tr}..${"Please Wait".tr}");
        break;
    }
  }*/

  loginWithGoogle() async {
    try {
      await userService.googleSignIn.signOut();
    } catch (e) {
      //print("$e + $s");
    }

    await userService.googleSignIn.signIn();

    if (userService.googleSignIn.currentUser != null) {
      //print("userService.googleSignIn.currentUser ${userService.googleSignIn.currentUser!.email} ${userService.googleSignIn.currentUser!.displayName}");
      Helper.showToast(msg: "${"Please wait".tr}...");
      String gmail = userService.googleSignIn.currentUser!.email;
      fullNameController.value.text = userService.googleSignIn.currentUser!.displayName!;
      fullNameController.refresh();
      fullName.value = userService.googleSignIn.currentUser!.displayName!;
      fullName.refresh();
      final Map<String, String> userInfo = {
        'email': gmail,
        'login_type': "G",
      };
      try {
        var value = await socialLogin(
          userInfo,
          'G',
        );
        //print("socialLogin $value");
        if (value) {
          Helper.dismissToast();
          if (userService.currentUser.value.name != "") {
            DashboardController dashboardController = Get.find();
            await dashboardController.getData();
            Get.offNamed(Routes.dashboard);
          } else {
            Get.offNamed(Routes.register);
          }
        } else {
          if (userService.errorString.value != "") {
            Helper.showToast(msg: userService.errorString.value, type: "error", durationInSecs: 3);
          }
        }
      } catch (e) {
        //print("error $e, errorStack $s");
        Helper.dismissToast();
        Helper.showToast(msg: 'Sign In with Google failed!', type: "error");
      }
    } else {
      Helper.dismissToast();
    }
  }

  Future getGoogleInfo(googleSignIn) async {
    List name = googleSignIn.currentUser.displayName.split(' ');
    String fname = name[0];
    String lname = "";
    if (name.length > 1) {
      name.removeAt(0);
      lname = name.join(' ');
    }
    final Map<String, String> userInfo = {
      'first_name': fname,
      'last_name': lname,
      'email': googleSignIn.currentUser.email,
      'user_dp': googleSignIn.currentUser.photoUrl != null ? googleSignIn.currentUser.photoUrl.replaceAll('=s96-c', '=s512-c') : "",
      'time_zone': timezone,
      'login_type': "G",
    };
    return userInfo;
  }

  launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '${"Could not launch".tr} $url';
    }
  }

  validateField(String value, String field) {
    Pattern pattern = r'^[0-9A-Za-z.\-_]*$';
    RegExp regex = RegExp(pattern.toString());

    if (value.isEmpty) {
      return "${field.tr} ${'is required!'.tr}";
    } else if (field == "Confirm Password" && value != password) {
      return "${'Confirm Password'.tr} ${'doesn\'t match!'.tr}";
    } else if (field == "Username" && !regex.hasMatch(value)) {
      return "${'Username'.tr} ${'must contain only _ . and alphanumeric'.tr}";
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value!);
    if (value.isEmpty) {
      isValidEmail.value = false;
      return "${'Email'.tr} ${'field is required!'.tr}";
    } else if (!emailValid) {
      isValidEmail.value = false;
      return "${'Email'.tr} ${'field is not valid!'.tr}";
    } else {
      isValidEmail.value = true;
      // isValidEmail.refresh();
      return null;
    }
  }

  // Future<bool> register() async {
  //   if (!inRegisterProcess.value) {
  //     //print("register ${fullName.value}");
  //     if (completeProfileFormKey.currentState!.validate()) {
  //       Helper.showToast(msg: "Please wait.");
  //       inRegisterProcess.value = true;
  //       /*List name = fullName.value.split(' ');
  //     String fName = name[0];
  //     String lName = "";
  //     if (name.length > 1) {
  //       name.removeAt(0);
  //       lName = name.join(' ');
  //     }*/
  //       //print("aaaaaa");
  //       final Map<String, dynamic> userProfile = {
  //         'full_name': fullName.value,
  //         'gender': selectedGender.value.value,
  //         'age': selectedAge.value.toString(),
  //         'height': selectedHeightInCms.toString(),
  //         'weight': selectedWeightInKGS.toString(),
  //         'target_value': selectedGoalWeightInKGS.toString(),
  //         'country_id': selectedCountry.value.id.toString(),
  //         'state_id': selectedState.value.id.toString(),
  //         'city_id': selectedCity.value.id.toString(),
  //         'fitness_level_id': selectedFitnessLevel.value.id.toString(),
  //         'goal_id': selectedGoal.value.id.toString(),
  //         'exercise_plan_day_id': selectedExercisePlan.value.id.toString(),
  //         'medical_issue_ids': selectedMedicalIssues.isNotEmpty ? selectedMedicalIssues.value.map((item) => item.id).join(',') : "",
  //         'allergy_ids': selectedAllergies.isNotEmpty ? selectedAllergies.value.map((item) => item.id).join(',') : "",
  //         'regimes_ids': selectedDietRegimes.isNotEmpty ? selectedDietRegimes.value.map((item) => item.id).join(',') : "",
  //         'user_pref_id': selectedDietPreference.value.id.toString(),
  //       };
  //       if (selectedDp.value.path != "") {
  //         userProfile['profile_pic_file'] = selectedDp.value.path;
  //       } else {
  //         // userProfile['profile_pic'] = completeProfile.userDP;
  //       }
  //       //print("aaaaaa");
  //       UploadFile? profilePicFile;
  //       final List<UploadFile> files = [];
  //       try {
  //         if (userProfile['profile_pic_file'] != null && userProfile['profile_pic_file'] != "") {
  //           profilePicFile =
  //               UploadFile(fileName: userProfile['profile_pic_file']!.split('/').last, filePath: selectedDp.value.path != "" ? selectedDp.value.path : "", variableName: "profile_pic_file");
  //           //print("bbbbbb");
  //           files.add(profilePicFile);
  //           //print("userProfile $userProfile");
  //         }
  //       } catch (e) {
  //         //print("profilePicFile failed $e $s");
  //       }
  //       if (toBeUploadedMedicalTests.isNotEmpty) {
  //         int i = 0;
  //         for (MedicalTest testToUpload in toBeUploadedMedicalTests) {
  //           userProfile["test_name_$i"] = testToUpload.name;
  //           userProfile["test_date_$i"] = testToUpload.date;
  //           UploadFile fileToUpload = UploadFile(fileName: "${testToUpload.name}_${DateTime.now().microsecondsSinceEpoch}", filePath: testToUpload.file, variableName: "test_file_$i");
  //           files.add(fileToUpload);
  //           i++;
  //         }
  //       }
  //       userProfile["number_of_tests"] = toBeUploadedMedicalTests.length;
  //       try {
  //         var apiResponse = await Helper.sendRequestToServer(endPoint: 'update-user-information', requestData: userProfile, files: files, method: "post");
  //         var value;
  //         if (files.isEmpty) {
  //           value = apiResponse.body;
  //         } else {
  //           value = json.encode(apiResponse.data);
  //         }
  //         // //print("response.data ${response.data} $value");
  //         if (value != null) {
  //           var response = json.decode(value);
  //           //print("response['status'] ${response['status']}");
  //           if (!response['status']) {
  //             //print("response $response $response['msg']");
  //             String msg = response['msg'];
  //             showAlertDialog(errorTitle: "Error Registering User".tr, errorString: msg, dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
  //             inRegisterProcess.value = false;
  //             return false;
  //           } else {
  //             if (RootService.to.isFeatureAccessible) {
  //               //print("entered Profile Create successfully ${RootService.to.config.value.testingAndroid} && ${Platform.isAndroid}");
  //               inRegisterProcess.value = false;
  //               Dialogs.materialDialog(
  //                 barrierDismissible: false,
  //                 color: Colors.white,
  //                 title: 'Profile Create successfully',
  //                 msgAlign: TextAlign.center,
  //                 msg: 'Your Profile is submitted successfully. Kindly choose a diet plan.',
  //                 lottieBuilder: Lottie.asset(
  //                   'assets/lottie/preparing.json',
  //                   fit: BoxFit.contain,
  //                 ),
  //                 context: Get.context!,
  //                 // isDismissible: true,
  //                 useRootNavigator: true,
  //                 actions: [
  //                   IconsButton(
  //                     onPressed: () async {
  //                       //Get.back(closeOverlays: true);
  //                       Get.backLegacy(closeOverlays: true);
  //                       PackageController packageController = Get.find();
  //                       await packageController.getPackagesAnFeatures();
  //                       Get.offNamed(Routes.packages);
  //                       // Get.toNamed(Routes.checkoutPayment);
  //                     },
  //                     text: 'Proceed To Choose',
  //                     iconData: Icons.done,
  //                     color: glLightThemeColor,
  //                     textStyle: const TextStyle(color: Colors.white),
  //                     iconColor: Colors.white,
  //                   ),
  //                 ],
  //               );
  //               return true;
  //             } else {
  //               DashboardController dashboardController = Get.find();
  //               await dashboardController.getData();
  //               Get.offNamed(Routes.dashboard);
  //               return true;
  //             }
  //           }
  //         } else {
  //           inRegisterProcess.value = false;
  //           return false;
  //         }
  //         // } on DioException catch (e) {
  //       } catch (e) {
  //         //print("asdfsdfsdfsdfsdf");
  //         inRegisterProcess.value = false;
  //         //print(e);
  //         //print(s);
  //         // //print(e.stackTrace);
  //         return false;
  //       }
  //     } else {
  //       //print("sdadsasdads");
  //       return false;
  //     }
  //   } else {
  //     //print("sdadsasdads");
  //     return false;
  //   }
  // }

  Future<void> register() async {
    if (inRegisterProcess.value) {
      //print("Already in registration process");
      return;
    }

    if (!completeProfileFormKey.currentState!.validate()) {
      //print("Form validation failed");
      return;
    }

    //print("Registering ${fullName.value}");
    Helper.showToast(msg: "Please wait.");
    inRegisterProcess.value = true;

    final Map<String, dynamic> userProfile = {
      'full_name': fullName.value,
      'gender': selectedGender.value.value,
      'age': selectedAge.value.toString(),
      'height': selectedHeightInCms.toString(),
      'weight': selectedWeightInKGS.toString(),
      'target_value': selectedGoalWeightInKGS.toString(),
      'country_id': selectedCountry.value.id.toString(),
      'state_id': selectedState.value.id.toString(),
      'city_id': selectedCity.value.id.toString(),
      'fitness_level_id': selectedFitnessLevel.value.id.toString(),
      'goal_id': selectedGoal.value.id.toString(),
      'exercise_plan_day_id': selectedExercisePlan.value.id.toString(),
      'medical_issue_ids': selectedMedicalIssues.isNotEmpty ? selectedMedicalIssues.value.map((item) => item.id).join(',') : "",
      'allergy_ids': selectedAllergies.isNotEmpty ? selectedAllergies.value.map((item) => item.id).join(',') : "",
      'regimes_ids': selectedDietRegimes.isNotEmpty ? selectedDietRegimes.value.map((item) => item.id).join(',') : "",
      'user_pref_id': selectedDietPreference.value.id.toString(),
    };

    if (selectedDp.value.path.isNotEmpty) {
      userProfile['profile_pic_file'] = selectedDp.value.path;
    }

    UploadFile? profilePicFile;
    final List<UploadFile> files = [];

    try {
      if (userProfile['profile_pic_file'] != null && userProfile['profile_pic_file'] != "") {
        profilePicFile = UploadFile(
          fileName: userProfile['profile_pic_file']!.split('/').last,
          filePath: selectedDp.value.path,
          variableName: "profile_pic_file",
        );
        files.add(profilePicFile);
      }
    } catch (e) {
      //print("Profile pic file error: $e\n$s");
    }

    if (toBeUploadedMedicalTests.isNotEmpty) {
      int i = 0;
      for (MedicalTest testToUpload in toBeUploadedMedicalTests) {
        userProfile["test_name_$i"] = testToUpload.name;
        userProfile["test_date_$i"] = testToUpload.date;
        files.add(
          UploadFile(
            fileName: "${testToUpload.name}_${DateTime.now().microsecondsSinceEpoch}",
            filePath: testToUpload.file,
            variableName: "test_file_$i",
          ),
        );
        i++;
      }
      userProfile["number_of_tests"] = toBeUploadedMedicalTests.length;
    }

    try {
      var apiResponse = await Helper.sendRequestToServer(
        endPoint: 'update-user-information',
        requestData: userProfile,
        files: files,
        method: "post",
      );

      dynamic value = files.isEmpty ? apiResponse.body : json.encode(apiResponse.data);

      if (value == null) {
        //print("API response is null");
        return;
      }

      final response = json.decode(value);
      //print("Server response: $response");

      if (!response['status']) {
        showAlertDialog(
          errorTitle: "Error Registering User".tr,
          errorString: response['msg'],
          dismissOnBackKeyPress: true,
          dismissOnTouchOutside: true,
        );
        return;
      }

      // On successful registration
      if (RootService.to.isFeatureAccessible) {
        Dialogs.materialDialog(
          barrierDismissible: false,
          color: Colors.white,
          title: 'Profile Created Successfully',
          msgAlign: TextAlign.center,
          msg: 'Your Profile is submitted successfully. Kindly choose a diet plan.',
          lottieBuilder: Lottie.asset(
            'assets/lottie/preparing.json',
            fit: BoxFit.contain,
          ),
          context: Get.context!,
          useRootNavigator: true,
          actionsBuilder: (context) => [
            IconsButton(
              onPressed: () async {
                Get.backLegacy(closeOverlays: true);
                final packageController = Get.find<PackageController>();
                await packageController.getPackagesAnFeatures();
                Get.offNamed(Routes.packages);
              },
              text: 'Proceed To Choose',
              iconData: Icons.done,
              color: glLightThemeColor,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      } else {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.getData();
        Get.offNamed(Routes.dashboard);
      }
    } catch (e) {
      //print("Exception during register(): $e\n$s");
    } finally {
      inRegisterProcess.value = false;
    }
  }

  Future<String> authenticate() async {
    // loginFormKey.currentState!.save();
    final Map<String, String> userProfile = {
      'phone': phoneNumber.value,
    };
    Helper.showToast(msg: 'Loading');

    var value = await Helper.sendRequestToServer(endPoint: 'authenticate', requestData: userProfile, method: "post");

    var response = json.decode(value.body);

    if (!response["status"]) {
      showSendOtp.value = true;
      showSendOtp.refresh();
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Otp";
      // } else if (response['msg'] != null) {
    } else {
      Helper.dismissToast();
      Helper.showToast(type: "success", msg: response["msg"], durationInSecs: 2);
      Get.offNamed(Routes.verifyOtp);
      return "Done";
    }
  }

  Future<String> login() async {
    // loginFormKey.currentState!.save();
    final Map<String, String> userProfile = {
      'phone': phoneNumber.value,
      'otp': otp,
    };
    Helper.showToast(msg: 'Loading');

    var value = await Helper.sendRequestToServer(endPoint: 'login', requestData: userProfile, method: "post");

    var response = json.decode(value.body);

    if (response["status"] != true) {
      if (response['status'] == 'email_not_verified') {
        var content = json.decode(json.encode(response['content']));
        await GetStorage().write("otp_user_id", content['user_id'].toString());
        await GetStorage().write("otp_app_token", content['app_token']);
        String msg = response['msg'];
        showSendOtp.value = true;
        showSendOtp.refresh();
        showAlertDialog(errorTitle: 'Error Logging OTP', errorString: msg);
        return "Otp";
      } else if (response['content'] != null) {
        String chk = await setCurrentUser(value.body);
        if (chk == "success") {
          updateFCMTokenForUser();

          userService.currentUser.value = User.fromJSON(response['content']);
          userService.currentUser.refresh();
          Get.offNamed(Routes.dashboard);
          return "Done";
        } else if (chk == "no-membership") {
          userService.currentUser.value = User.fromJSON(response['content']);
          if (RootService.to.isFeatureAccessible) {
            Helper.showToast(msg: "You must purchase a package to generate a daily diet chart"); //Helper.showToast(msg: "To continue you must first purchase a package");
            userService.currentUser.refresh();
            PackageController packageController = Get.find();
            await packageController.getPackagesAnFeatures();
            Get.offNamed(Routes.packages);
            return "Done";
          } else {
            DashboardController dashboardController = Get.find();
            await dashboardController.getData();
            Get.offNamed(Routes.dashboard);
            return "Done";
          }
        } else {
          Get.offNamed(Routes.login);
          return "Done";
        }
        /*if (chk) {
          updateFCMTokenForUser();
          userService.currentUser.value = User.fromJSON(response['content']);
          Get.offNamed(Routes.dashboard);
          return "Done";
        } else {
          return "Error";
        }*/
      } else {
        String msg = response['msg'];
        showAlertDialog(errorTitle: 'Error', errorString: msg);
        return "Error";
      }
    } else {
      return "Error";
    }
  }

  verifyOtp() async {
    Helper.showToast(msg: 'Loading');
    final Map<String, String> data = {
      'phone': phoneNumber.value,
      'otp': otp,
    };
    var value = await Helper.sendRequestToServer(endPoint: "verify-otp", requestData: data, method: "post");
    var response = json.decode(value.body);
    if (!response['status']) {
      String msg = response['msg'];
      Helper.showToast(
        msg: msg,
      );
    } else {
      String chk = await setCurrentUser(value.body);
      if (chk == "success") {
        updateFCMTokenForUser();
        if (userService.currentUser.value.name != "") {
          DashboardController dashboardController = Get.find();
          await dashboardController.getData();
          Get.offNamed(Routes.dashboard);
        } else {
          Get.offNamed(Routes.register);
        }
      } else if (chk == "no-membership") {
        if (userService.currentUser.value.name != "") {
          Helper.showToast(msg: "You must purchase a package to generate a daily diet chart");
          /*//Helper.showToast(msg: "To continue you must first purchase a package");
          // DashboardController dashboardController = Get.find();
          // await dashboardController.getData();
          PackageController packageController = Get.find();
          await packageController.getPackagesAnFeatures();
          Get.offNamed(Routes.packages);*/
        } else {
          Get.offNamed(Routes.register);
        }
      } else {
        Get.offNamed(Routes.login);
        return "Done";
      }
    }
  }

  resendOtp({verifyPage}) async {
    if (verifyPage != null) {
      startTimer();

      bHideTimer.value = true;
      bHideTimer.refresh();
      reload.value = true;
      reload.refresh();
      countTimer.value = 60;
      countTimer.refresh();
    }

    String userId = GetStorage().read("otp_user_id")!;
    String userToken = GetStorage().read("otp_app_token")!;
    showLoader.value = true;
    showLoader.refresh();

    final Map<String, String> data = {
      'user_id': userId,
      'app_token': userToken,
    };
    var resp = await Helper.sendRequestToServer(endPoint: 'resend-otp', requestData: data, method: "post");
    showLoader.value = false;
    showLoader.refresh();
    var response = json.decode(resp.body);
    if (response['status'] != 'success') {
      String msg = response['msg'];
      showSendOtp.value = true;
      showSendOtp.refresh();
      showAlertDialog(errorTitle: 'Error Verifying OTP', errorString: msg);
    } else {
      if (verifyPage == null) {
        Get.toNamed(
          '/verify-otp',
        );
      }
    }
  }

  Future<bool> editProfile() async {
    //print("editProfile");
    if (editProfileFormKey.currentState!.validate()) {
      Helper.showToast(msg: "Please wait.");

      //print("aaaaaa");
      final Map<String, dynamic> userProfile = {
        'full_name': fullName.value,
        'phone': phoneNumber.value.toString(),
        'email': email.value.toString(),
        'age': selectedAge.value.toString(),
        'height': selectedHeightInCms.toString(),
      };
      try {
        var apiResponse = await Helper.sendRequestToServer(endPoint: 'update-profile', requestData: userProfile, method: "post");
        var value = apiResponse.body;

        if (value != null) {
          var response = json.decode(value);
          //print("response['status'] ${response['status']}");
          if (!response['status']) {
            //print("response $response $response['msg']");
            String msg = response['msg'];
            showAlertDialog(errorTitle: "Error Registering User".tr, errorString: msg, dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
            return false;
          } else {
            Dialogs.materialDialog(
              color: Colors.white,
              title: 'Updated profile successfully',
              msgAlign: TextAlign.center,
              lottieBuilder: Lottie.asset(
                'assets/lottie/congratulations.json',
                fit: BoxFit.contain,
              ),
              context: Get.context!,
              // isDismissible: true,
              useRootNavigator: true,
            );
            return true;
          }
        } else {
          return false;
        }
        // } on DioException catch (e) {
      } catch (e) {
        //print("asdfsdfsdfsdfsdf");
        //print(e);
        //print(s);
        // //print(e.stackTrace);
        return false;
      }
    } else {
      //print("sdadsasdads");
      return false;
    }
  }

  showAlertDialog({String errorTitle = '', String errorString = '', bool dismissOnBackKeyPress = false, bool dismissOnTouchOutside = false}) {
    //print("showAlertDialog");
    AwesomeDialog(
      dismissOnBackKeyPress: dismissOnBackKeyPress,
      dismissOnTouchOutside: dismissOnTouchOutside,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          children: [
            errorTitle.text.textStyle(Get.theme.textTheme.headlineMedium).make().pOnly(bottom: 5),
            errorString.text.textStyle(Get.theme.textTheme.titleMedium).make().pOnly(bottom: 10),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                child: "Ok".tr.text.center.make(),
                onPressed: () => Get.backLegacy(closeOverlays: true),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      // setState(() {
      countTimer.value--;
      countTimer.refresh();
      if (countTimer.value == 0) {
        bHideTimer.value = false;
        bHideTimer.refresh();
        reload.value = true;
        reload.refresh();
      }
      if (countTimer.value <= 0) timer.cancel();
      // });
    });
  }

  Future ifEmailExists(String email) async {
    showLoader.value = true;
    showLoader.refresh();
    //print("ifEmailExists $email");
    var response = await Helper.sendRequestToServer(endPoint: "is-email-exist", requestData: {"email": email}, method: "post");
    showLoader.value = false;
    showLoader.refresh();
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == "success") {
        userService.errorString.value = "";
        userService.errorString.refresh();

        if (json.decode(response.body)['isEmailExist'] == 1) {
          AwesomeDialog(
            // dialogBackgroundColor: Get.theme.colorScheme.primary,
            dialogBackgroundColor: Colors.white,
            context: Get.context!,
            animType: AnimType.scale,
            dialogType: DialogType.warning,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Email Already Exists'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: glLightIconColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Use another email to register or login using existing email'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: glLightIconColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(glBorderRadius),
                        color: Get.theme.highlightColor,
                      ),
                      child: "Ok".tr.text.size(18).center.color(glLightIconColor).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  )
                ],
              ),
            ),
          ).show();
        } else {
          loginType = "O";
          Get.toNamed("/complete-profile");
        }
      } else {
        return false;
      }
    } else {
      throw Exception(response.body);
    }
  }

  Future testDietPlanGenerator() async {
    showLoader.value = true;
    showLoader.refresh();
    //print("testDietPlanGenerator ");
    var response = await Helper.sendRequestToServer(endPoint: "test-diet-plan-api", requestData: {"test": "test"}, method: "post");
    showLoader.value = false;
    showLoader.refresh();
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == "success") {
        userService.errorString.value = "";
        userService.errorString.refresh();
      }
    } else {
      return false;
    }
  }

  getImageOption(bool isCamera) async {
    if (isCamera) {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100, // <- Reduce Image quality
        maxHeight: 1000, // <- reduce the image size
        maxWidth: 1000,
      );

      if (pickedFile != null) {
        selectedDp.value = File(pickedFile.path);
      } else {
        //print('No image selected.');
      }
    } else {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      // setState(() {
      if (pickedFile != null) {
        selectedDp.value = File(pickedFile.path);
      } else {
        //print('No image selected.');
      }
      // });
    }
    reload.value = true;
    reload.refresh();
  }

  sendPasswordResetOTP() async {
    Helper.showToast(msg: "${'Loading'.tr}....");

    showLoader.value = true;
    showLoader.refresh();
    formKey.currentState!.save();
    var value = await Helper.sendRequestToServer(endPoint: 'forgot-password', requestData: {'email': email.value}, method: "post");

    showLoader.value = false;
    showLoader.refresh();
    var response = json.decode(value.body);
    if (response['status'] != 'success') {
      AwesomeDialog(
        dialogBackgroundColor: Get.theme.colorScheme.primary,
        context: Get.context!,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Sorry this email account does not exists'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: glLightIconColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(glBorderRadius),
                    color: Get.theme.highlightColor,
                  ),
                  child: "Ok".tr.text.size(18).center.color(glLightIconColor).make().centered().pSymmetric(h: 10, v: 10),
                ),
              )
            ],
          ),
        ),
      ).show();
    } else {
      Helper.showToast(msg: "An OTP is sent to your email please check your email");

      await Future.delayed(
        const Duration(seconds: 2),
      );
      userService.resetPasswordEmail.value = email.value;
      Get.offNamed('/reset-forgot-password');
    }
  }

  updateForgotPassword() async {
    Helper.showToast(msg: "${'Loading'.tr}....");
    showLoader.value = true;
    showLoader.refresh();
    resetForgotPassword.currentState!.save();
    final Map<String, String> data = {
      'email': userService.resetPasswordEmail.value,
      'otp': otp,
      'password': password,
      'confirm_password': confirmPassword,
    };

    var value = await Helper.sendRequestToServer(endPoint: 'update-forgot-password', requestData: data, method: "post");

    showLoader.value = false;
    showLoader.refresh();

    var response = json.decode(value.body);
    if (response['status'] != 'success') {
      AwesomeDialog(
        dialogBackgroundColor: Get.theme.colorScheme.primary,
        context: Get.context!,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    response['msg'].tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: glLightIconColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Get.theme.highlightColor,
                  ),
                  child: "Ok".tr.text.size(18).center.color(glLightIconColor).make().centered().pSymmetric(h: 10, v: 10),
                ),
              )
            ],
          ),
        ),
      ).show();
    } else {
      Helper.showToast(msg: "${'Password'.tr} ${'Updated Successfully'.tr}");

      // FocusScope.of(resetForgotPasswordScaffoldKey.currentContext!).requestFocus(FocusNode());
      await Future.delayed(
        const Duration(seconds: 2),
      );
      Get.offNamed(Routes.login);
    }
  }

  deleteProfile() async {
    try {
      var response = await Helper.sendRequestToServer(endPoint: 'delete-profile', method: "post");
      //print("deleteProfile response ${response.body}");
      if (response.statusCode != 200) {
        var resp = jsonDecode(response.body);
        Helper.showToast(msg: resp["msg"].tr, type: "error");

        return false;
      } else {
        // userService.pusher.disconnect();
        if (userService.currentUser.value.loginType == 'FB') {
          // FacebookAuth.instance.logOut();
        } else if (userService.currentUser.value.loginType == 'G') {
          await userService.googleSignIn.signOut();
        }
        //print("Success response ${response.body}");
        var resp = jsonDecode(response.body);
        if (resp['status']) {
          userService.currentUser.value = User();
          await GetStorage().remove('current_user');
          await GetStorage().remove('EULA_agree');
          userService.currentUser.refresh();
          Get.offNamed(Routes.login);
        } else {
          Helper.showToast(msg: resp["msg"].tr, type: "error");

          return false;
        }
      }
    } catch (e) {
      Helper.showToast(msg: "Error verifying OTP".tr, type: "error");
      //print("files error $e");
      return false;
    }
  }

  /*deleteProfileConfirmation() {
    AwesomeDialog(
      dialogBackgroundColor: Get.theme.primaryColor.withValues(alpha:0.7),
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${'Caution'.tr}!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Profile deletion will permanently delete user's profile and all its data, it can not be recovered in future. For confirmation we'll send an OTP to your registered email Id".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.theme.highlightColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Get.theme.highlightColor,
                        border: Border.all(color: glLightIconColor, width: 0.5),
                      ),
                      child: "No".tr.text.size(18).center.color(Get.theme.primaryColor!).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      try {
                        var response = await Helper.sendRequestToServer(endPoint: 'delete-user-confirmation', method: "post", requestData: {"data_var": "data"});
                        //print("deleteProfileConfirmation response ${response.body}");
                        if (response.statusCode != 200) {
                          // Fluttertoast.showToast(msg: "error_while_action".trParams({"action": "updating".tr, "entity": "profile".tr}), backgroundColor: Get.theme.errorColor);
                        } else {
                          Helper.showToast(msg: "An OTP has been sent to your Mobile or Email".tr);
                          //print("Success response ${response.body}");
                          showDeleteConfirmation();
                        }
                      } catch (e) {
                        //print("files error $e");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: glLightIconColor, width: 0.5),
                        color: Get.theme.colorScheme.primary,
                      ),
                      child: "Send OTP".tr.text.size(18).center.color(Get.theme.primaryColor!).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }

  showDeleteConfirmation() {
    Get.back();
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: const Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 241, 0.37),
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    AwesomeDialog(
      dialogBackgroundColor: Get.theme.primaryColor.withValues(alpha:0.7),
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Verify OTP".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.highlightColor,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Verify OTP and delete profile.\nProfile deletion will permanently delete user's profile and all its data, it can not be recovered in future".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.theme.highlightColor,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Pinput(
              length: 4,
              controller: otpPinController,
              focusNode: otpPinFocusNode,

              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 16),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                      offset: Offset(0, 3),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              // onClipboardFound: (value) {
              //   debugPrint('onClipboardFound: $value');
              //  setText(value);
              // },
              showCursor: true,
              cursor: cursor,

              onCompleted: (v) {
                deleteProfileOtp = v;
              },
              onChanged: (value) {
                deleteProfileOtp = value;
              },
            ),
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Get.theme.highlightColor,
                        border: Border.all(color: glLightIconColor, width: 0.5),
                      ),
                      child: "No".tr.text.size(18).center.color(Get.theme.primaryColor!).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      deleteProfile();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: glLightIconColor, width: 0.5),
                        color: Get.theme.colorScheme.primary,
                      ),
                      child: "Verify and Delete".tr.text.size(18).center.color(Get.theme.primaryColor!).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }*/

  Future<void> updateFCMTokenForUser() async {
    //print("updateFCMTokenForUser");
    try {
      String? value = await FirebaseMessaging.instance.getToken();
      if (value != "") {
        //print("updateFCMTokenForUser $value");
        updateFcmToken(value);
      }
    } catch (e) {
      //print("updateFCMTokenForUser $e $s");
    }
  }

  updateFcmToken(token) async {
    try {
      h_t_t_p.Response response = await Helper.sendRequestToServer(endPoint: 'update-fcm-token', requestData: {"fcm_token": token.toString()}, method: "post");
      if (response.statusCode == 200) {
        UserService authService = Get.find();
        var jsonData = json.decode(response.body);
        //print("updateFcmToken $jsonData");
        authService.notificationsCount.value = jsonData['count'] ?? 0;
        authService.notificationsCount.refresh();
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  getCurrentUser() async {
    //print("getCurrentUser");
    String? prefCurrentUser = GetStorage().read('current_user');
    log("prefCurrentUser");
    log(prefCurrentUser!);
    if ((userService.currentUser.value.accessToken == '') && GetStorage().hasData('current_user')) {
      String? prefCurrentUser = GetStorage().read('current_user');
      //print("prefCurrentUser");
      //print(prefCurrentUser);
      try {
        var decodedUser = json.decode(prefCurrentUser!);
        userService.currentUser.value = LoginResponseModel.fromJSON(decodedUser).data!;
      } catch (e) {
        //print("error user $e");
      }
      //print("currentUser.value.username");
      //print(userService.currentUser.value.username);
      //print(userService.currentUser.value.id);
      //print(userService.currentUser.value.id);
      //print(userService.currentUser.value.accessToken);
    }
    userService.currentUser.refresh();
    /*else {
      currentUser.value.auth = false;
    }*/
    return userService.currentUser.value;
  }

  Future<String> setCurrentUser(responseBody, [bool isEdit = false]) async {
    log("setCurrentUser json.decode(jsonString)['content'] ${json.decode(responseBody)['content']} $responseBody ");
    try {
      var userData = json.decode(responseBody)['data'];
      bool membership = false;
      try {
        membership = json.decode(responseBody)['membership'];
      } catch (e) {
        // membership = json.decode(responseBody)['membership'];
      }

      if (userData != null) {
        User userObject = User.fromJSON(userData);
        if (membership) {
          // DateFormat format = DateFormat("yyyy-MM-dd");
          DateTime memberShipExpiryDate = userObject.membershipEndDate!;
          bool chkMembership = memberShipExpiryDate.isAfter(
            DateTime(
              today.year,
              today.month,
              today.day,
              23,
              59,
              59,
            ),
          );
          if (!chkMembership) {
            Helper.showToast(durationInSecs: 5, type: "error", msg: "Membership Expired");
            return "expired";
          } else {
            await GetStorage().write('current_user', json.encode(userData)).whenComplete(() => log("Current User Storage Written Successfully"));
            userService.currentUser.value = User.fromJSON(userData);
            userService.currentUser.refresh();
            return "success";
          }
        } else {
          await GetStorage().write('current_user', json.encode(userData)).whenComplete(() => log("Current User Storage Written Successfully"));
          userService.currentUser.value = User.fromJSON(userData);
          userService.currentUser.refresh();
          return "success";
          // return "no-membership";
        }
      } else {
        //print("setCurrentUser error");
        return "failed";
      }
    } catch (e) {
      //print("setCurrentUser error: $e");
      //print(s);
      return "failed";
    }
  }

  Future logout() async {
    try {
      // await userService.pusher.disconnect();
    } catch (e) {
      //print("error disconnecting echo $e");
    }
    if (userService.currentUser.value.loginType == 'FB') {
      // FacebookAuth.instance.logOut();
    } else if (userService.currentUser.value.loginType == 'G') {
      await userService.googleSignIn.signOut();
    }
    Helper.getUri('logout');
    //print(uri.toString());
    await GetStorage().remove('current_user');
    await GetStorage().remove('EULA_agree');
    page = 0;
    // activeTab.value = 1;
    RootController rootController = Get.find();
    rootController.getAppConfig();
    userService.currentUser.value = User();
    userService.currentUser.refresh();
    DashboardService dashboardService = Get.find();
    dashboardService.currentPage.value = 0;
    dashboardService.currentPage.refresh();
    dashboardService.pageController.value.animateToPage(dashboardService.currentPage.value, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    dashboardService.pageController.refresh();
    DashboardService.to.isOnDashboard.value = false;
    DashboardService.to.isOnDashboard.refresh();
    registerProcessPageIndex.value = 0;
    registerProcessPageIndex.refresh();
    Get.offNamed(Routes.login);
  }

  Future<void> userUniqueId() async {
    uniqueId = (GetStorage().read('unique_id') == null) ? "" : GetStorage().read('unique_id').toString();
    if (uniqueId == "") {
      try {
        var response = await Helper.sendRequestToServer(endPoint: 'get-unique-id', method: "post", requestData: {"data_var": "data"});
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 'success') {
            await GetStorage().write("unique_id", jsonData['unique_token']);
            uniqueId = jsonData['unique_token'];
          }
        }
      } catch (e) {
        //print(e.toString());
        //print(s.toString());
      }
    }
  }

  Future<void> checkIfAuthenticated() async {
    //print("checkIfAuthenticated1");
    UserService authService = Get.find();
    isInAuthenticationProcess.value = true;
    isInAuthenticationProcess.refresh();
    if (GetStorage().hasData('current_user')) {
      String cu = GetStorage().read('current_user').toString();
      //print("checkIfAuthenticated $cu");
      authService.currentUser.value = User.fromJSON(json.decode(cu));
    }
    if (authService.currentUser.value.accessToken == '') {
      return;
    }
    h_t_t_p.Response response = await Helper.sendRequestToServer(endPoint: "refresh", method: "post", requestData: {"data_var": "data"});
    isInAuthenticationProcess.value = false;
    isInAuthenticationProcess.refresh();
    if (response.statusCode == 200) {
      //print("checkIfAuthenticated refresh Success");
      String chk = await setCurrentUser(response.body);
      //print("checkIfAuthenticated refresh Success $chk");
      if (chk == "success") {
        updateFCMTokenForUser();

        if (userService.currentUser.value.name != "") {
          DashboardController dashboardController = Get.find();
          await dashboardController.getData();
          Get.offNamed(Routes.dashboard);
        } else {
          Get.offNamed(Routes.register);
        }
      } else if (chk == "no-membership") {
        if (userService.currentUser.value.name == "") {
          DashboardController dashboardController = Get.find();
          await dashboardController.getData();
          Get.offNamed(Routes.register);
        } else {
          // if ((RootService.to.config.value.testingAndroid && Platform.isAndroid) || (RootService.to.config.value.testingIos && Platform.isIOS))
          if (RootService.to.isFeatureAccessible) {
            Helper.showToast(msg: "You must purchase a package to generate a daily diet chart"); //Helper.showToast(msg: "To continue you must first purchase a package");
            PackageController packageController = Get.find();
            await packageController.getPackagesAnFeatures();
            Get.offNamed(Routes.packages);
          } else {
            DashboardController dashboardController = Get.find();
            await dashboardController.getData();
            Get.offNamed(Routes.dashboard);
          }
        }
      } else {
        authService.currentUser.value = User();
        await GetStorage().remove("current_user");
        Get.offNamed(Routes.login);
      }
    } else {
      authService.currentUser.value = User();
      await GetStorage().remove("current_user");
    }
  }

  Future<void> getMyPayments() async {
    //print("getMyPayments");
    h_t_t_p.Response response = await Helper.sendRequestToServer(endPoint: "my-payments", method: "get", requestData: {"data_var": "data"});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        userService.myPaymentTransactions.value = Helper.parseItem(jsonData['data'], UserPayment.fromJson);
        userService.myPaymentTransactions.refresh();
      }
    }
  }

  Future<void> getMyProgressImages() async {
    //print("getMyProgressImages");
    h_t_t_p.Response response = await Helper.sendRequestToServer(endPoint: "user-progress-images", method: "get", requestData: {"data_var": "data"});
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        userService.myProgressImages.value = Helper.parseItem(jsonData['data'], ProgressImage.fromJson);
        userService.myProgressImages.refresh();
      }
    }
  }

  Future<void> pickProgressImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera, maxWidth: 800);

    if (pickedImage != null) {
      progressImage.value = File(pickedImage.path);
      progressImage.refresh();
      uploadProgressImage();
    }
  }

  Future<void> uploadProgressImage() async {
    showUploadProgressImageBackIcon.value = false;
    showUploadProgressImageBackIcon.refresh();
    List<UploadFile> files = [];
    String fileName = progressImage.value.path.split('/').last;
    UploadFile profilePicFile = UploadFile(fileName: fileName, filePath: progressImage.value.path != "" ? progressImage.value.path : "", variableName: "image");
    files.add(profilePicFile);
    try {
      EasyLoading.show(status: "Loading");
      var resp = await Helper.sendRequestToServer(endPoint: "upload-image", requestData: {"data": "no_data"}, files: files);
      EasyLoading.dismiss();
      var response = resp.data;
      //print("Images $response");
      if (!response['status']) {
        String msg = response['msg'];
        Helper.showToast(msg: msg, type: "error");
      } else {
        Get.backLegacy(closeOverlays: true);
        Helper.showToast(msg: "Image Uploaded Successfully", type: "info", durationInSecs: 5);
        progressImage.value = File("");
        progressImage.refresh();
        //print("aaaaaa ${response['image']}");
        await getMyProgressImages();
        showUploadProgressImageBackIcon.value = true;
        showUploadProgressImageBackIcon.refresh();
        //print("aaaaaa2");
      }
    } catch (e) {
      //print("$e $s");
      json.encode({'status': 'failed'.tr, 'msg': 'There is some error'.tr});
    }
  }

  logoutConfirmation() {
    AwesomeDialog(
      dialogBackgroundColor: glLightThemeColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Logout".text.center.textStyle(Get.textTheme.headlineMedium!.copyWith(color: glLightPrimaryColor, fontSize: 25)).make().centered().pOnly(bottom: 10),
            "Do you want to logout from your account?"
                .text
                .center
                .textStyle(
                  Get.textTheme.bodySmall!.copyWith(
                    color: glLightPrimaryColor,
                  ),
                )
                .make()
                .centered()
                .pOnly(bottom: 20),
            Row(
              children: [
                /* Expanded(
                  child: CustomButtonWidget(
                    border: 1,

                    title: "No".tr,
                    onTap: () => Get.backLegacy(closeOverlays: true),
                  ),
                ),*/

                Expanded(
                  child: InkWell(
                    onTap: () => Get.backLegacy(closeOverlays: true),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Get.theme.highlightColor,
                      ),
                      child: "No".tr.text.size(18).center.color(glLightIconColor).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      //print("yna");
                      Navigator.pop(Get.context!);
                      // Get.backLegacy(closeOverlays: true);
                      logout();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: glDarkPrimaryColor,
                      ),
                      child: "Yes".tr.text.size(18).center.color(glLightPrimaryColor).make().centered().pSymmetric(h: 10, v: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).show();
  }

  void onNextButtonPressed() {
    if (completeProfileFormKey.currentState != null && completeProfileFormKey.currentState!.validate()) {
      animateToNextPage.value = true;
      animateToNextPage.refresh();
      if (registerProcessPageIndex.value < registerProcessPages.length - 1) {
        registerProcessPageIndex++;
        registerProcessPageIndex.refresh();
      } else {
        register();
        // Get.offNamed(Routes.login);
      }
    }
  }

  void onPreviousButtonPressed() {
    animateToNextPage.value = false;
    animateToNextPage.refresh();
    update();
    if (registerProcessPageIndex > 0) {
      registerProcessPageIndex--;
      registerProcessPageIndex.refresh();
    }
  }

  void convertWeight() {
    //print(1111);
    if (!weightInLbs.value) {
      //print(2222);
      convertLbsToKgs();
    } else {
      //print(3333);
      convertKgsToLbs();
    }
  }

  void convertLbsToKgs() {
    selectedWeightInKGS.value = selectedWeightInLbs.value * 0.45359237;
    selectedWeightInKGS.refresh();
  }

  void convertKgsToLbs() {
    selectedWeightInLbs.value = selectedWeightInKGS.value / 0.45359237;
    selectedWeightInLbs.refresh();
  }

  void convertHeight() {
    //print("convertHeight 111");
    if (heightInCms.value) {
      //print(222);
      convertCmToFeetAndInches(selectedHeightInCms.value.toDouble());
    } else {
      //print(333);
      convertFeetAndInchesToCm(selectedHeightInFeet.value, selectedHeightInInches.value);
    }
    //print("selectedHeightInCms.value ${selectedHeightInCms.value}");
  }

  void convertCmToFeetAndInches(double cm) {
    double inches = cm / 2.54;
    int feet = inches ~/ 12;

    int remainingInches = (inches % 12).round();
    selectedHeightInFeet.value = feet;
    selectedHeightInInches.value = remainingInches;
  }

  void convertFeetAndInchesToCm(int feet, int inches) {
    int totalInches = ((feet * 12) + inches).round();
    double cm = totalInches * 2.54;

    selectedHeightInCms.value = cm.round().toDouble();
  }

  void openTestPopup({required int index}) {
    //print("currentOpenTestIndex $currentOpenTestIndex $index");
    currentOpenTestIndex = index;
    MedicalTest? currentMedicalTest;
    try {
      currentMedicalTest = toBeUploadedMedicalTests.elementAt(index);
    } catch (e) {
      //print("toBeUploadedMedicalTests Index does not exist");
      currentMedicalTest = null;
    }
    if (currentMedicalTest != null) {
      testNameController.text = currentMedicalTest.name;
      testDateController.value.text = currentMedicalTest.date;
      testDateController.refresh();
      currentOpenIndexTestFileName.value = path.basename(currentMedicalTest.file);
      currentOpenIndexTestFileName.refresh();
    }

    AwesomeDialog(
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Form(
          key: testFormKey,
          child: Obx(
            () => Column(
              children: [
                "Upload Test".text.textStyle(Get.theme.textTheme.headlineMedium).make().pOnly(bottom: 5),
                /*CustomFormField(
                  textFieldBgColor: Colors.white,
                  textFieldShadowColor: Colors.transparent,
                  textFieldHeight: 50,
                  textFieldKey: testNameKey,
                  textFieldController: testNameController,
                  textFieldLabelText: "Test Name",
                  textFieldHintText: "",
                  textFieldOnChanged: (value) {
                    _selectedTestName = value!;
                  },
                  textFieldValidator: (v) {
                    if (v == null || v == "") {
                      return "Test Name is required";
                    }
                  },
                ),*/
                DropdownSearch<MedicalTest>(
                  items: (f, cs) => rootService.config.value.tests,
                  filterFn: (medicalT, filter) {
                    // Customize your filter logic here
                    // For instance, this example matches items that start with the filter string
                    return medicalT.name.toLowerCase().startsWith(filter.toLowerCase());
                  },
                  itemAsString: (MedicalTest u) => u.name, // how to display the object

                  compareFn: (a, b) {
                    // Customize your comparison logic here
                    return a.id == b.id; // for example, compare based on an ID field
                  },
                  onChanged: (value) {
                    _selectedTestName = value!.name;
                  },
                  popupProps: PopupProps.menu(
                    menuProps: const MenuProps(align: MenuAlign.bottomCenter),
                    fit: FlexFit.loose,
                    itemBuilder: (context, item, isDisabled, isSelected) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.name, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  decoratorProps: DropDownDecoratorProps(
                    baseStyle: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      labelText: "Select a Test".tr,
                      labelStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(glBorderRadius),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(glBorderRadius),
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.name == "") {
                      return "Test is required".tr;
                    }
                    return null;
                  },
                ).paddingAll(10),
                CustomFormField(
                  textFieldReadOnly: true,
                  textFieldBgColor: Colors.white,
                  textFieldShadowColor: Colors.transparent,
                  textFieldHeight: 50,
                  textFieldFontSize: 14,
                  textFieldKey: testDateKey,
                  textFieldController: testDateController.value,
                  textFieldStyle: const TextStyle(fontSize: 14),
                  textFieldOnTap: () async {
                    DateTime? date = await showDatePickerDialog(
                      maxDate: DateTime.now(),
                      minDate: DateTime.now().subtract(VxIntExtension(60).days),
                      context: Get.context!,
                    );
                    //print("CustomFormField Date $date");
                    _selectedTestDate.value = date;
                    _selectedTestDate.refresh();
                    _selectedTestDateString = _selectedTestDate.value != null ? "${_selectedTestDate.value!.year}-${_selectedTestDate.value!.month}-${_selectedTestDate.value!.day}" : '';
                    testDateController.value.text = _selectedTestDateString;
                    testDateController.refresh();
                                    },
                  textFieldLabelText: 'Test Date',
                  textFieldHintText: 'Test Date',
                  textFieldSuffixIconWidget: Icon(
                    Icons.calendar_today,
                    color: glLightThemeColor,
                  ),
                  textFieldValidator: (v) {
                    if (v == null || v == "") {
                      return "Test Date is required";
                    }
                    return null;
                  },
                ),
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload File'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.blue, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (currentOpenIndexTestFileName.value != "") currentOpenIndexTestFileName.value.text.red900.make().centered(),
                if (testFileValidationError.value != "") testFileValidationError.value.text.red900.make().centered(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        ),
                        child: "Save".tr.text.center.make(),
                        onPressed: () {
                          validateAndSaveAddTestForm();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        ),
                        child: "Cancel".tr.text.center.make(),
                        onPressed: () {
                          _selectedTestDate.value = null;
                          testNameController.text = "";
                          testDateController.value.text = "";
                          testDateController.refresh();
                          currentOpenIndexTestFileName.value = "";
                          currentOpenIndexTestFileName.refresh();

                          testFileValidationError.value = "";
                          Get.backLegacy(closeOverlays: true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ).show();
  }

  void openMembershipPopup({required UserMembership membership}) {
    //print("openMembershipPopup UserMembership $membership ");
    String memberShipMsg = "";
    DateTime now = DateTime.now();

    int daysRemaining = membership.endDate.difference(now).inDays;
    if (membership.endDate.isAfter(now)) {
      // Subscription is still active
      if (daysRemaining == 1) {
        memberShipMsg = 'Subscription currently active for $daysRemaining more day';
      } else {
        memberShipMsg = 'Subscription currently active for $daysRemaining more days';
      }
    } else {
      // Subscription has expired
      String formattedEndDate = DateFormat('yyyy-MM-dd').format(membership.endDate);
      memberShipMsg = 'Subscription expired on $formattedEndDate';
    }
    AwesomeDialog(
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Membership Details".text.make().centered(),
            const SizedBox(
              height: 20,
            ),
            "Title: ${membership.membership}".text.make().centered(),
            "Valid Upto: ${membership.month} month".text.make().pOnly(top: 10, bottom: 5),
            "Start Date: ${DateFormat('yyyy-MM-dd').format(membership.startDate.toLocal())}".text.make().pOnly(top: 5, bottom: 5),
            "End Date: ${DateFormat('yyyy-MM-dd').format(membership.endDate.toLocal())}".text.make().pOnly(top: 5, bottom: 10),
            if (daysRemaining > 0)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: memberShipMsg.split(' for ')[0], // "Subscription currently active"
                      style: const TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: ' ${memberShipMsg.split(' for ')[1]}', // Days remaining part
                      style: const TextStyle(
                        color: Colors.green, // Change color of days remaining
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).pOnly(top: 5, bottom: 10)
            else
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Subscription expired on ',
                      style: TextStyle(color: Colors.red), // "Subscription expired on"
                    ),
                    TextSpan(
                      text: DateFormat('yyyy-MM-dd').format(membership.endDate), // Formatted expired date
                      style: const TextStyle(
                        color: Colors.red, // Red color for the expired date
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).pOnly(top: 5, bottom: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: "Close".tr.text.center.make(),
              onPressed: () {
                Get.backLegacy(closeOverlays: true);
              },
            ).centered()
          ],
        ),
      ),
    ).show();
  }

  addMoreTests() async {
    //print("addMoreTests widget_${addTestsWidget.length}");
    String widgetKey = "widget_${addTestsWidget.length}";
    final key = GlobalObjectKey(widgetKey);

    addTestWidget = AddTest(
      key: key,
      onTap: () {
        openTestPopup(index: addTestsWidget.length - 1);
      },
      onRemoveIconTap: () {
        removeTestDetails(index: addTestsWidget.length - 1);
      },
      showCloseIcon: true,
      onCloseIconTap: () {
        //print("Close ${ValueKey(widgetKey)} ${addTestsWidget.length - 1}");
        addTestsWidget.removeAt(addTestsWidget.length - 1);
      },
    )
        .animate()
        .shimmer(
          duration: (1200 / 3).ms,
          color: glLightThemeColor,
          delay: (200.ms),
        )
        .fadeIn(
          duration: (1200 / 3).ms,
          curve: Curves.easeOutQuad,
          delay: (200.ms),
        )
        .slideY();
    addTestsWidget.add(addTestWidget!);
    addTestsWidget.refresh();
    await Future.delayed(DoubleExt(1000).milliseconds);
    medicalTestScrollController.animToBottom();
  }

  Future<void> _pickFile() async {
    testFileValidationError.value = "";
    testFileValidationError.refresh();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (result != null) {
      testFile = result.files.single;
      currentOpenIndexTestFileName.value = path.basename(testFile!.xFile.path);
      currentOpenIndexTestFileName.refresh();
    } else {
      // User canceled the picker
    }
  }

  removeTestDetails({required int index}) {
    //print("removeTestDetails $index");
    String widgetKey = "widget_$index";

    final key = GlobalObjectKey(widgetKey);
    addTestWidget = AddTest(
      key: key,
      onTap: () {
        openTestPopup(index: index);
      },
      showCloseIcon: index > 0 ? true : false,
      onCloseIconTap: () {
        addTestsWidget.removeAt(index);
      },
      onRemoveIconTap: () {
        removeTestDetails(index: index);
      },
    )
        .animate()
        .shimmer(
          duration: (400).ms,
          color: glLightThemeColor,
          delay: (200.ms),
        )
        .fadeIn(
          duration: (1200 / 3).ms,
          curve: Curves.easeOutQuad,
          delay: (200.ms),
        )
        .slideY();
    addTestsWidget.insert(currentOpenTestIndex, addTestWidget!);
    addTestsWidget.removeAt(currentOpenTestIndex + 1);
    addTestsWidget.refresh();
  }

  validateAndSaveAddTestForm() {
    bool checked = true;
    if (!testFormKey.currentState!.validate()) {
      checked = false;
    }
    if (testFile == null) {
      checked = false;
      testFileValidationError.value = "Test File is required";
      testFileValidationError.refresh();
    }
    if (checked) {
      Helper.showLoaderSpinner(glLightIconColor);
      MedicalTest medicalTest = MedicalTest(date: _selectedTestDateString, name: _selectedTestName, file: testFile!.xFile.path);
      toBeUploadedMedicalTests.add(medicalTest);
      String widgetKey = "widget_$currentOpenTestIndex";
      final key = GlobalObjectKey(widgetKey);
      addTestWidget = AddTest(
        key: key,
        onTap: () {
          openTestPopup(index: currentOpenTestIndex);
        },
        testDate: medicalTest.date,
        testName: medicalTest.name,
        showCloseIcon: currentOpenTestIndex > 0 ? true : false,
        onCloseIconTap: () {
          addTestsWidget.removeAt(addTestsWidget.length - 1);
        },
        onRemoveIconTap: () {
          removeTestDetails(index: currentOpenTestIndex);
        },
      )
          .animate()
          .shimmer(
            duration: (1200 / 3).ms,
            color: glLightThemeColor,
            delay: (200.ms),
          )
          .fadeIn(
            duration: (1200 / 3).ms,
            curve: Curves.easeOutQuad,
            delay: (200.ms),
          )
          .slideY();
      addTestsWidget.insert(currentOpenTestIndex, addTestWidget!);
      addTestsWidget.removeAt(currentOpenTestIndex + 1);
      addTestsWidget.refresh();
      testDateController.value.text = "";
      testNameController.text = "";
      _selectedTestDateString = "";
      _selectedTestName = "";
      _selectedTestDate.value = null;
      testNameController.text = "";
      testDateController.value.text = "";
      testDateController.refresh();
      currentOpenIndexTestFileName.value = "";
      testFileValidationError.value = "";
      Get.backLegacy(closeOverlays: true);
    }
  }

  void openInfoPopup({String title = "", String description = ""}) {
    AwesomeDialog(
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: true,
        dialogBackgroundColor: Get.theme.primaryColor,
        context: Get.context!,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        title: title,
        desc: description,
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 12,
        ),
        descTextStyle: const TextStyle(
          fontSize: 12,
        )).show();
  }

  void showImagePickerBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 150,
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            children: [
              GestureDetector(
                onTap: () {
                  pickProfileImage(ImageSource.camera);
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 48, color: Colors.green),
                    SizedBox(height: 8),
                    Text('Camera', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  pickProfileImage(ImageSource.gallery);
                },
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image, size: 48, color: Colors.blue),
                    SizedBox(height: 8),
                    Text('Gallery', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
      uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    List<UploadFile> files = [];
    String fileName = profileImage.value.path.split('/').last;
    UploadFile profilePicFile = UploadFile(fileName: fileName, filePath: profileImage.value.path != "" ? profileImage.value.path : "", variableName: "image");
    files.add(profilePicFile);
    try {
      EasyLoading.show(status: "Loading");
      var resp = await Helper.sendRequestToServer(endPoint: "upload-profile-image", requestData: {"data": "no_data"}, files: files);
      EasyLoading.dismiss();
      var response = resp.data;
      //print("uploadProfileImage $response");
      if (!response['status']) {
        String msg = response['msg'];
        Helper.showToast(msg: msg, type: "info");
      } else {
        userService.currentUser.value.userDP = response['image'];
        userService.currentUser.refresh();
        Helper.showToast(msg: "Profile Image Uploaded Successfully", type: "info", durationInSecs: 5);
        profileImage.value = File("");
      }
    } catch (e) {
      //print("$e $s");
      json.encode({'status': 'failed'.tr, 'msg': 'There is some error'.tr});
    }
  }

  void getMyCoupons({bool showLoaderOp = false}) async {
    if (showLoaderOp) {
      Helper.showToast(msg: 'Loading');
    }
    // videosLoader.value = true;
    // videosLoader.refresh();
    /*if (page == 1) {
      scrollController1 =  ScrollController();
    }*/

    var response = await Helper.sendRequestToServer(endPoint: 'my-coupons', requestData: {"data": "true"}, method: "get");

    if (response.statusCode == 200) {
      json.decode(response.body);
    }
  }

  Future fetchNotificationsList() async {
    if (page == 1) {
      EasyLoading.show(status: "${"Loading".tr}...");
    } else {}
    if (page == 1) {
      scrollController = ScrollController();
    }
    try {
      var response = await Helper.sendRequestToServer(
        endPoint: 'notifications',
        requestData: {
          'page': page.toString(),
        },
        method: "get",
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status']) {
          UserService authService = Get.find();

          authService.notificationsCount.value = jsonData['count'] ?? 0;
          authService.notificationsCount.refresh();
          if (page > 1) {
            userService.notifications.value.addAll(Helper.parseItem(jsonData['data'], NotificationModel.fromJson));
          } else {
            userService.notifications.value = Helper.parseItem(jsonData['data'], NotificationModel.fromJson);
          }

          if (page == 1) {
            EasyLoading.dismiss();
            showLoader.value = false;
            showLoader.refresh();
          }

          if (userService.notifications.value.length == authService.notificationsCount.value) {
            showLoadMore = false;
          }
        }
      }
    } catch (e) {
      //caught error
    }
  }

  notificationAction(NotificationModel item) async {
    Get.back();
    if (item.pageName == "daily_meal") {
      DashboardService.to.currentPage.value = 1;
      RootService.to.isOnHomePage.value = false;
      MealPlanController mealPlanController = Get.find();
      await mealPlanController.fetchTodayMealPlan();
      DashboardService.to.pageController.value.animateToPage(DashboardService.to.currentPage.value, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      DashboardService.to.currentPage.refresh();
      DashboardService.to.pageController.refresh();
      RootService.to.isOnHomePage.refresh();
    } else if (item.type == "water") {}
  }

  void initDeleteProfilePopup() {
    isCheckedDataDeleted.value = false;
    isCheckedPermanent.value = false;
    isCheckedConfirm.value = false;
    isButtonEnabled.value = false;
    countdownTime = 10;
    timerText.value = 'Delete Profile in $countdownTime s';
    startDelay();
    showDeleteProfileDialog();
  }

  void startDelay() async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownTime--;

      if (countdownTime >= 1) {
        timerText.value = 'Delete Profile in $countdownTime s';
      } else {
        timerText.value = 'Delete Profile';
        isButtonEnabled.value = true;

        timer.cancel();
      }
    });
  }

  // Toggle the checkbox value
  void toggleCheckbox(int checkboxIndex, bool value) {
    if (checkboxIndex == 1) {
      isCheckedDataDeleted.value = value;
    } else if (checkboxIndex == 2) {
      isCheckedPermanent.value = value;
    } else if (checkboxIndex == 3) {
      isCheckedConfirm.value = value;
    }
  }

  void showDeleteProfileDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: true, // Prevent closing the dialog by tapping outside
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(
              "Are you sure you want to delete your profile?",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Warning: This action is permanent and cannot be undone.",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  // Terms and conditions with checkboxes
                  Obx(() => CheckboxListTile(
                        title: const Text(
                          "I understand that all my data will be deleted permanently.",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: isCheckedDataDeleted.value,
                        onChanged: (value) {
                          toggleCheckbox(1, value!);
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      )),
                  Obx(() => CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        title: const Text(
                          "I understand that this action cannot be undone.",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: isCheckedPermanent.value,
                        onChanged: (value) {
                          toggleCheckbox(2, value!);
                        },
                      )),
                  Obx(() => CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4), // Reduced padding
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        title: const Text(
                          "I want to proceed with deleting my profile.",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: isCheckedConfirm.value,
                        onChanged: (value) {
                          toggleCheckbox(3, value!);
                        },
                      )),
                  const SizedBox(height: 20),
                  // Delayed delete button
                  Obx(() => ElevatedButton(
                        onPressed: isButtonEnabled.value && isCheckedDataDeleted.value && isCheckedPermanent.value && isCheckedConfirm.value
                            ? () {
                                deleteProfile();
                                Navigator.pop(context); // Close the popup
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonEnabled.value && isCheckedDataDeleted.value && isCheckedPermanent.value && isCheckedConfirm.value ? Colors.red : Colors.grey,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          timerText.value,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
