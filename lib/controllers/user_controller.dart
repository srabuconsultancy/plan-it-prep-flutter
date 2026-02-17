import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import "package:date_picker_plus/date_picker_plus.dart";
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import "package:firebase_messaging/firebase_messaging.dart";
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:nutri_ai/models/appliance.dart';
import 'package:nutri_ai/models/cooking_prep.dart';
import 'package:nutri_ai/models/cooking_time.dart';
import 'package:nutri_ai/models/cuisine.dart';
import 'package:nutri_ai/models/meal_count.dart';
import 'package:nutri_ai/models/meal_prep_schedule.dart';
import 'package:nutri_ai/models/mealtype.dart';
import 'package:nutri_ai/models/reminder_preference.dart';
import 'package:nutri_ai/views/register/register_appliances.dart';
import 'package:nutri_ai/views/register/register_cooking_prep.dart';
import 'package:nutri_ai/views/register/register_cooking_time.dart';
import 'package:nutri_ai/views/register/register_meal_count.dart';
import 'package:nutri_ai/views/register/register_meal_prep_schedule.dart';
import 'package:nutri_ai/views/register/register_meal_type.dart';
import 'package:nutri_ai/views/register/register_reminder_preferences.dart';
import 'package:nutri_ai/views/register/register_tracking_preference.dart';
import 'package:path/path.dart' as path;
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
  GlobalKey<FormState> resetForgotPassword =
      GlobalKey(debugLabel: "resetForgotPassword");
  User completeProfile = User();
  var hidePassword = true.obs;
  var keyboardVisible = false.obs;
  ValueNotifier<bool> updateViewState = ValueNotifier(false);
  var userIdValue = 0.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<FormState> otpFormKey = GlobalKey();
  var showBannerAd = false.obs;
  Map userProfile = {};
  OverlayEntry loader = OverlayEntry(builder: (context) => Container());
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
  // var phoneNoController = TextEditingController().obs;
  var userInputController = TextEditingController().obs;
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
  var gender = <Gender>[
    Gender('M', 'Male'.tr),
    Gender('F', 'Female'.tr),
    Gender('O', 'Other'.tr)
  ].obs;
  var selectedGender = Gender('M', 'Male'.tr).obs;
  var goals = <String>[].obs;
  var selectedGoal = Goal().obs;
  var medConditions = <String>[].obs;
  var foodPrefrences = <String>[].obs;

  var selectedDietPreference = DietPreference().obs;
  var fitnessLevels = <String>[].obs;
  var selectedFitnessLevel = FitnessLevel().obs;
  var exercisePlans = <String>[].obs;
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
  TextEditingController customGoalController = TextEditingController();

  var selectedMedicalIssues = <MedicalIssue>[].obs;

  var isExpand = false.obs;

  var phoneNumber = "".obs;
  var userInput = "".obs;

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
  String _selectedTestName = "";
  String _selectedTestDateString = "";
  var testFileValidationError = "".obs;
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
  var timerText = 'Delete Profile in 10s'.obs;
  int countdownTime = 10;

  var inRegisterProcess = false.obs;
  var isInAuthenticationProcess = false.obs;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final openSimNoPopup = false.obs;
  final isMobileInput = true.obs;

// To store the user's choice: 'Track' or 'Follow'
  var trackingPreference = ''.obs; // Initialize empty or with a default
  // To store the target calories if tracking is chosen
  var targetCalories = 0.obs;
  // Controller for the calorie input field
  late TextEditingController calorieInputController;

  RxString otherAllergies = ''.obs;

  final RxList<Cuisine> selectedCuisines = <Cuisine>[].obs;
  final Rx<MealType> selectedMealType = MealType(id: 0, name: '').obs;
  final Rx<CookingTime> selectedCookingTime = CookingTime().obs;
  final Rx<MealCount> selectedMealCount = MealCount().obs;
  final Rx<CookingPrep> selectedCookingPrep = CookingPrep().obs;
  final RxList<Appliance> selectedAppliances = <Appliance>[].obs;
  final Rx<MealPrepSchedule> selectedMealPrepSchedule = MealPrepSchedule().obs;
  final Rx<ReminderPreference> selectedReminderPreference =
      ReminderPreference(id: 0, name: '').obs;
  final Rx<Cuisine> selectedCuisine = Cuisine().obs;
  final Rx<Appliance> selectedAppliance = Appliance().obs;

  final TextEditingController otherPreferenceController =
      TextEditingController();

  RxDouble selectedGoalWeightInLBS = 150.0.obs;

  @override
  void onInit() {
    scrollController = ScrollController();
    registerProcessPages = [
      RegisterName(),
      RegisterSex(),
      RegisterAge(),
      RegisterWeight(),
      RegisterHeight(),
      RegisterExercisePlan(),

      // RegisterLocation(),
      RegisterGoal(),
      RegisterTrackingPreference(),

      RegisterDietPreferences(),
      // RegisterMedicalIssues(),
      RegisterAllergies(),
      // RegisterFitnessLevel(),
      RegisterMealType(),
      RegisterCookingTime(),
      RegisterMealCount(),
      RegisterCookingPrep(),

      RegisterAppliances(),
      RegisterMealPrepSchedule(),
      RegisterReminders(),

      // RegisterExercisePlan(),
      // RegisterDietRegimes(),
      // RegisterMedicalTest(),
    ];

    _initializeAddTestWidget();
    super.onInit();
    calorieInputController = TextEditingController();
  }

  @override
  void onClose() {
    calorieInputController.dispose();

    super.onClose();
  }

