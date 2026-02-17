import 'package:get/get.dart';

import '../core.dart';

class MealPlanService extends GetxService {
  static MealPlanService get to => Get.find();
  var mealPlan = Rxn<MealPlan>();
  // var myMeal = Rxn<MealPlan>();
  var myMeal = MealPlan().obs;
  var selectedMeal = 1.obs;
  var foodItems = <MealPlanFoodItem>[].obs;
  var replaceFoodItems = <MealPlanFoodItem>[].obs;
  var selectedFoodItem = MealPlanFoodItem().obs;
  var selectedQty = 1.0.obs;
  var selectedServingSize = "".obs;
  var selectedDateForMeal = "".obs;
  var selectedMealDate = DateTime.now().obs;

  var myMealPlanPage = false.obs;

  var selectedMealName = "".obs;
  var myMealPlanPageIsAtBottom = false.obs;
}
