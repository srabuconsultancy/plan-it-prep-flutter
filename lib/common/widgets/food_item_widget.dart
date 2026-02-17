import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class FoodItemWidget extends StatelessWidget {
  const FoodItemWidget({
    super.key,
    required this.foodItem,
    this.onLike,
    this.onDislike,
    this.onReplace,
    this.onSelect,
    this.showAddButton = false,
    this.onAddButtonTap,
  }) : assert(!(showAddButton == true && onAddButtonTap == null), "if showAddButton is true then onAddButtonTap should be provided");

  final MealPlanFoodItem foodItem;
  final Function()? onLike;
  final Function()? onDislike;
  final Function()? onReplace;
  final Function()? onSelect;
  final bool showAddButton;
  final Function()? onAddButtonTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white, // White background for the card
            borderRadius: BorderRadius.circular(10), // Rounded corners for the card
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                // Main row to hold the food item details and the add button
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    // Wrap the main food item content in an Expanded widget
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center, // Align to top for multi-line text
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: CachedNetworkImage(
                              imageUrl: foodItem.image!,
                              imageBuilder: (BuildContext context, ImageProvider imageProvider) => Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              memCacheHeight: 100,
                              memCacheWidth: 100,
                              placeholder: (BuildContext context, String url) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Lottie.asset(
                                    'assets/lottie/loader.json', // Ensure this asset exists
                                    height: 80,
                                  ),
                                ),
                              ),
                              errorWidget: (BuildContext context, String url, dynamic error) => Padding(
                                padding: const EdgeInsets.all(20),
                                child: SvgPicture.asset(
                                  'assets/icons/diet-bowl.svg', // Ensure this asset exists
                                  width: 22,
                                  colorFilter: ColorFilter.mode(
                                    glAccentColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Text content column
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Food Name and Type
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /*SizedBox(
                                          width: Get.width * 0.38,
                                          child:*/
                                        foodItem.type == "NV" || foodItem.type == "EG"
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: glLightPrimaryColor,
                                                  border: Border.all(color: Colors.red),
                                                ),
                                                child: const Icon(
                                                  Icons.circle,
                                                  color: Colors.red,
                                                  size: 12,
                                                ),
                                              ) // Placeholder for non-veg
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: glLightPrimaryColor,
                                                  border: Border.all(color: Colors.green),
                                                ),
                                                child: const Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 12,
                                                ),
                                              ),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                        Flexible(
                                          child: Text(
                                            foodItem.name!,
                                            style: Get.theme.textTheme.titleMedium!.copyWith(
                                              fontWeight: FontWeight.w600,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),

                                        // Spacing between name and icon
                                        // Vegetarian/Non-vegetarian icon (simplified for example, use your actual asset logic)

                                        // Placeholder for veg
                                      ],
                                    ),
                                  ),
                                  // Three dots icon with dropdown menu
                                ],
                              ),
                              const SizedBox(height: 10), // Spacing below title
                              // Calories and Weight
                              Row(
                                children: [
                                  Icon(Icons.local_fire_department, color: glCaloriesColor, size: 16), // Fire icon for calories
                                  const SizedBox(width: 4),
                                  Text(
                                    "${Helper.convertQuantityString(foodItem, value: foodItem.calories ?? "")} ${foodItem.calorieUnit ?? 'Kcal'}",
                                    style: Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                  const SizedBox(width: 10),
                                  Icon(Icons.balance, color: glAccentColor, size: 16), // Placeholder for weight icon
                                  const SizedBox(width: 4),
                                  Text(
                                    "${Helper.convertQuantityString(foodItem, value: foodItem.servingSize!)} ${foodItem.servingUnit}",
                                    style: Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10), // Spacing between calories and nutrients

                              // Nutrient bars (Protein, Carbs, Fat)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add Button
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NutrientBarWidget(
                    foodItem: foodItem,
                    label: "Protein",
                    value: double.parse(foodItem.protein!),
                    unit: "g",
                    color: glProteinColor, // Example color for Protein
                  ),
                  NutrientBarWidget(
                    foodItem: foodItem,
                    label: "Carbs",
                    value: double.parse(foodItem.totalCarbohydrates!),
                    unit: "g",
                    color: glCarbColor, // Example color for Carbs
                  ),
                  NutrientBarWidget(
                    foodItem: foodItem,
                    label: "Fat",
                    value: double.parse(foodItem.totalFat!),
                    unit: "g",
                    color: glFatColor, // Example color for Fat
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
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          // height: 90,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            child: Container(
              width: Get.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: glAccentColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showAddButton && onAddButtonTap != null)
                    InkWell(
                      onTap: onAddButtonTap,
                      child: Container(
                        width: 22, // Increased size for a rounded button
                        height: 22,
                        decoration: BoxDecoration(
                          color: glLightPrimaryColor, // Use your theme color for the button
                          shape: BoxShape.circle, // Makes it a rounded button
                          boxShadow: [
                            BoxShadow(
                              color: glLightPrimaryColor.withValues(alpha: 0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.add, // Plus icon for add button
                          color: glAccentColor,
                          size: 18,
                        ),
                      ),
                    ).marginOnly(top: 10, bottom: (onLike != null || onDislike != null || onReplace != null || onSelect != null) ? 0 : 10),
                  if (onLike != null || onDislike != null || onReplace != null || onSelect != null)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_horiz, color: glLightPrimaryColor, size: 22),
                      onSelected: (String result) {
                        // Handle the selection
                        switch (result) {
                          case 'like':
                            onLike?.call();
                            break;
                          case 'dislike':
                            onDislike?.call();
                            break;
                          case 'replace':
                            onReplace?.call();
                            break;
                          case 'select':
                            onSelect?.call();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        if (onLike != null)
                          PopupMenuItem<String>(
                            value: 'like',
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/like.svg", height: 20), // Ensure this asset exists
                                const SizedBox(width: 8),
                                Text('Like'.tr),
                              ],
                            ),
                          ),
                        if (onDislike != null)
                          PopupMenuItem<String>(
                            value: 'dislike',
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/dislike.svg", height: 20), // Ensure this asset exists
                                const SizedBox(width: 8),
                                Text('Dislike'.tr),
                              ],
                            ),
                          ),
                        if (onReplace != null)
                          PopupMenuItem<String>(
                            value: 'replace',
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/convert-icon.svg", height: 20, colorFilter: ColorFilter.mode(glAccentColor, BlendMode.srcIn)), // Ensure this asset exists
                                const SizedBox(width: 8),
                                Text('Replace'.tr),
                              ],
                            ),
                          ),
                        if (onSelect != null)
                          PopupMenuItem<String>(
                            value: 'select'.tr,
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/check.svg", height: 20, colorFilter: ColorFilter.mode(glLightPrimaryColor, BlendMode.srcIn)), // Ensure this asset exists
                                const SizedBox(width: 8),
                                Text('Select'.tr),
                              ],
                            ),
                          ),
                      ],
                    ).marginOnly(top: (showAddButton && onAddButtonTap != null) ? 10 : 0, bottom: 5),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build individual nutrient bars
  /*Widget _buildNutrientBar({
    required String label,
    required double? value,
    required String? unit,
    required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              width: double.infinity, // Full width of the column
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value != null
                    ? (value /
                            (label == "Protein"
                                ? DashboardService.to.data.value.todayMacros.protein
                                : label == "Carbs"
                                    ? DashboardService.to.data.value.todayMacros.carb
                                    : label == "Fat"
                                        ? DashboardService.to.data.value.todayMacros.fat
                                        : DashboardService.to.data.value.todayMacros.fiber))
                        .clamp(0.01, 1.0)
                    : 0.01, // Example: Scale based on a max of 100g,
                // clamped
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${Helper.convertQuantityString(foodItem, value: (value ?? 0).toString())} ${unit ?? ''}",
              style: Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            Text(
              label,
              style: Get.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }*/
}