// --- NEW: Helper to check if Next button is valid on this page ---
  bool isTrackingPreferenceValid() {
    if (trackingPreference.isEmpty) {
      Get.snackbar("Error", "Please select an option.",
          snackPosition: SnackPosition.bottom);
      return false;
    }
    if (trackingPreference.value == 'Track' &&
        calorieInputController.text.isEmpty) {
      Get.snackbar("Error", "Please enter your target daily calories.",
          snackPosition: SnackPosition.bottom);
      return false;
    }
    if (trackingPreference.value == 'Track') {
      int? calories = int.tryParse(calorieInputController.text);
      if (calories == null || calories <= 0) {
        Get.snackbar("Error", "Please enter a valid number for calories.",
            snackPosition: SnackPosition.bottom);
        return false;
      }
      targetCalories.value = calories; // Store the valid calorie value
    }
    return true;
  }

  /// Initializes the add test widget with animation and adds it to the tests widget list
  void _initializeAddTestWidget() {
    addTestWidget = AddTest(
      key: const GlobalObjectKey('widget_0'),
      onTap: () => openTestPopup(index: 0),
      onRemoveIconTap: () => removeTestDetails(index: 0),
    )
        .animate()
        .shimmer(
            duration: (1200 / 3).ms, color: glLightThemeColor, delay: (200.ms))
        .fadeIn(
            duration: (1200 / 3).ms, curve: Curves.easeOutQuad, delay: (200.ms))
        .slideY();
    addTestsWidget.add(addTestWidget!);
  }

  /// Formats date of birth string with proper padding
  String validDob(String year, String month, String day) {
    if (day.length == 1) day = "0$day";
    if (month.length == 1) month = "0$month";
    return "$year-$month-$day";
  }

  /// Retrieves stored iOS UUID and email
  getUuId() async {
    iosUuId = (await secureStorage.read(key: '${appName}test1_iosUuId')) ?? '';
    iosEmail =
        (await secureStorage.read(key: '${appName}test1_iosEmail')) ?? '';
    //iosUuId = GetStorage().read("ios_uuid") == null ? "" : GetStorage().read("ios_uuid").toString();
    // iosEmail = GetStorage().read("ios_email") == null ? "" : GetStorage().read("ios_email").toString();
    //print("iosUuId $iosUuId");
    //print("iosEmail $iosEmail");
  }

  /// Handles social login with the provided data and type
  Future<bool> _socialLogin(Map<String, String> loginData, String type) async {
    if (type == "FB" && loginData["email"] == "") {
      userService.errorString.value =
          "Your facebook profile does not provide email address. Please try with another method";
      userService.errorString.refresh();
      return false;
    }
    var response =
        await _sendRequest('social-login', loginData, method: "post");
    if (response.statusCode == 200) {
      var chk = await setCurrentUser(response.body);
      if (chk == "success") {
        userService.currentUser.value =
            User.fromJSON(json.decode(response.body)['data']);
        userService.currentUser.refresh();
        return true;
      } else if (chk == "no-membership") {
        return await _handleNoMembership(json.decode(response.body)['content']);
      } else {
        Get.offNamed(Routes.login);
        return false;
      }
    }
    return false;
  }

  /// Handles navigation for no-membership scenario
  Future<bool> _handleNoMembership(Map<String, dynamic> content) async {
    userService.currentUser.value = User.fromJSON(content);
    userService.currentUser.refresh();
    if (RootService.to.isFeatureAccessible) {
      _showToast("You must purchase a package to generate a daily diet chart");
      PackageController packageController = Get.find();
      await packageController.getPackagesAnFeatures();
      Get.offNamed(Routes.packages);
      return false;
    } else {
      await _navigateToDashboard();
      return true;
    }
  }

  /// Sends HTTP request to the server
  Future _sendRequest(String endPoint, Map<String, dynamic> requestData,
      {String method = "post", List<UploadFile> files = const []}) async {
    try {
      return await Helper.sendRequestToServer(
          endPoint: endPoint,
          requestData: requestData,
          method: method,
          files: files);
    } catch (err) {
      throw err;
    }
  }

  /// Shows a toast message
  void _showToast(String msg, {String type = "info", int durationInSecs = 4}) {
    Helper.showToast(msg: msg, type: type, durationInSecs: durationInSecs);
  }

  /// Navigates to the dashboard after fetching data
  Future<void> _navigateToDashboard() async {
    DashboardController dashboardController = Get.find();
    await dashboardController.getData();
    Get.offAllNamed(Routes.dashboard);
  }

  /// Shows an error dialog with the specified title and message
  void _showErrorDialog(String title, String message,
      {bool dismissOnBackKeyPress = false,
      bool dismissOnTouchOutside = false}) {
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
            Text(title, style: Get.theme.textTheme.headlineMedium)
                .pOnly(bottom: 5),
            Text(message, style: Get.theme.textTheme.titleMedium)
                .pOnly(bottom: 10),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20)),
                child: Text("Ok".tr, textAlign: TextAlign.center),
                onPressed: () => Get.backLegacy(closeOverlays: true),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  /// Handles Sign In with Apple
  Future<void> signInWithApple() async {
    showLoader.value = true;
    showLoader.refresh();
    _showToast("${"Please wait".tr}...");
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.ofgwellness.dietician.dietcian_app',
          redirectUri: Uri.parse(
              'https://smiling-abrupt-screw.glitch.me/callbacks/sign_in_with_apple'),
        ),
      );
      await getUuId();
      Map<String, String> userInfo = _buildAppleUserInfo(credential);
      bool success = await _socialLogin(userInfo, 'A');
      await _handleSocialLoginResult(success, credential.email ?? "");
    } catch (e) {
      _showToast(_getAppleSignInErrorMessage(e), type: "error");
    } finally {
      showLoader.value = false;
      showLoader.refresh();
    }
  }

  /// Builds user info map for Apple login
  Map<String, String> _buildAppleUserInfo(
      AuthorizationCredentialAppleID credential) {
    if (iosUuId.isEmpty) {
      String fullUsersName =
          "${credential.givenName ?? ''}${credential.familyName != null && credential.familyName!.isNotEmpty ? " ${credential.familyName}" : ""}";
      fullNameController.value.text = fullUsersName;
      fullNameController.refresh();
      fullName.value = fullUsersName;
      fullName.refresh();
      secureStorage.write(
          key: '${appName}test1_iosUuId', value: credential.userIdentifier);
      secureStorage.write(
          key: '${appName}test1_iosEmail', value: credential.email);
      return {
        'email': credential.email ?? "",
        'login_type': "A",
        'ios_email': credential.email ?? "",
        'ios_uuid': credential.identityToken ?? "",
      };
    }
    return {
      'email': iosEmail,
      'login_type': "A",
      'ios_email': iosEmail,
      'ios_uuid': iosUuId,
    };
  }

  /// Handles the result of social login
  Future<void> _handleSocialLoginResult(
      bool success, String errorMessage) async {
    showLoader.value = false;
    showLoader.refresh();
    if (success) {
      Helper.dismissToast();
      if (userService.currentUser.value.name.isNotEmpty) {
        await _navigateToDashboard();
      } else {
        Get.offNamed(Routes.register);
      }
    } else if (userService.errorString.value.isNotEmpty) {
      _showToast(userService.errorString.value, type: "error");
    }
  }

  /// Gets appropriate error message for Apple sign-in failure
  String _getAppleSignInErrorMessage(dynamic error) {
    if (error.toString().contains("Unsupported platform")) {
      return 'Unsupported platform iOS version. Please try some other login method.';
    }
    return 'Please try Again with some other method';
  }

  /// Handles Google login
  Future<void> loginWithGoogle() async {
    try {
      await userService.googleSignIn.signOut();
    } catch (e) {
      //print("$e + $s");
    }
    await userService.googleSignIn.signIn();
    if (userService.googleSignIn.currentUser != null) {
      _showToast("${"Please wait".tr}...");
      fullNameController.value.text =
          userService.googleSignIn.currentUser!.displayName!;
      fullNameController.refresh();
      fullName.value = userService.googleSignIn.currentUser!.displayName!;
      fullName.refresh();
      final userInfo = {
        'email': userService.googleSignIn.currentUser!.email,
        'login_type': "G",
      };
      try {
        bool success = await _socialLogin(userInfo, 'G');
        await _handleSocialLoginResult(success, "");
      } catch (e) {
        Helper.dismissToast();
        _showToast('Sign In with Google failed!', type: "error");
        //print("error $e, errorStack $s");
      }
    } else {
      Helper.dismissToast();
    }
  }

  /// Handles Google login (Google + Firebase + App backend)
  Future<void> signInWithGoogle() async {
    try {
      // Sign out first to force account chooser
      await userService.googleSignIn.signOut();
      await signOut(); // Firebase sign out (if exists)
    } catch (e) {
      // ignore
    }

    // Trigger Google sign-in
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: ['email'],
      serverClientId:
          '18038826346-gnisbaun62jt1qoiqprt5dqh8tjbf3on.apps.googleusercontent.com',
    ).signIn();

    if (googleUser == null) {
      Helper.dismissToast();
      return;
    }

    _showToast("${"Please wait".tr}...");

    // -------- Firebase Authentication --------
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    // -------- App Data Handling --------
    fullNameController.value.text = googleUser.displayName!;
    fullNameController.refresh();

    fullName.value = googleUser.displayName!;
    fullName.refresh();

    final userInfo = {
      'email': googleUser.email,
      'login_type': "G",
    };

    try {
      bool success = await _socialLogin(userInfo, 'G');
      await _handleSocialLoginResult(success, "");
    } catch (e) {
      Helper.dismissToast();
      _showToast('Sign In with Google failed!', type: "error");
    }
  }

