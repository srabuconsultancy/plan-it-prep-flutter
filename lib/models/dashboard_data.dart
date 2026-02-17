import '../core.dart';

class DashboardData {
  Macros todayMacros = Macros();
  Macros todayMacrosConsumed = Macros();
  List<Macros> weeklyMacrosConsumed = [];
  List<Macros> dailyWeeklyMacros = [];
  List<Meal> meals = [];
  double currentWeight = 0.0;
  double targetWeight = 0.0;
  double initialWeight = 0.0;

  String targetDate = "";
  DashboardData();

  DashboardData.fromJson(Map<String, dynamic> json) {
    // Print some info about the parsing process (optional)

    // try {
    todayMacros = json['today_macros'] != null ? Macros.fromJson(json['today_macros']) : Macros();

    todayMacrosConsumed = json['today_macros_consumed'] != null ? Macros.fromJson(json['today_macros_consumed']) : Macros();

    weeklyMacrosConsumed = json['weekly_macros_consumed'] == null ? [] : Helper.parseItem(json['weekly_macros_consumed'], Macros.fromJson);
    dailyWeeklyMacros = json['daily_weekly_macros'] == null ? [] : Helper.parseItem(json['daily_weekly_macros'], Macros.fromJson);
    meals = json['meal_macros_consumed'] == null ? [] : Helper.parseItem(json['meal_macros_consumed'], Meal.fromJson);
    currentWeight = json['my_current_weight'] != null ? double.parse(json['my_current_weight'].toString()) : 0.0;
    targetWeight = json['my_target_weight'] != null ? double.parse(json['my_target_weight'].toString()) : 0.0;
    initialWeight = json['initial_weight'] != null ? double.parse(json['initial_weight'].toString()) : 0.0;
    targetDate = json['target_date'] ?? "";

    // } catch (e) {
    //   todayMacros = Macros();
    //   todayMacrosConsumed = Macros();
    //   weeklyMacrosConsumed = [];
    // }
  }
}
