// import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../core.dart';

class MealPlanController extends GetxController {
  UserService authService = Get.find();
  Timer? _debounce;

  final Duration _debounceDuration = const Duration(milliseconds: 500);
  final GlobalKey<FormFieldState> searchFieldKey = GlobalKey<FormFieldState>();

  int foodPage = 1;
  int foodItemsTotal = 1;
  DateTime now = DateTime.now();
  String formattedDate = "";
  @override
  void onInit() {
    super.onInit();

    formattedDate = DateFormat('yyyy-MM-dd').format(now);

    MealPlanService.to.selectedDateForMeal.value = formattedDate;
  }

  fetchMealPlan({int day = 1, bool showLoader = false}) async {
    //print("fetchMeanPlan");
    if (showLoader) {
      EasyLoading.show(status: "Loading");
    }
    try {
      var response = await Helper.sendRequestToServer(endPoint: 'fetch-meals', requestData: {"day": day.toString()});
      EasyLoading.dismiss();

      var responseResult = json.decode(response.body);
      if (responseResult["status"]) {
        MealPlanService.to.mealPlan.value = MealPlan.fromJson(responseResult);
        MealPlanService.to.mealPlan.refresh();
        return "Done";
      } else {
        Helper.showToast(type: "error", msg: responseResult["msg"], durationInSecs: 2);
        return "Error";
      }
    } catch (e) {
      // AwesomeDialog(
      //   dismissOnBackKeyPress: true,
      //   dismissOnTouchOutside: false,
      //   dialogBackgroundColor: Get.theme.primaryColor,
      //   context: Get.context!,
      //   animType: AnimType.scale,
      //   dialogType: DialogType.info,
      //   showCloseIcon: true,
      //   body: Padding(
      //     padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      //     child: Column(
      //       children: [
      //         "Your meal plan has not been assigned to you yet, please try after sometime."
      //             .text
      //             .textStyle(Get.theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.normal))
      //             .align(TextAlign.center)
      //             .make()
      //             .pOnly(bottom: 5),
      //         const SizedBox(
      //           height: 20,
      //         ),
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      //           ),
      //           child: "OK".tr.text.center.make(),
      //           onPressed: () {
      //             Get.backLegacy(closeOverlays: true);
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ).show();

      return "Error";
    }
  }

  fetchMyMealPlan({String date = "", bool showLoader = false}) async {
    //print("fetchMyMealPlan");
    if (showLoader) {
      EasyLoading.show(status: "Loading");
    }
    var response = await Helper.sendRequestToServer(endPoint: 'fetch-my-meals', requestData: {"date": date});
    EasyLoading.dismiss();
    var responseResult = json.decode(response.body);
    if (responseResult["status"]) {
      MealPlanService.to.myMeal.value = MealPlan.fromJson(responseResult);
      MealPlanService.to.myMeal.refresh();
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: responseResult["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  fetchTodayMealPlan() async {
    fetchMealPlan(day: getTodayDayNumber());
  }

  int getDayNumber(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'monday':
        return 1;
      case 'tuesday':
        return 2;
      case 'wednesday':
        return 3;
      case 'thursday':
        return 4;
      case 'friday':
        return 5;
      case 'saturday':
        return 6;
      case 'sunday':
        return 7;
      default:
        throw ArgumentError('Invalid day name: $dayName');
    }
  }

  int getTodayDayNumber() {
    int dayOfWeek = DateTime.now().weekday;
    return dayOfWeek;
  }

  addFoodToMeal({int foodId = 0}) async {
    var response = await Helper.sendRequestToServer(endPoint: 'add-food-to-meal', requestData: {"food_id": foodId.toString()}, method: "post");
    if (response.statusCode == 200) {
      //print("addFoodToMeal response success");
      //print(response.body);
      var jsonData = json.decode(response.body)['status'];
      if (jsonData['status']) {
        Helper.showToast(msg: "Food Added successfully");
      }
      return true;
    } else {
      return false;
      // throw  Exception(response.body);
    }
  }

  void addFood() {
    Dialogs.materialDialog(
      color: Colors.white,
      title: 'Profile Create successfully',
      msgAlign: TextAlign.center,
      msg: 'Your customized diet chart is being prepared. Kindly Wait for 24 hours.',
      lottieBuilder: Lottie.asset(
        'assets/lottie/preparing.json',
        fit: BoxFit.contain,
      ),
      context: Get.context!,
      // isDismissible: true,
      useRootNavigator: true,
      actionsBuilder: (context) => [
        IconsButton(
          onPressed: () {
            //Get.back(closeOverlays: true);
            Get.backLegacy(closeOverlays: true);

            Get.offNamed(Routes.dashboard);
          },
          text: 'Add',
          iconData: Icons.done,
          color: glLightThemeColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  void onSearchChanged(String? query) {
    // Duration for debounce delay

    // Cancel the previous debounce timer if it's active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(_debounceDuration, () async {
      // Place the action that you want to perform after debounce here
      //print('Search query: $query');
      foodPage = 1;
      await getFoodItems(query: query!);
    });
  }

  openFoodListForAddToMeal(Meal meal) async {
    MealPlanService.to.selectedMeal.value = meal.id!;
    MealPlanService.to.selectedMealName.value = meal.name!;
    MealPlanService.to.selectedMeal.refresh();
    EasyLoading.show(status: "${"Loading".tr}..${"Please Wait".tr}");
    await getFoodItems();
    EasyLoading.dismiss();
    Get.toNamed(Routes.listFood);
  }

  getFoodItems({String query = ""}) async {
    //print("getFoodItems $query");
    if (foodPage > 1 && MealPlanService.to.foodItems.value.length == foodItemsTotal) {
      //print("getFoodItems returned");
      return;
    }
    var value = await Helper.sendRequestToServer(
      endPoint: 'get-food-items',
      requestData: {"search": query, "page": foodPage.toString()},
    );
    var response = json.decode(value.body);
    if (response["status"]) {
      if (foodPage == 1) {
        foodItemsTotal = response["total"];
        MealPlanService.to.foodItems.value = Helper.parseItem(response["data"], MealPlanFoodItem.fromJson);
      } else {
        MealPlanService.to.foodItems.value.addAll(Helper.parseItem(response["data"], MealPlanFoodItem.fromJson));
      }
      MealPlanService.to.foodItems.refresh();
      foodPage++;
      return "Done";
    } else {
      Helper.showToast(type: "error", msg: response["msg"], durationInSecs: 2);
      return "Error";
    }
  }

  void openFoodItemDetailPopup(MealPlanFoodItem foodItem) {
    //print("asdasdasdasdasdas");
    MealPlanService.to.selectedFoodItem.value = foodItem;
    MealPlanService.to.selectedQty.value = double.parse(foodItem.servingSize!);
    Dialogs.materialDialog(
      customViewPosition: CustomViewPosition.AFTER_ACTION,
      color: Colors.white,
      title: '${foodItem.name}',
      msgAlign: TextAlign.center,

      msg: 'Add ${foodItem.name} to your meal',
      barrierDismissible: true,
      customView: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          children: [
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_fire_department, color: glCaloriesColor, size: 20), // Fire icon for calories
                        const SizedBox(width: 4),
                        Text(
                          "${Helper.convertQuantityString(foodItem, value: foodItem.calories ?? "")} ${foodItem.calorieUnit ?? 'Kcal'}",
                          style: Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, color: Colors.grey.shade600, fontSize: 14.5),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*Text(
                      "Calories: ${((double.parse(MealPlanService.to.selectedFoodItem.value.calories!) / double.parse(MealPlanService.to.selectedFoodItem.value.servingSize!)) * MealPlanService.to.selectedQty.value!).toStringAsFixed(1)}\n"
                      "Carbs: ${((double.parse(MealPlanService.to.selectedFoodItem.value.totalCarbohydrates!) / double.parse(MealPlanService.to.selectedFoodItem.value.servingSize!)) * MealPlanService.to.selectedQty.value!).toStringAsFixed(1)}\n"
                      "Protein: ${((double.parse(MealPlanService.to.selectedFoodItem.value.protein!) / double.parse(MealPlanService.to.selectedFoodItem.value.servingSize!)) * MealPlanService.to.selectedQty.value!).toStringAsFixed(1)}\n"
                      "Fat: ${((double.parse(MealPlanService.to.selectedFoodItem.value.totalFat!) / double.parse(MealPlanService.to.selectedFoodItem.value.servingSize!)) * MealPlanService.to.selectedQty.value!).toStringAsFixed(1)}\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: glLightIconColor,
                        fontSize: 14,
                      ),
                    ),*/
                    SizedBox(
                      width: Get.width / 1.5,
                      child: Row(
                        children: [
                          NutrientBarWidget(
                            foodItem: foodItem,
                            label: "Protein",
                            value: double.parse(foodItem.protein!),
                            unit: "g",
                            color: glProteinColor, // Example color for Protein
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          NutrientBarWidget(
                            foodItem: foodItem,
                            label: "Carbs",
                            value: double.parse(foodItem.totalCarbohydrates!),
                            unit: "g",
                            color: glCarbColor, // Example color for Carbs
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Get.width / 1.5,
                      child: Row(
                        children: [
                          NutrientBarWidget(
                            foodItem: foodItem,
                            label: "Fat",
                            value: double.parse(foodItem.totalFat!),
                            unit: "g",
                            color: glFatColor, // Example color for Fat
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          NutrientBarWidget(
                            foodItem: foodItem,
                            label: "Fiber",
                            value: double.parse(foodItem.dietaryFiber!),
                            unit: "g",
                            color: glFiberColor, // Example color for Fat
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            "Enter Quantity".text.make().centered(),
            Center(
              child: NumberSelector(
                value: double.parse(MealPlanService.to.selectedFoodItem.value.servingSize!),
                selectedUnit: MealPlanService.to.selectedFoodItem.value.servingUnit!,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            IconsButton(
              onPressed: () {
                //Get.back(closeOverlays: true);
                addFoodItemToMeal();
                Get.backLegacy(closeOverlays: true);
                // Get.offNamed(Routes.dashboard);
              },
              text: 'Add',
              iconData: Icons.add_circle,
              color: glAccentColor,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ).marginOnly(left: 20, right: 20),

          ],
        ),
      ),
      context: Get.context!,
      // isDismissible: true,
      useRootNavigator: true,
      actionsBuilder: (context) => [],
    );

  }



  Future<void> addFoodItemToMeal() async {
    //print("submitFoodItem");
    var response = await Helper.sendRequestToServer(
      endPoint: 'save-intake-food-item',
      requestData: {
        "food_id": MealPlanService.to.selectedFoodItem.value.id.toString(),
        "meal_id": MealPlanService.to.selectedMeal.value.toString(),
        "quantity": MealPlanService.to.selectedQty.value.toString(),
        "date": MealPlanService.to.selectedDateForMeal.value == "" ? DateFormat('yyyy-MM-dd').format(now) : MealPlanService.to.selectedDateForMeal.value,
      },
      method: "post",
    );

    var responseResult = json.decode(response.body);
    if (responseResult["status"]) {
      DashboardController dashboardController = Get.find();
      await dashboardController.getData();
      Helper.showToast(type: "success", msg: "Food item added successfully", durationInSecs: 3);

      // return "Done";
    } else {
      Helper.showToast(type: "error", msg: responseResult["msg"], durationInSecs: 2);
      // return "Error";
    }
  }

  void likeFoodItem({required int foodItemId}) async {
    var response = await Helper.sendRequestToServer(endPoint: "like-dislike-food-item", requestData: {"food_item_id": foodItemId, "type": "L"}, method: "post");
    //print("response.body.toString()");
    //print(response.body.toString());

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        Helper.showToast(type: "success", msg: "Food Items added to liked items.");
      }
    }
  }

  void openDislikePopup({required foodItemId}) {
    //print("openDislikePopup $foodItemId");
    AwesomeDialog(
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      showCloseIcon: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Column(
          children: [
            "Do you want to replace this food Item from your diet plan too?"
                .text
                .textStyle(Get.theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.normal))
                .align(TextAlign.center)
                .make()
                .pOnly(bottom: 5),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: "Yes".tr.text.center.make(),
                    onPressed: () {
                      disLikeFoodItem(replace: true, foodItemId: foodItemId);
                    },
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: "No".tr.text.center.make(),
                    onPressed: () {
                      disLikeFoodItem(replace: false, foodItemId: foodItemId);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ).show();
  }

  Future<void> openReplacePopup({required MealPlanFoodItem foodItem}) async {
    EasyLoading.show();
    var response = await Helper.sendRequestToServer(endPoint: "similar-food-items", requestData: {"food_item_id": foodItem.id.toString()});
    //print(response.body.toString());
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        MealPlanService.to.replaceFoodItems.value = Helper.parseItem(jsonData['data'], MealPlanFoodItem.fromJson);
        MealPlanService.to.replaceFoodItems.refresh();
      }
    }
    EasyLoading.dismiss();
    //print("openReplacePopup ${foodItem.id} MealPlanService.to.replaceFoodItems.value ${MealPlanService.to.replaceFoodItems.value.length}");
    AwesomeDialog(
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogBackgroundColor: Get.theme.primaryColor,
      context: Get.context!,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      showCloseIcon: true,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Obx(
          () => Column(
            children: [
              if (MealPlanService.to.replaceFoodItems.value.isNotEmpty)
                "Here are few similar food items to replace with ${foodItem.name}."
                    .text
                    .textStyle(Get.theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.normal))
                    .align(TextAlign.center)
                    .make()
                    .pOnly(bottom: 5),
              const SizedBox(
                height: 20,
              ),
              MealPlanService.to.replaceFoodItems.value.isNotEmpty
                  ? Wrap(
                      children: MealPlanService.to.replaceFoodItems.value.map((replaceFood) {
                        return Builder(
                          builder: (BuildContext context) {
                            return FoodItemWidget(
                              foodItem: replaceFood,
                              onSelect: () {
                                replaceSelectedFoodItem(foodItemId: foodItem.id!, replaceFoodItem: replaceFood);
                              },
                            ).paddingSymmetric(horizontal: 2, vertical: 5);
                          },
                        );
                      }).toList(),
                    )
                  : Container(
                      width: Get.width,
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: "No Replacement food Items found".tr.text.center.make().centered(),
                    ),
            ],
          ),
        ),
      ),
    ).show();
  }

  void disLikeFoodItem({required int foodItemId, required bool replace}) async {
    var response = await Helper.sendRequestToServer(endPoint: "like-dislike-food-item", requestData: {"food_item_id": foodItemId, "type": "D", "replace": replace}, method: "post");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 'success') {
        Helper.showToast(type: "success", msg: "Action submitted");
      }
    }
  }

  void replaceSelectedFoodItem({required int foodItemId, required MealPlanFoodItem replaceFoodItem}) async {
    var response = await Helper.sendRequestToServer(endPoint: "replace-food-item", requestData: {"food_item_id": foodItemId, "replace_food_item_id": replaceFoodItem.id}, method: "post");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status']) {
        Helper.showToast(type: "success", msg: "Food Item Replaced");
        replaceFoodItemInMeals(oldFoodItemId: foodItemId, replaceFoodItem: replaceFoodItem);
      }
    }
    Get.backLegacy(closeOverlays: true);
  }

  void replaceFoodItemInMeals({required int oldFoodItemId, required MealPlanFoodItem replaceFoodItem}) {
    //print("replaceFoodItemInMeals $oldFoodItemId ${replaceFoodItem.name} ${replaceFoodItem.id}");
    for (var meal in MealPlanService.to.mealPlan.value!.meals) {
      for (var i = 0; i < meal.mealPlanItems!.length; i++) {
        if (meal.mealPlanItems![i].id == oldFoodItemId) {
          meal.mealPlanItems![i] = replaceFoodItem;
          break; // exit inner loop once item is replaced
        }
      }
    }
    MealPlanService.to.mealPlan.refresh();
  }
}