//sign out funtion from google and firebase
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  /// Launches a URL
  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '${"Could not launch".tr} $url';
    }
  }

  /// Validates a form field
  String? validateField(String value, String field) {
    Pattern pattern = r'^[0-9A-Za-z.\-_]*$';
    RegExp regex = RegExp(pattern.toString());
    if (value.isEmpty) return "${field.tr} ${'is required!'.tr}";
    if (field == "Confirm Password" && value != password) {
      return "${'Confirm Password'.tr} ${'doesn\'t match!'.tr}";
    }
    if (field == "Username" && !regex.hasMatch(value)) {
      return "${'Username'.tr} ${'must contain only _ . and alphanumeric'.tr}";
    }
    return null;
  }

  /// Validates an email field
  String? validateEmail(String? value) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value!);
    isValidEmail.value = value.isNotEmpty && emailValid;
    if (value.isEmpty) return "${'Email'.tr} ${'field is required!'.tr}";
    if (!emailValid) return "${'Email'.tr} ${'field is not valid!'.tr}";
    return null;
  }

  /// Handles user registration
  Future<void> register() async {
    if (inRegisterProcess.value ||
        !completeProfileFormKey.currentState!.validate()) {
      //print(inRegisterProcess.value ? "Already in registration process" : "Form validation failed");
      return;
    }
    inRegisterProcess.value = true;
    _showToast("Please wait.");
    final userProfile = _buildUserProfile();
    final files = await _prepareFiles(userProfile);
    try {
      var apiResponse = await _sendRequest(
          'update-user-information', userProfile,
          files: files);
      dynamic value =
          files.isEmpty ? apiResponse.body : json.encode(apiResponse.data);
      if (value == null) {
        //print("API response is null");
        return;
      }
      await _handleRegisterResponse(json.decode(value));
    } catch (e) {
      //print("Exception during register: $e\n");
    } finally {
      inRegisterProcess.value = false;
    }
  }

  /// Builds user profile map for registration
  Map<String, dynamic> _buildUserProfile() {
    return {
      'full_name': fullName.value,
      'gender': selectedGender.value.value,
      'age': selectedAge.value.toString(),
      'height': selectedHeightInCms.value.toString(),
      'weight': selectedWeightInKGS.value.toString(),
      'target_value': selectedGoalWeightInKGS.value.toString(),
      'country_id': selectedCountry.value.id.toString(),
      'state_id': selectedState.value.id.toString(),
      'city_id': selectedCity.value.id.toString(),
      'fitness_level_id': selectedFitnessLevel.value.id.toString(),
      'goal_id': selectedGoal.value.id.toString(),
      'exercise_plan_day_id': selectedExercisePlan.value.id.toString(),
      'medical_issue_ids': selectedMedicalIssues.isNotEmpty
          ? selectedMedicalIssues.value.map((item) => item.id).join(',')
          : "",
      'allergy_ids': selectedAllergies.isNotEmpty
          ? selectedAllergies.value.map((item) => item.id).join(',')
          : "",
      'regimes_ids': selectedDietRegimes.isNotEmpty
          ? selectedDietRegimes.value.map((item) => item.id).join(',')
          : "",
      'user_pref_id': selectedDietPreference.value.id.toString(),
      if (selectedDp.value.path.isNotEmpty)
        'profile_pic_file': selectedDp.value.path,
      'number_of_tests': toBeUploadedMedicalTests.length,
      'cooking_prep_id': selectedCookingPrep.value.id.toString(),
      'daily_calorie_intake':
          (double.tryParse(calorieInputController.text) ?? 0.0) > 0
              ? calorieInputController.text
              : '1800',
      'cuisine_id': selectedCuisine.value.id.toString(),
      'meal_count_id': selectedMealCount.value.id.toString(),
      'meal_prep_schedule_id': selectedMealPrepSchedule.value.id.toString(),
      'appliance_ids': selectedAppliances.isNotEmpty
          ? selectedAppliances.map((item) => item.id).join(',')
          : "",
      'cooking_time_id': selectedCookingTime.value.id.toString(),
      'other_food_preferences': otherPreferenceController.value.text,
      'other_allergies': otherAllergies.value
    };
  }

  /// Prepares files for upload during registration
  Future<List<UploadFile>> _prepareFiles(
      Map<String, dynamic> userProfile) async {
    final files = <UploadFile>[];
    if (userProfile['profile_pic_file'] != null &&
        userProfile['profile_pic_file'] != "") {
      files.add(UploadFile(
        fileName: userProfile['profile_pic_file']!.split('/').last,
        filePath: selectedDp.value.path,
        variableName: "profile_pic_file",
      ));
    }
    for (int i = 0; i < toBeUploadedMedicalTests.length; i++) {
      var test = toBeUploadedMedicalTests[i];
      userProfile["test_name_$i"] = test.name;
      userProfile["test_date_$i"] = test.date;
      files.add(UploadFile(
        fileName: "${test.name}_${DateTime.now().microsecondsSinceEpoch}",
        filePath: test.file,
        variableName: "test_file_$i",
      ));
    }
    return files;
  }

  /// Handles registration API response
  Future<void> _handleRegisterResponse(Map response) async {
    if (!response['status']) {
      _showErrorDialog("Error Registering User".tr, response['msg'],
          dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
      return;
    }
    // setCurrentUser(json.encode(response));
    UserService.to.currentUser.value.name = fullName.value;
    UserService.to.currentUser.value.gender = selectedGender.value.value;
    UserService.to.currentUser.value.age = selectedAge.value;
    UserService.to.currentUser.value.height = selectedHeightInCms.value;
    UserService.to.currentUser.value.weight = selectedWeightInKGS.value;
    UserService.to.currentUser.value.targetWeight =
        selectedGoalWeightInKGS.value;
    UserService.to.currentUser.value.country = selectedCountry.value.name;
    UserService.to.currentUser.value.state = selectedState.value.name;
    UserService.to.currentUser.value.city = selectedCity.value.name;

    if (RootService.to.isFeatureAccessible) {
      Dialogs.materialDialog(
        barrierDismissible: false,
        color: Colors.white,
        title: 'Profile Created Successfully',
        msgAlign: TextAlign.center,
        msg:
            'Your Profile is submitted successfully. Our Dietitians will assign you a diet plan according to your preferences, it might take sometime for the process.',
        lottieBuilder:
            Lottie.asset('assets/lottie/preparing.json', fit: BoxFit.contain),
        context: Get.context!,
        useRootNavigator: true,
        actionsBuilder: (context) => [
          IconsButton(
            onPressed: () async {
              Get.backLegacy(closeOverlays: true);
              if (RootService.to.config.value.showPaymentsMemberships) {
                PackageController packageController = Get.find();
                await packageController.getPackagesAnFeatures();
                Get.offNamed(Routes.packages);
              } else {
                UserService.to.currentUser.value.membershipStartDate =
                    DateTime.now();
                UserService.to.currentUser.value.membershipEndDate =
                    DateTime.now().add(const Duration(days: 30));
                DashboardController dashboardController = Get.find();
                dashboardController.getData();
                Get.offNamed(Routes.dashboard);
              }
            },
            // text: 'Proceed To Choose',
            text: 'Proceed To Dashboard',
            iconData: Icons.done,
            color: glLightThemeColor,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ],
      );
    } else {
      await _navigateToDashboard();
    }
  }

  /// Authenticates user with phone number or email
  Future<String> authenticate() async {
    debugPrint("token is");
    debugPrint(UserService.to.currentUser.value.accessToken);
    _showToast('Loading');
    final userProfile = {'user_input': userInput.value};
    var response = await _sendRequest('authenticate', userProfile);
    var data = json.decode(response.body);
    if (!data["status"]) {
      showSendOtp.value = true;
      showSendOtp.refresh();
      _showToast(data["msg"], type: "error", durationInSecs: 2);
      return "Otp";
    }
    Helper.dismissToast();
    _showToast(data["msg"], type: "success", durationInSecs: 2);
    Get.toNamed(Routes.verifyOtp);
    return "Done";
  }

  /// Logs in user with phone and OTP
  Future<String> login() async {
    _showToast('Loading');
    final userProfile = {'phone': phoneNumber.value, 'otp': otp};
    var response = await _sendRequest('login', userProfile);
    var data = json.decode(response.body);
    return await _handleLoginResponse(data);
  }

  /// Handles login API response
  Future<String> _handleLoginResponse(Map response) async {
    if (response["status"] != true) {
      if (response['status'] == 'email_not_verified') {
        var content = json.decode(json.encode(response['content']));
        await GetStorage().write("otp_user_id", content['user_id'].toString());
        await GetStorage().write("otp_app_token", content['app_token']);
        showSendOtp.value = true;
        showSendOtp.refresh();
        _showErrorDialog('Error Logging OTP', response['msg']);
        return "Otp";
      } else if (response['content'] != null) {
        String chk = await setCurrentUser(json.encode(response));
        if (chk == "success") {
          updateFCMTokenForUser();
          userService.currentUser.value = User.fromJSON(response['content']);
          userService.currentUser.refresh();
          await _navigateToDashboard();
          return "Done";
        } else if (chk == "no-membership") {
          bool chk = await _handleNoMembership(response['content']);
          if (chk) {
            return "Done";
          } else {
            return "Error";
          }
        } else {
          Get.offNamed(Routes.login);
          return "Done";
        }
      }
      _showErrorDialog('Error', response['msg']);
      return "Error";
    }
    return "Error";
  }

  /// Verifies OTP for login
  Future<void> verifyOtp() async {
    _showToast('Loading');
    final data = {'user_input': userInput.value, 'otp': otp};
    var response = await _sendRequest("verify-otp", data);
    var jsonData = json.decode(response.body);
    if (!jsonData['status']) {
      _showToast(jsonData['msg']);
      return;
    }
    String chk = await setCurrentUser(response.body);
    if (chk == "success") {
      updateFCMTokenForUser();
      if (userService.currentUser.value.name.isNotEmpty) {
        await _navigateToDashboard();
      } else {
        Get.offNamed(Routes.register);
      }
    } else if (chk == "no-membership") {
      if (userService.currentUser.value.name.isNotEmpty) {
        _showToast(
            "You must purchase a package to generate a daily diet chart");
      } else {
        Get.offNamed(Routes.register);
      }
    } else {
      Get.offNamed(Routes.login);
    }
  }

  /// Resends OTP
  Future<void> resendOtp({bool verifyPage = false}) async {
    if (verifyPage) {
      startTimer();
      bHideTimer.value = true;
      bHideTimer.refresh();
      reload.value = true;
      reload.refresh();
      countTimer.value = 60;
      countTimer.refresh();
    }
    showLoader.value = true;
    showLoader.refresh();
    final data = {
      'user_id': GetStorage().read("otp_user_id")!,
      'app_token': GetStorage().read("otp_app_token")!,
    };
    var response = await _sendRequest('resend-otp', data);
    showLoader.value = false;
    showLoader.refresh();
    var jsonData = json.decode(response.body);
    if (jsonData['status'] != 'success') {
      showSendOtp.value = true;
      showSendOtp.refresh();
      _showErrorDialog('Error Verifying OTP', jsonData['msg']);
    } else if (!verifyPage) {
      Get.toNamed('/verify-otp');
    }
  }

  /// Updates user profile
  Future<bool> editProfile() async {
    if (!editProfileFormKey.currentState!.validate()) {
      //print("Form validation failed");
      return false;
    }
    _showToast("Please wait.");
    final userProfile = {
      'full_name': fullName.value,
      'phone': phoneNumber.value.toString(),
      'email': email.value.toString(),
      'age': selectedAge.value.toString(),
      'height': selectedHeightInCms.toString(),
    };
    try {
      var response = await _sendRequest('update-profile', userProfile);
      var jsonData = json.decode(response.body);
      if (!jsonData['status']) {
        _showErrorDialog("Error Registering User".tr, jsonData['msg'],
            dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
        return false;
      }
      Dialogs.materialDialog(
        color: Colors.white,
        title: 'Updated profile successfully',
        msgAlign: TextAlign.center,
        lottieBuilder: Lottie.asset('assets/lottie/congratulations.json',
            fit: BoxFit.contain),
        context: Get.context!,
        useRootNavigator: true,
      );
      return true;
    } catch (e) {
      //print("Exception during editProfile: $e\n$s");
      return false;
    }
  }

  /// Starts a countdown timer
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countTimer.value--;
      countTimer.refresh();
      if (countTimer.value <= 0) {
        bHideTimer.value = false;
        bHideTimer.refresh();
        reload.value = true;
        reload.refresh();
        timer.cancel();
      }
    });
  }

  /// Checks if email exists
  Future<void> ifEmailExists(String email) async {
    showLoader.value = true;
    showLoader.refresh();
    var response = await _sendRequest("is-email-exist", {"email": email});
    showLoader.value = false;
    showLoader.refresh();
    if (response.statusCode == 200 &&
        json.decode(response.body)['status'] == "success") {
      userService.errorString.value = "";
      userService.errorString.refresh();
      if (json.decode(response.body)['isEmailExist'] == 1) {
        _showErrorDialog('Email Already Exists'.tr,
            'Use another email to register or login using existing email'.tr,
            dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
      } else {
        loginType = "O";
        Get.toNamed("/complete-profile");
      }
    } else {
      throw Exception(response.body);
    }
  }

  /// Tests diet plan generator API
  Future<void> testDietPlanGenerator() async {
    showLoader.value = true;
    showLoader.refresh();
    var response = await _sendRequest("test-diet-plan-api", {"test": "test"});
    showLoader.value = false;
    showLoader.refresh();
    if (response.statusCode == 200 &&
        json.decode(response.body)['status'] == "success") {
      userService.errorString.value = "";
      userService.errorString.refresh();
    }
  }

  /// Picks an image from camera or gallery
  Future<void> getImageOption(bool isCamera) async {
    final pickedFile = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    if (pickedFile != null) {
      selectedDp.value = File(pickedFile.path);
      reload.value = true;
      reload.refresh();
    } else {
      //print('No image selected.');
    }
  }

  /// Sends password reset OTP
  Future<void> sendPasswordResetOTP() async {
    _showToast("${'Loading'.tr}....");
    showLoader.value = true;
    showLoader.refresh();
    formKey.currentState!.save();
    var response =
        await _sendRequest('forgot-password', {'email': email.value});
    showLoader.value = false;
    showLoader.refresh();
    var jsonData = json.decode(response.body);
    if (jsonData['status'] != 'success') {
      _showErrorDialog('Sorry this email account does not exists'.tr, '',
          dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
    } else {
      _showToast("An OTP is sent to your email please check your email");
      await Future.delayed(const Duration(seconds: 2));
      userService.resetPasswordEmail.value = email.value;
      Get.offNamed('/reset-forgot-password');
    }
  }

  /// Updates forgotten password
  Future<void> updateForgotPassword() async {
    _showToast("${'Loading'.tr}....");
    showLoader.value = true;
    showLoader.refresh();
    resetForgotPassword.currentState!.save();
    final data = {
      'email': userService.resetPasswordEmail.value,
      'otp': otp,
      'password': password,
      'confirm_password': confirmPassword,
    };
    var response = await _sendRequest('update-forgot-password', data);
    showLoader.value = false;
    showLoader.refresh();
    var jsonData = json.decode(response.body);
    if (jsonData['status'] != 'success') {
      _showErrorDialog(jsonData['msg'].tr, '',
          dismissOnBackKeyPress: true, dismissOnTouchOutside: true);
    } else {
      _showToast("${'Password'.tr} ${'Updated Successfully'.tr}");
      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed(Routes.login);
    }
  }

  /// Deletes user profile
  Future<bool> deleteProfile() async {
    try {
      var response = await _sendRequest('delete-profile', {});
      if (response.statusCode != 200) {
        var resp = jsonDecode(response.body);
        _showToast(resp["msg"].tr, type: "error");
        return false;
      }
      var resp = jsonDecode(response.body);
      if (resp['status']) {
        await _handleLogout();
        Get.offNamed(Routes.login);
        return true;
      }
      _showToast(resp["msg"].tr, type: "error");
      return false;
    } catch (e) {
      _showToast("Error verifying OTP".tr, type: "error");
      //print("files error $e");
      return false;
    }
  }

  /// Updates FCM token for user
  Future<void> updateFCMTokenForUser() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token!.isNotEmpty) {
        //print("updateFCMTokenForUser $token");
        await updateFcmToken(token);
      }
    } catch (e) {
      //print("updateFCMTokenForUser $e $s");
    }
  }

  /// Updates FCM token on server
  Future<void> updateFcmToken(String token) async {
    try {
      var response =
          await _sendRequest('update-fcm-token', {"fcm_token": token});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        userService.notificationsCount.value = jsonData['count'] ?? 0;
        userService.notificationsCount.refresh();
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  /// Gets current user from storage
  Future<User> getCurrentUser() async {
    if (userService.currentUser.value.accessToken.isEmpty &&
        GetStorage().hasData('current_user')) {
      try {
        var decodedUser = json.decode(GetStorage().read('current_user')!);
        userService.currentUser.value =
            LoginResponseModel.fromJSON(decodedUser).data!;
      } catch (e) {
        //print("error user $e");
      }
    }
    userService.currentUser.refresh();
    return userService.currentUser.value;
  }

  /// Sets current user data
  Future<String> setCurrentUser(String responseBody,
      [bool isEdit = false]) async {
    //print("setCurrentUser $responseBody");
    try {
      var userData = json.decode(responseBody)['data'];
      bool membership = json.decode(responseBody)['membership'] ?? false;
      if (userData != null) {
        User userObject = User.fromJSON(userData);
        // if (membership) {
        //   if (!userObject.membershipEndDate!.isAfter(
        //       DateTime(today.year, today.month, today.day, 23, 59, 59))) {
        //     _showToast("Membership Expired", type: "error", durationInSecs: 5);
        //     return "expired";
        //   }
        // }
        await GetStorage().write('current_user', json.encode(userData));
        userService.currentUser.value = userObject;
        userService.currentUser.refresh();
        return "success";
      }
      //print("setCurrentUser error");
      return "failed";
    } catch (e) {
      //print("setCurrentUser error: $e\n$s");
      return "failed";
    }
  }

  /// Logs out user
  Future<void> logout() async {
    await _handleLogout();
    page = 0;
    RootController rootController = Get.find();
    rootController.getAppConfig();
    userService.currentUser.value = User();
    userService.currentUser.refresh();
    DashboardService dashboardService = Get.find();
    dashboardService.currentPage.value = 0;
    dashboardService.currentPage.refresh();
    dashboardService.pageController.value.animateToPage(
        dashboardService.currentPage.value,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear);
    dashboardService.pageController.refresh();
    DashboardService.to.isOnDashboard.value = false;
    DashboardService.to.isOnDashboard.refresh();
    registerProcessPageIndex.value = 0;
    registerProcessPageIndex.refresh();
    Get.offNamed(Routes.login);
  }

  /// Handles logout process
  Future<void> _handleLogout() async {
    try {
      if (userService.currentUser.value.loginType == 'G') {
        await userService.googleSignIn.signOut();
        await signOut();
      }
      await GetStorage().remove('current_user');
      await GetStorage().remove('EULA_agree');
    } catch (e) {
      //print("error disconnecting: $e");
    }
  }

  /// Gets unique ID for user
  Future<void> userUniqueId() async {
    uniqueId = GetStorage().read('unique_id') ?? "";
    if (uniqueId.isEmpty) {
      try {
        var response =
            await _sendRequest('get-unique-id', {"data_var": "data"});
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 'success') {
            await GetStorage().write("unique_id", jsonData['unique_token']);
            uniqueId = jsonData['unique_token'];
          }
        }
      } catch (e) {
        //print("$e\n$s");
      }
    }
  }

  /// Checks if user is authenticated
  // In your UserController.dart
  Future<String> checkIfAuthenticated() async {
    // <-- 1. Change return type
    isInAuthenticationProcess.value = true;
    isInAuthenticationProcess.refresh();
    if (GetStorage().hasData('current_user')) {
      userService.currentUser.value =
          User.fromJSON(json.decode(GetStorage().read('current_user')));
    }
    if (userService.currentUser.value.accessToken.isEmpty) {
      isInAuthenticationProcess.value = false;
      isInAuthenticationProcess.refresh();
      return Routes.login; // <-- 2. Return route string
    }
    var response = await _sendRequest("refresh", {"data_var": "data"});

    if (response.statusCode == 200) {
      String chk = await setCurrentUser(response.body);
      if (chk == "success") {
        updateFCMTokenForUser();
        if (userService.currentUser.value.name.isNotEmpty) {
          isInAuthenticationProcess.value = false;
          isInAuthenticationProcess.refresh();
          // await _navigateToDashboard();
          return Routes.dashboard; // <-- 2. Return route string
        } else {
          isInAuthenticationProcess.value = false;
          isInAuthenticationProcess.refresh();
          return Routes.register; // <-- 2. Return route string
        }
      } else if (chk == "no-membership") {
        if (userService.currentUser.value.name.isEmpty) {
          isInAuthenticationProcess.value = false;
          isInAuthenticationProcess.refresh();
          return Routes.register; // <-- 2. Return route string
        } else if (RootService.to.isFeatureAccessible) {
          _showToast(
              "You must purchase a package to generate a daily diet chart");
          PackageController packageController = Get.find();

          await packageController.getPackagesAnFeatures();
          isInAuthenticationProcess.value = false;
          isInAuthenticationProcess.refresh();
          return Routes.packages; // <-- 2. Return route string
        } else {
          isInAuthenticationProcess.value = false;
          isInAuthenticationProcess.refresh();
          // await _navigateToDashboard();
          return Routes.dashboard; // <-- 2. Return route string
        }
      } else {
        userService.currentUser.value = User();
        await GetStorage().remove("current_user");
        isInAuthenticationProcess.value = false;
        isInAuthenticationProcess.refresh();
        return Routes.login; // <-- 2. Return route string
      }
    } else {
      userService.currentUser.value = User();
      await GetStorage().remove("current_user");
      isInAuthenticationProcess.value = false;
      isInAuthenticationProcess.refresh();
      return Routes.login; // <-- 2. Return route string
    }
  }

  /// Gets user payment transactions
  Future<void> getMyPayments() async {
    var response =
        await _sendRequest("my-payments", {"data_var": "data"}, method: "get");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        userService.myPaymentTransactions.value =
            Helper.parseItem(jsonData['data'], UserPayment.fromJson);
        userService.myPaymentTransactions.refresh();
      }
    }
  }

  /// Gets user progress images
  Future<void> getMyProgressImages() async {
    var response = await _sendRequest(
        "user-progress-images", {"data_var": "data"},
        method: "get");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        userService.myProgressImages.value =
            Helper.parseItem(jsonData['data'], ProgressImage.fromJson);
        userService.myProgressImages.refresh();
      }
    }
  }

  /// Picks progress image
  Future<void> pickProgressImage() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 800);
    if (pickedImage != null) {
      progressImage.value = File(pickedImage.path);
      progressImage.refresh();
      await uploadProgressImage();
    }
  }

  /// Uploads progress image
  Future<void> uploadProgressImage() async {
    showUploadProgressImageBackIcon.value = false;
    showUploadProgressImageBackIcon.refresh();
    List<UploadFile> files = [
      UploadFile(
        fileName: progressImage.value.path.split('/').last,
        filePath: progressImage.value.path,
        variableName: "image",
      ),
    ];
    try {
      EasyLoading.show(status: "Loading");
      var response =
          await _sendRequest("upload-image", {"data": "no_data"}, files: files);
      EasyLoading.dismiss();
      var jsonData = response.data;
      if (!jsonData['status']) {
        _showToast(jsonData['msg'], type: "error");
      } else {
        Get.backLegacy(closeOverlays: true);
        _showToast("Image Uploaded Successfully",
            type: "info", durationInSecs: 5);
        progressImage.value = File("");
        progressImage.refresh();
        await getMyProgressImages();
        showUploadProgressImageBackIcon.value = true;
        showUploadProgressImageBackIcon.refresh();
      }
    } catch (e) {
      //print("$e $s");
    }
  }

  /// Shows logout confirmation dialog
  void logoutConfirmation() {
    AwesomeDialog(
      context: Get.context!,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: 400,
      dialogBackgroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Logout",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Are you sure you want to log out?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              // CANCEL BUTTON
              Expanded(
                child: ElevatedButton(
                  // EXPLICITLY CLOSE THE DIALOG ONLY
                  onPressed: () {
                    Navigator.of(Get.context!).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 15),

              // LOGOUT BUTTON
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(Get.context!).pop(); // Close dialog first
                    logout(); // Then perform logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Logout"),
                ),
              ),
            ],
          ),
        ],
      ),
    ).show();
  }

  /// Navigates to next registration page
  void onNextButtonPressed() {
    if (completeProfileFormKey.currentState != null &&
        completeProfileFormKey.currentState!.validate()) {
      debugPrint("lets go");
      animateToNextPage.value = true;
      animateToNextPage.refresh();
      if (registerProcessPageIndex.value < registerProcessPages.length - 1) {
        debugPrint("lets back");
        registerProcessPageIndex++;
        registerProcessPageIndex.refresh();
      } else {
        register();
      }
    }
  }

  /// Navigates to previous registration page
  void onPreviousButtonPressed() {
    animateToNextPage.value = false;
    animateToNextPage.refresh();
    update();
    if (registerProcessPageIndex > 0) {
      registerProcessPageIndex--;
      registerProcessPageIndex.refresh();
    }
  }

  /// Converts weight between units
  void convertWeight() {
    if (!weightInLbs.value) {
      convertLbsToKgs();
    } else {
      convertKgsToLbs();
    }
  }

  /// Converts pounds to kilograms
  void convertLbsToKgs() {
    selectedWeightInKGS.value = selectedWeightInLbs.value * 0.45359237;
    selectedWeightInKGS.refresh();
  }

  /// Converts kilograms to pounds
  void convertKgsToLbs() {
    selectedWeightInLbs.value = selectedWeightInKGS.value / 0.45359237;
    selectedWeightInLbs.refresh();
  }

  /// Converts height between units
  void convertHeight() {
    if (heightInCms.value) {
      convertCmToFeetAndInches(selectedHeightInCms.value.toDouble());
    } else {
      convertFeetAndInchesToCm(
          selectedHeightInFeet.value, selectedHeightInInches.value);
    }
  }

  /// Converts centimeters to feet and inches
  void convertCmToFeetAndInches(double cm) {
    double inches = cm / 2.54;
    int feet = inches ~/ 12;
    int remainingInches = (inches % 12).round();
    selectedHeightInFeet.value = feet;
    selectedHeightInInches.value = remainingInches;
  }

  /// Converts feet and inches to centimeters
  void convertFeetAndInchesToCm(int feet, int inches) {
    int totalInches = ((feet * 12) + inches).round();
    double cm = totalInches * 2.54;
    selectedHeightInCms.value = cm.round().toDouble();
  }

  /// Opens test popup for medical test
  void openTestPopup({required int index}) {
    currentOpenTestIndex = index;
    MedicalTest? currentMedicalTest;
    try {
      currentMedicalTest = toBeUploadedMedicalTests.elementAt(index);
      testNameController.text = currentMedicalTest.name;
      testDateController.value.text = currentMedicalTest.date;
      testDateController.refresh();
      currentOpenIndexTestFileName.value =
          path.basename(currentMedicalTest.file);
      currentOpenIndexTestFileName.refresh();
    } catch (e) {
      //print("toBeUploadedMedicalTests Index does not exist");
    }
    AwesomeDialog(
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: true,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      body: _buildTestPopupBody(),
    ).show();
  }

  /// Builds test popup body
  Widget _buildTestPopupBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      child: Form(
        key: testFormKey,
        child: Obx(
          () => Column(
            children: [
              Text("Upload Test", style: Get.theme.textTheme.headlineMedium)
                  .pOnly(bottom: 5),
              DropdownSearch<MedicalTest>(
                items: (f, cs) => rootService.config.value.tests,
                filterFn: (medicalT, filter) => medicalT.name
                    .toLowerCase()
                    .startsWith(filter.toLowerCase()),
                itemAsString: (MedicalTest u) => u.name,
                compareFn: (a, b) => a.id == b.id,
                onChanged: (value) => _selectedTestName = value!.name,
                popupProps: PopupProps.menu(
                  menuProps: const MenuProps(align: MenuAlign.bottomCenter),
                  fit: FlexFit.loose,
                  itemBuilder: (context, item, isDisabled, isSelected) =>
                      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(item.name, style: const TextStyle(fontSize: 14)),
                  ),
                ),
                decoratorProps: DropDownDecoratorProps(
                  baseStyle: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: "Select a Test".tr,
                    labelStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(glBorderRadius)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.lightGreen),
                        borderRadius: BorderRadius.circular(glBorderRadius)),
                  ),
                ),
                validator: (v) =>
                    v == null || v.name.isEmpty ? "Test is required".tr : null,
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
                textFieldOnTap: _selectTestDate,
                textFieldLabelText: 'Test Date',
                textFieldHintText: 'Test Date',
                textFieldSuffixIconWidget:
                    Icon(Icons.calendar_today, color: glLightThemeColor),
                textFieldValidator: (v) =>
                    v == null || v.isEmpty ? "Test Date is required" : null,
              ),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload File'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              if (currentOpenIndexTestFileName.value.isNotEmpty)
                Text(currentOpenIndexTestFileName.value,
                        style: const TextStyle(color: Colors.red))
                    .centered(),
              if (testFileValidationError.value.isNotEmpty)
                Text(testFileValidationError.value,
                        style: const TextStyle(color: Colors.red))
                    .centered(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20)),
                      onPressed: validateAndSaveAddTestForm,
                      child: Text("Save".tr, textAlign: TextAlign.center),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20)),
                      onPressed: _clearTestForm,
                      child: Text("Cancel".tr, textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Selects test date
  Future<void> _selectTestDate() async {
    DateTime? date = await showDatePickerDialog(
      maxDate: DateTime.now(),
      minDate: DateTime.now().subtract(VxIntExtension(60).days),
      context: Get.context!,
    );
    _selectedTestDate.value = date;
    _selectedTestDate.refresh();
    _selectedTestDateString = "${date!.year}-${date.month}-${date.day}";
    testDateController.value.text = _selectedTestDateString;
    testDateController.refresh();
  }

  /// Clears test form
  void _clearTestForm() {
    _selectedTestDate.value = null;
    testNameController.text = "";
    testDateController.value.text = "";
    testDateController.refresh();
    currentOpenIndexTestFileName.value = "";
    currentOpenIndexTestFileName.refresh();
    testFileValidationError.value = "";
    Get.backLegacy(closeOverlays: true);
  }

  /// Opens membership details popup
  void openMembershipPopup({required UserMembership membership}) {
    String memberShipMsg = membership.endDate.isAfter(DateTime.now())
        ? 'Subscription currently active for ${membership.endDate.difference(DateTime.now()).inDays} more day${membership.endDate.difference(DateTime.now()).inDays == 1 ? '' : 's'}'
        : 'Subscription expired on ${DateFormat('yyyy-MM-dd').format(membership.endDate)}';
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
            Text("Membership Details").centered(),
            const SizedBox(height: 20),
            Text("Title: ${membership.membership}").centered(),
            Text("Valid Upto: ${membership.month} month")
                .pOnly(top: 10, bottom: 5),
            Text("Start Date: ${DateFormat('yyyy-MM-dd').format(membership.startDate.toLocal())}")
                .pOnly(top: 5, bottom: 5),
            Text("End Date: ${DateFormat('yyyy-MM-dd').format(membership.endDate.toLocal())}")
                .pOnly(top: 5, bottom: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: memberShipMsg.split(' for ')[0],
                      style: const TextStyle(color: Colors.black)),
                  TextSpan(
                    text: memberShipMsg.contains('for')
                        ? ' ${memberShipMsg.split(' for ')[1]}'
                        : DateFormat('yyyy-MM-dd').format(membership.endDate),
                    style: TextStyle(
                        color: memberShipMsg.contains('for')
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ).pOnly(top: 5, bottom: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              child: Text("Close".tr, textAlign: TextAlign.center),
              onPressed: () => Get.backLegacy(closeOverlays: true),
            ).centered(),
          ],
        ),
      ),
    ).show();
  }

  /// Adds more medical tests
  void addMoreTests() async {
    String widgetKey = "widget_${addTestsWidget.length}";
    final key = GlobalObjectKey(widgetKey);
    addTestWidget = AddTest(
      key: key,
      onTap: () => openTestPopup(index: addTestsWidget.length - 1),
      onRemoveIconTap: () =>
          removeTestDetails(index: addTestsWidget.length - 1),
      showCloseIcon: true,
      onCloseIconTap: () => addTestsWidget.removeAt(addTestsWidget.length - 1),
    )
        .animate()
        .shimmer(
            duration: (1200 / 3).ms, color: glLightThemeColor, delay: (200.ms))
        .fadeIn(
            duration: (1200 / 3).ms, curve: Curves.easeOutQuad, delay: (200.ms))
        .slideY();
    addTestsWidget.add(addTestWidget!);
    addTestsWidget.refresh();
    await Future.delayed(Duration(milliseconds: 1000));
    medicalTestScrollController.animToBottom();
  }

  /// Picks a file for medical test
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
    }
  }

  /// Removes test details
  void removeTestDetails({required int index}) {
    String widgetKey = "widget_$index";
    final key = GlobalObjectKey(widgetKey);
    addTestWidget = AddTest(
      key: key,
      onTap: () => openTestPopup(index: index),
      showCloseIcon: index > 0,
      onCloseIconTap: () => addTestsWidget.removeAt(index),
      onRemoveIconTap: () => removeTestDetails(index: index),
    )
        .animate()
        .shimmer(duration: (400).ms, color: glLightThemeColor, delay: (200.ms))
        .fadeIn(
            duration: (1200 / 3).ms, curve: Curves.easeOutQuad, delay: (200.ms))
        .slideY();
    addTestsWidget.insert(currentOpenTestIndex, addTestWidget!);
    addTestsWidget.removeAt(currentOpenTestIndex + 1);
    addTestsWidget.refresh();
  }

  /// Validates and saves medical test form
  void validateAndSaveAddTestForm() {
    bool checked = testFormKey.currentState!.validate();
    if (testFile == null) {
      checked = false;
      testFileValidationError.value = "Test File is required";
      testFileValidationError.refresh();
    }
    if (checked) {
      Helper.showLoaderSpinner(glLightIconColor);
      MedicalTest medicalTest = MedicalTest(
          date: _selectedTestDateString,
          name: _selectedTestName,
          file: testFile!.xFile.path);
      toBeUploadedMedicalTests.add(medicalTest);
      String widgetKey = "widget_$currentOpenTestIndex";
      final key = GlobalObjectKey(widgetKey);
      addTestWidget = AddTest(
        key: key,
        onTap: () => openTestPopup(index: currentOpenTestIndex),
        testDate: medicalTest.date,
        testName: medicalTest.name,
        showCloseIcon: currentOpenTestIndex > 0,
        onCloseIconTap: () =>
            addTestsWidget.removeAt(addTestsWidget.length - 1),
        onRemoveIconTap: () => removeTestDetails(index: currentOpenTestIndex),
      )
          .animate()
          .shimmer(
              duration: (1200 / 3).ms,
              color: glLightThemeColor,
              delay: (200.ms))
          .fadeIn(
              duration: (1200 / 3).ms,
              curve: Curves.easeOutQuad,
              delay: (200.ms))
          .slideY();
      addTestsWidget.insert(currentOpenTestIndex, addTestWidget!);
      addTestsWidget.removeAt(currentOpenTestIndex + 1);
      addTestsWidget.refresh();
      _clearTestForm();
    }
  }

  /// Shows info popup
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
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      descTextStyle: const TextStyle(fontSize: 12),
    ).show();
  }

  /// Shows image picker bottom sheet
  void showImagePickerBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: Get.context!,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
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
                onTap: () => pickProfileImage(ImageSource.camera),
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
                onTap: () => pickProfileImage(ImageSource.gallery),
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

  /// Picks profile image
  Future<void> pickProfileImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      profileImage.value = File(pickedImage.path);
      profileImage.refresh();
      await uploadProfileImage();
    }
  }

  /// Uploads profile image
  Future<void> uploadProfileImage() async {
    List<UploadFile> files = [
      UploadFile(
        fileName: profileImage.value.path.split('/').last,
        filePath: profileImage.value.path,
        variableName: "image",
      ),
    ];
    try {
      EasyLoading.show(status: "Loading");
      var response = await _sendRequest(
          "upload-profile-image", {"data": "no_data"},
          files: files);
      EasyLoading.dismiss();
      var jsonData = response.data;
      if (!jsonData['status']) {
        _showToast(jsonData['msg'], type: "info");
      } else {
        userService.currentUser.value.userDP = jsonData['image'];
        userService.currentUser.refresh();
        _showToast("Profile Image Uploaded Successfully",
            type: "info", durationInSecs: 5);
        profileImage.value = File("");
      }
    } catch (e) {
      //print("$e $s");
    }
  }

  /// Gets user coupons
  void getMyCoupons({bool showLoaderOp = false}) async {
    if (showLoaderOp) _showToast('Loading');
    var response =
        await _sendRequest('my-coupons', {"data": "true"}, method: "get");
    if (response.statusCode == 200) {
      json.decode(response.body);
    }
  }

  /// Fetches notifications list
  Future<void> fetchNotificationsList() async {
    if (page == 1) {
      EasyLoading.show(status: "${"Loading".tr}...");
      scrollController = ScrollController();
    }
    try {
      var response = await _sendRequest(
          'notifications', {'page': page.toString()},
          method: "get");
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status']) {
          userService.notificationsCount.value = jsonData['count'] ?? 0;
          userService.notificationsCount.refresh();
          if (page > 1) {
            userService.notifications.value.addAll(
                Helper.parseItem(jsonData['data'], NotificationModel.fromJson));
          } else {
            userService.notifications.value =
                Helper.parseItem(jsonData['data'], NotificationModel.fromJson);
          }
          if (page == 1) {
            EasyLoading.dismiss();
            showLoader.value = false;
            showLoader.refresh();
          }
          showLoadMore = userService.notifications.value.length !=
              userService.notificationsCount.value;
        }
      }
    } catch (e) {
      //caught error
    }
  }

  /// Handles notification actions
  Future<void> notificationAction(NotificationModel item) async {
    Get.back();
    if (item.pageName == "daily_meal") {
      DashboardService.to.currentPage.value = 1;
      RootService.to.isOnHomePage.value = false;
      MealPlanController mealPlanController = Get.find();
      await mealPlanController.fetchTodayMealPlan();
      DashboardService.to.pageController.value.animateToPage(
          DashboardService.to.currentPage.value,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear);
      DashboardService.to.currentPage.refresh();
      DashboardService.to.pageController.refresh();
      RootService.to.isOnHomePage.refresh();
    }
  }

  /// Initializes delete profile popup
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

  /// Starts delete profile countdown
  void startDelay() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownTime--;
      timerText.value = countdownTime >= 1
          ? 'Delete Profile in $countdownTime s'
          : 'Delete Profile';
      isButtonEnabled.value = countdownTime < 1;
      if (countdownTime < 1) timer.cancel();
    });
  }

  /// Toggles checkbox values
  void toggleCheckbox(int checkboxIndex, bool value) {
    if (checkboxIndex == 1) {
      isCheckedDataDeleted.value = value;
    } else if (checkboxIndex == 2) {
      isCheckedPermanent.value = value;
    } else if (checkboxIndex == 3) {
      isCheckedConfirm.value = value;
    }
  }

  /// Shows delete profile dialog
  void showDeleteProfileDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
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
                  style: TextStyle(color: Colors.red, fontSize: 14)),
              const SizedBox(height: 20),
              Obx(() => CheckboxListTile(
                    title: const Text(
                        "I understand that all my data will be deleted permanently.",
                        style: TextStyle(fontSize: 14)),
                    value: isCheckedDataDeleted.value,
                    onChanged: (value) => toggleCheckbox(1, value!),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  )),
              Obx(() => CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    title: const Text(
                        "I understand that this action cannot be undone.",
                        style: TextStyle(fontSize: 14)),
                    value: isCheckedPermanent.value,
                    onChanged: (value) => toggleCheckbox(2, value!),
                  )),
              Obx(() => CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    title: const Text(
                        "I want to proceed with deleting my profile.",
                        style: TextStyle(fontSize: 14)),
                    value: isCheckedConfirm.value,
                    onChanged: (value) => toggleCheckbox(3, value!),
                  )),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: isButtonEnabled.value &&
                            isCheckedDataDeleted.value &&
                            isCheckedPermanent.value &&
                            isCheckedConfirm.value
                        ? () {
                            deleteProfile();
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled.value &&
                              isCheckedDataDeleted.value &&
                              isCheckedPermanent.value &&
                              isCheckedConfirm.value
                          ? Colors.red
                          : Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(timerText.value,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
