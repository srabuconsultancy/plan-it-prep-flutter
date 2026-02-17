import 'package:nutri_ai/models/appliance.dart';
import 'package:nutri_ai/models/cooking_prep.dart';
import 'package:nutri_ai/models/cooking_time.dart';
import 'package:nutri_ai/models/cuisine.dart';
import 'package:nutri_ai/models/meal_count.dart';
import 'package:nutri_ai/models/meal_prep_schedule.dart';

import '../../core.dart';

class AppConfig {
  String appName = "";
  String appVersion = "1.0";
  List<FitnessLevel> fitnessLevels = [];
  List<MedicalIssue> medicalIssues = [];
  List<ExercisePlanDays> exercisePlanDays = [];
  List<DietPreference> dietPreference = [];
  List<Allergen> allergens = [];
  List<DietRegime> dietRegimes = [];
  List<Goal> goals = [];
  List<CookingPrep> cookingPreps = [];
  List<Appliance> appliance = [];
  List<Cuisine> cuisine = [];
  List<CookingTime> cookingTime = [];
  List<MealPrepSchedule> mealPrepSchedule = [];
  List<MealCount> mealCount = [];

  List<Country> countries = [];
  List<MedicalTest> tests = [];

  bool googleLogin = true;
  bool mobileLogin = true;
  bool emailLogin = false;
  bool appleLogin = false;
  String contactNo = "";
  bool testingAndroid = false;
  bool testingIos = false;
  bool enableFreeMemberShip = false;
  bool showPaymentsMemberships = false;

  AppConfig();

  AppConfig.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse lists
    List<T> parseList<T>(
        dynamic jsonList, T Function(Map<String, dynamic>) fromJson) {
      if (jsonList == null || jsonList is! List || jsonList.isEmpty) {
        return [];
      }
      return Helper.parseItem(jsonList, fromJson);
    }

    try {
      appName = json['app_name'] ?? "";
      appVersion = json['app_version'] ?? "";
      emailLogin = json['email_login'] ?? true;
      mobileLogin = json['mobile_login'] ?? true;
      googleLogin = json['google_login'] ?? true;
      appleLogin = json['apple_login'] ?? true;
      contactNo = json['contact_no'] ?? true;
      testingAndroid = json['testing_android'] ?? false;
      testingIos = json['testing_ios'] ?? false;
      enableFreeMemberShip = json['enable_free_membership'] ?? false;
      showPaymentsMemberships = json['show_payments_memberships'] ?? false;

      // --- 
      // FIX: Correctly parse all lists using the Helper
      // (Assuming all models have a .fromJson constructor)
      // ---
      
      // These were parsed incorrectly
      cookingPreps = parseList(json['cooking_preps'], CookingPrep.fromJson); // Fixed typo 'cooking_pres'
      mealCount = parseList(json['meal_count'], MealCount.fromJson);
      mealPrepSchedule = parseList(json['meal_prep_schedule'], MealPrepSchedule.fromJson);
      cookingTime = parseList(json['cooking_time'], CookingTime.fromJson);
      cuisine = parseList(json['cuisines'], Cuisine.fromJson);
      
      // This one was missing from your constructor
      appliance = parseList(json['appliances'], Appliance.fromJson); 

      // These were already being parsed (but I've updated them to be null-safe)
      fitnessLevels = parseList(json['fitness_levels'], FitnessLevel.fromJson);
      medicalIssues = parseList(json['medical_issues'], MedicalIssue.fromJson);
      exercisePlanDays = parseList(json['exercise_plan_days'], ExercisePlanDays.fromJson);
      dietPreference = parseList(json['diet_types'], DietPreference.fromJson);
      allergens = parseList(json['allergens'], Allergen.fromJson);
      dietRegimes = parseList(json['diet_regimes'], DietRegime.fromJson);
      goals = parseList(json['goals'], Goal.fromJson);
      countries = parseList(json['countries'], Country.fromJson);
      tests = parseList(json['tests'], MedicalTest.fromJson);

    } catch (e) {
      //print("AppConfig.fromJson Error: $e $s");
      appName = "";
      appVersion = "";
    }
  }
  /*Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };*/
}